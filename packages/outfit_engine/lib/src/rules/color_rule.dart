import '../models/color_classifier.dart';
import '../models/garment_enums.dart';
import 'outfit_rule.dart';

final class ColorRule implements OutfitRule {
  const ColorRule();

  @override
  String get id => 'color';

  @override
  RuleResult evaluate(OutfitCandidate candidate, EngineContext context) {
    var accents = 0.0;
    var protagonists = 0;
    var hasWarm = false;
    var hasCool = false;
    var hasNeutral = false;
    var supportingGarmentsAreNeutral = true;
    for (final garment in candidate.garments) {
      final primary = garment.colorFamily;
      final secondary =
          garment.secondaryColorFamily ??
          (garment.secondaryColor == null
              ? null
              : classifyColor(garment.secondaryColor!));
      final isNeutral =
          primary == ColorFamily.neutral &&
          (secondary == null || secondary == ColorFamily.neutral);
      if (garment.pattern != GarmentPattern.solid ||
          garment.secondaryColor != null) {
        protagonists++;
      } else {
        supportingGarmentsAreNeutral &= isNeutral;
      }
      hasNeutral |= isNeutral;
      hasWarm |= primary == ColorFamily.warm || secondary == ColorFamily.warm;
      hasCool |= primary == ColorFamily.cool || secondary == ColorFamily.cool;
      if (primary == ColorFamily.accent) accents++;
      if (secondary == ColorFamily.accent) accents += 0.5;
    }
    if (accents > 1) return const RuleResult(0.1);
    if (protagonists > 1) return const RuleResult(0.25);
    if (protagonists == 1 && supportingGarmentsAreNeutral) {
      return const RuleResult(
        1,
        reason: 'Una sola prenda protagonista, el resto la acompaña',
      );
    }
    if (hasWarm && hasCool && !hasNeutral) return const RuleResult(0.55);
    if (!hasWarm && !hasCool && accents == 0) {
      return const RuleResult(0.8, reason: 'Paleta neutra y fácil de combinar');
    }
    if (hasNeutral && !(hasWarm && hasCool)) {
      return const RuleResult(1, reason: 'Base neutra con un toque de color');
    }
    return const RuleResult(0.85);
  }
}
