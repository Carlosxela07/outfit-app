import 'package:outfit_engine/outfit_engine.dart';
import 'package:test/test.dart';

import 'fixtures.dart' as fixture;

void main() {
  final context = EngineContext(style: fixture.casual, now: fixture.now);
  final top = fixture.top;
  final bottom = fixture.bottom;
  final shoes = fixture.shoes;
  RuleResult evaluate(
    OutfitRule rule, {
    Garment? upper,
    Garment? lower,
    Garment? footwear,
    Garment? outerwear,
  }) => rule.evaluate(
    OutfitCandidate(
      top: upper ?? top,
      bottom: lower ?? bottom,
      shoes: footwear ?? shoes,
      outerwear: outerwear,
    ),
    context,
  );

  test('formality considers the full range including layers', () {
    const rule = FormalityRule();
    expect(evaluate(rule).reason, isNotNull);
    expect(
      evaluate(rule, outerwear: fixture.layer.copyWith(formality: 3)).score,
      1,
    );
    expect(evaluate(rule, footwear: shoes.copyWith(formality: 4)).score, 0.6);
    expect(
      evaluate(rule, outerwear: fixture.layer.copyWith(formality: 5)).score,
      0.1,
    );
  });

  test('style gives footwear double weight and reduces by distance', () {
    const rule = StyleRule();
    expect(evaluate(rule).reason, 'Encaja con el estilo Casual');
    expect(evaluate(rule, footwear: shoes.copyWith(formality: 4)).score, 0.75);
    expect(evaluate(rule, upper: top.copyWith(formality: 4)).score, 0.875);
  });

  test('color balances accents, temperature and protagonists', () {
    const rule = ColorRule();
    final accent = top.copyWith(colorFamily: ColorFamily.accent);
    final warm = top.copyWith(colorFamily: ColorFamily.warm);
    final cool = bottom.copyWith(colorFamily: ColorFamily.cool);
    expect(evaluate(rule).score, 0.8);
    expect(evaluate(rule, upper: accent).score, 1);
    expect(
      evaluate(
        rule,
        upper: accent,
        lower: bottom.copyWith(colorFamily: ColorFamily.accent),
      ).score,
      0.1,
    );
    expect(
      evaluate(rule, upper: warm, lower: cool).score,
      greaterThan(
        evaluate(
          rule,
          upper: warm,
          lower: cool,
          footwear: shoes.copyWith(colorFamily: ColorFamily.cool),
        ).score,
      ),
    );
    final graphic = top.copyWith(
      pattern: GarmentPattern.graphic,
      secondaryColor: 0xffff8000,
    );
    expect(
      evaluate(rule, upper: graphic).reason,
      'Una sola prenda protagonista, el resto la acompaña',
    );
    expect(
      evaluate(
        rule,
        upper: graphic,
        lower: bottom.copyWith(pattern: GarmentPattern.print),
      ).score,
      0.25,
    );
    expect(
      evaluate(
        rule,
        upper: graphic,
        footwear: shoes.copyWith(colorFamily: ColorFamily.accent),
      ).score,
      0.1,
    );
    expect(
      evaluate(
        rule,
        upper: graphic.copyWith(pattern: GarmentPattern.solid),
      ).score,
      1,
    );
  });

  test('volume rewards contrasting fits and handles missing fits', () {
    const rule = VolumeRule();
    final loose = top.copyWith(fit: Fit.loose);
    expect(evaluate(rule, upper: loose).score, 0.7);
    expect(evaluate(rule, upper: loose).reason, isNull);
    expect(
      evaluate(
        rule,
        upper: loose,
        lower: bottom.copyWith(fit: Fit.loose),
      ).score,
      0.3,
    );
    expect(
      evaluate(
        rule,
        upper: loose,
        lower: bottom.copyWith(fit: Fit.regular),
      ).reason,
      isNotNull,
    );
    expect(
      evaluate(
        rule,
        upper: loose,
        lower: bottom.copyWith(fit: Fit.slim),
      ).score,
      1,
    );
  });

  test('rotation averages all garments and measures calendar days', () {
    const rule = RotationRule();
    const scores = {0: 0.0, 1: 0.3, 2: 0.3, 3: 0.7, 6: 0.7, 7: 1.0};
    for (final entry in scores.entries) {
      final worn = fixture.now.subtract(Duration(days: entry.key));
      final result = evaluate(
        rule,
        upper: top.copyWith(lastWornAt: worn),
        lower: bottom.copyWith(lastWornAt: worn),
        footwear: shoes.copyWith(lastWornAt: worn),
      );
      expect(result.score, closeTo(entry.value, 0.00001));
      expect(result.reason, entry.key == 7 ? isNotNull : isNull);
    }
    expect(evaluate(rule).score, 1);
    expect(
      evaluate(
        rule,
        outerwear: fixture.layer.copyWith(lastWornAt: fixture.now),
      ).score,
      0.75,
    );
    expect(
      evaluate(
        rule,
        upper: top.copyWith(
          lastWornAt: fixture.now.subtract(const Duration(minutes: 1)),
        ),
      ).score,
      closeTo(2.3 / 3, 0.00001),
    );
  });
}
