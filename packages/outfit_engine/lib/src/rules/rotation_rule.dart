import 'outfit_rule.dart';

final class RotationRule implements OutfitRule {
  const RotationRule();

  @override
  String get id => 'rotation';

  @override
  RuleResult evaluate(OutfitCandidate candidate, EngineContext context) {
    final now = context.now;
    final today = DateTime.utc(now.year, now.month, now.day);
    var total = 0.0;
    var allLongUnworn = true;
    for (final garment in candidate.garments) {
      final lastWornAt = garment.lastWornAt;
      if (lastWornAt == null) {
        total += 1;
        allLongUnworn = false;
        continue;
      }

      final worn = now.isUtc ? lastWornAt.toUtc() : lastWornAt.toLocal();
      final wornDay = DateTime.utc(worn.year, worn.month, worn.day);
      final days = today.difference(wornDay).inDays;
      total += switch (days) {
        <= 0 => 0,
        <= 2 => 0.3,
        <= 6 => 0.7,
        _ => 1,
      };
      if (days < 7) allLongUnworn = false;
    }
    return RuleResult(
      total / candidate.garments.length,
      reason: allLongUnworn ? 'Rescata prendas que no usas hace tiempo' : null,
    );
  }
}
