import '../models/garment.dart';
import '../models/style_profile.dart';

abstract interface class OutfitRule {
  String get id;

  RuleResult evaluate(OutfitCandidate candidate, EngineContext context);
}

final class RuleResult {
  const RuleResult(this.score, {this.reason})
    : assert(score >= 0 && score <= 1);

  final double score;
  final String? reason;
}

final class OutfitCandidate {
  OutfitCandidate({
    required this.top,
    required this.bottom,
    required this.shoes,
    this.outerwear,
  }) : garments = List.unmodifiable([top, bottom, shoes, ?outerwear]);

  final Garment top;
  final Garment bottom;
  final Garment shoes;
  final Garment? outerwear;
  final List<Garment> garments;
}

final class EngineContext {
  const EngineContext({required this.style, required this.now});

  final StyleProfile style;
  final DateTime now;
}
