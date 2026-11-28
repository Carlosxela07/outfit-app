import '../models/garment_enums.dart';
import 'outfit_rule.dart';

final class VolumeRule implements OutfitRule {
  const VolumeRule();

  @override
  String get id => 'volume';

  @override
  RuleResult evaluate(OutfitCandidate candidate, EngineContext context) {
    final topFit = candidate.top.fit;
    final bottomFit = candidate.bottom.fit;
    if (topFit == null || bottomFit == null) return const RuleResult(0.7);
    final looseTop = topFit == Fit.loose;
    final looseBottom = bottomFit == Fit.loose;
    if (looseTop && looseBottom) return const RuleResult(0.3);
    if (looseTop != looseBottom) {
      return const RuleResult(1, reason: 'Equilibra volumen arriba y abajo');
    }
    return const RuleResult(0.7);
  }
}
