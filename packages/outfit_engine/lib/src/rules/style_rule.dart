import 'dart:math';

import 'outfit_rule.dart';

final class StyleRule implements OutfitRule {
  const StyleRule();

  @override
  String get id => 'style';

  @override
  RuleResult evaluate(OutfitCandidate candidate, EngineContext context) {
    final total = candidate.garments.fold(
      candidate.shoes.formality,
      (sum, garment) => sum + garment.formality,
    );
    final average = total / (candidate.garments.length + 1);
    final (minimum, maximum) = context.style.formalityRange;
    final distance = max(minimum - average, average - maximum);
    if (distance <= 0) {
      return RuleResult(
        1,
        reason: 'Encaja con el estilo ${context.style.name}',
      );
    }
    return RuleResult((1 - distance / 4).clamp(0, 1));
  }
}
