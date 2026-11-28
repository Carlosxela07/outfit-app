import 'dart:math';

import 'outfit_rule.dart';

final class FormalityRule implements OutfitRule {
  const FormalityRule();

  @override
  String get id => 'formality';

  @override
  RuleResult evaluate(OutfitCandidate candidate, EngineContext context) {
    var lowest = candidate.top.formality;
    var highest = lowest;
    for (final garment in candidate.garments) {
      lowest = min(lowest, garment.formality);
      highest = max(highest, garment.formality);
    }
    return switch (highest - lowest) {
      <= 1 => const RuleResult(
        1,
        reason: 'Todo está en el mismo nivel de formalidad',
      ),
      2 => const RuleResult(0.6),
      _ => const RuleResult(0.1),
    };
  }
}
