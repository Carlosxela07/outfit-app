import 'dart:math';

import '../models/garment.dart';
import '../models/garment_enums.dart';
import '../models/outfit_suggestion.dart';
import '../models/style_profile.dart';
import '../rules/color_rule.dart';
import '../rules/formality_rule.dart';
import '../rules/outfit_rule.dart';
import '../rules/rotation_rule.dart';
import '../rules/style_rule.dart';
import '../rules/volume_rule.dart';

const _requiredCategories = [
  GarmentCategory.top,
  GarmentCategory.bottom,
  GarmentCategory.shoes,
];

Set<GarmentCategory> missingFor(List<Garment> closet) {
  final available = {
    for (final garment in closet)
      if (!garment.isVirtual) garment.category,
  };
  return _requiredCategories.toSet().difference(available);
}

final class OutfitEngine {
  const OutfitEngine({List<OutfitRule>? rules})
    : _rules =
          rules ??
          const [
            FormalityRule(),
            StyleRule(),
            ColorRule(),
            VolumeRule(),
            RotationRule(),
          ];

  static const _sampleLimit = 5000;
  final List<OutfitRule> _rules;

  List<OutfitSuggestion> suggest(
    List<Garment> closet, {
    required StyleProfile style,
    required DateTime now,
    int count = 3,
    int seed = 0,
  }) {
    if (count <= 0) return [];
    final byCategory = {
      for (final category in [
        ..._requiredCategories,
        GarmentCategory.outerwear,
      ])
        category: <Garment>[],
    };
    for (final garment in closet) {
      if (!garment.isVirtual) byCategory[garment.category]?.add(garment);
    }
    final tops = byCategory[GarmentCategory.top]!;
    final bottoms = byCategory[GarmentCategory.bottom]!;
    final shoes = byCategory[GarmentCategory.shoes]!;
    final layers = byCategory[GarmentCategory.outerwear]!;
    final combinations = tops.length * bottoms.length * shoes.length;
    if (combinations == 0) return [];

    final context = EngineContext(style: style, now: now);
    final weights = [
      for (final rule in _rules) style.ruleWeights[rule.id] ?? 1.0,
    ];
    final totalWeight = weights.fold(0.0, (sum, weight) => sum + weight);
    final random = Random(seed);
    final ranked =
        <({double rank, int index, OutfitCandidate candidate, double score})>[];
    for (final index in _indices(combinations, random)) {
      final pair = index ~/ shoes.length;
      final top = tops[pair ~/ bottoms.length];
      final bottom = bottoms[pair % bottoms.length];
      final footwear = shoes[index % shoes.length];
      var best = OutfitCandidate(top: top, bottom: bottom, shoes: footwear);
      var bestScore = _score(best, context, weights, totalWeight);
      for (final layer in layers) {
        final candidate = OutfitCandidate(
          top: top,
          bottom: bottom,
          shoes: footwear,
          outerwear: layer,
        );
        final score = _score(candidate, context, weights, totalWeight);
        if (score > bestScore) {
          best = candidate;
          bestScore = score;
        }
      }
      ranked.add((
        rank: bestScore * (0.97 + random.nextDouble() * 0.06),
        index: index,
        candidate: best,
        score: bestScore,
      ));
    }
    ranked.sort((a, b) {
      final order = b.rank.compareTo(a.rank);
      return order == 0 ? a.index.compareTo(b.index) : order;
    });

    final usedPairs = <(String, String)>{};
    final suggestions = <OutfitSuggestion>[];
    for (final item in ranked) {
      final candidate = item.candidate;
      if (!usedPairs.add((candidate.top.id, candidate.bottom.id))) continue;
      suggestions.add(
        OutfitSuggestion(
          top: candidate.top,
          bottom: candidate.bottom,
          shoes: candidate.shoes,
          outerwear: candidate.outerwear,
          score: item.score,
          reasons: _reasons(candidate, context, weights),
        ),
      );
      if (suggestions.length == count) break;
    }
    return suggestions;
  }

  Iterable<int> _indices(int combinations, Random random) sync* {
    if (combinations <= _sampleLimit) {
      for (var index = 0; index < combinations; index++) {
        yield index;
      }
      return;
    }

    // Floyd's algorithm samples uniformly without storing the full product.
    final sample = <int>{};
    for (
      var index = combinations - _sampleLimit;
      index < combinations;
      index++
    ) {
      final draw = _randomIndex(random, index + 1);
      if (!sample.add(draw)) sample.add(index);
    }
    yield* sample;
  }

  int _randomIndex(Random random, int limit) {
    const maxBound = 1 << 32;
    if (limit <= maxBound) return random.nextInt(limit);
    // Reject out-of-range values for products above Random.nextInt's bound.
    final pages = (limit - 1) ~/ maxBound + 1;
    while (true) {
      final draw = random.nextInt(pages) * maxBound + random.nextInt(maxBound);
      if (draw < limit && draw >= 0) return draw;
    }
  }

  double _score(
    OutfitCandidate candidate,
    EngineContext context,
    List<double> weights,
    double totalWeight,
  ) {
    if (totalWeight == 0) return 0;
    var total = 0.0;
    for (var index = 0; index < _rules.length; index++) {
      if (weights[index] <= 0) continue;
      total +=
          weights[index] * _rules[index].evaluate(candidate, context).score;
    }
    return (total / totalWeight).clamp(0, 1);
  }

  List<String> _reasons(
    OutfitCandidate candidate,
    EngineContext context,
    List<double> weights,
  ) {
    final contributions = <({double score, int index, String reason})>[];
    for (var index = 0; index < _rules.length; index++) {
      if (weights[index] <= 0) continue;
      final result = _rules[index].evaluate(candidate, context);
      if (result.reason case final reason?) {
        contributions.add((
          score: weights[index] * result.score,
          index: index,
          reason: reason,
        ));
      }
    }
    contributions.sort((a, b) {
      final order = b.score.compareTo(a.score);
      return order == 0 ? a.index.compareTo(b.index) : order;
    });
    if (contributions.isEmpty) return ['Combinación equilibrada'];
    return contributions.map((entry) => entry.reason).toSet().take(3).toList();
  }
}
