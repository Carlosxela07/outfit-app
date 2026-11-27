import 'package:outfit_engine/outfit_engine.dart';
import 'package:test/test.dart';

const shirt = Garment(
  id: 'shirt',
  category: GarmentCategory.top,
  subtype: 'tshirt',
  formality: 2,
  primaryColor: 0xffeeeeee,
  colorFamily: ColorFamily.neutral,
  fit: Fit.regular,
  warmth: Warmth.light,
);

void main() {
  group('Garment', () {
    test('compares by value and copies changed fields', () {
      final date = DateTime.utc(2026, 1, 2);
      final copy = shirt.copyWith();
      expect(copy, shirt);
      expect(copy.hashCode, shirt.hashCode);

      final worn = shirt.copyWith(lastWornAt: date, timesWorn: 1);
      expect(worn, isNot(shirt));
      expect(worn.lastWornAt, date);
      expect(worn.timesWorn, 1);
      expect(worn.copyWith(), worn);
      expect(worn.copyWith(lastWornAt: null, timesWorn: 0), shirt);
      expect(shirt.copyWith(fit: null, warmth: null).fit, isNull);
      expect(shirt.copyWith(fit: null, warmth: null).warmth, isNull);
    });

    test('asserts formality is in range', () {
      expect(
        () => shirt.copyWith(formality: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => shirt.copyWith(formality: 6),
        throwsA(isA<AssertionError>()),
      );
      expect(shirt.copyWith(formality: 1).formality, 1);
      expect(shirt.copyWith(formality: 5).formality, 5);
    });
  });

  group('classifyColor', () {
    const colors = {
      'black': (0xff000000, ColorFamily.neutral),
      'white': (0xffffffff, ColorFamily.neutral),
      'gray': (0xff808080, ColorFamily.neutral),
      'beige': (0xffe2c9a7, ColorFamily.neutral),
      'red': (0xffb52e32, ColorFamily.warm),
      'orange': (0xffff8000, ColorFamily.accent),
      'navy': (0xff000080, ColorFamily.cool),
      'neon green': (0xff39ff14, ColorFamily.accent),
      'blue with transparent alpha': (0x00000080, ColorFamily.cool),
    };

    for (final entry in colors.entries) {
      test(entry.key, () {
        final (argb, expected) = entry.value;
        expect(classifyColor(argb), expected);
      });
    }
  });

  group('StyleProfile', () {
    test('defines the four expected ranges', () {
      expect(predefinedStyles, hasLength(4));
      expect(
        {for (final style in predefinedStyles) style.id: style.formalityRange},
        {
          'casual': (1, 2),
          'smart_casual': (2, 4),
          'streetwear': (1, 3),
          'minimal': (2, 4),
        },
      );
    });

    test('copies weights and compares them independently of key order', () {
      final original = predefinedStyles.first;
      final weights = {'color': 1.0, 'formality': 1.0};
      final copy = original.copyWith(ruleWeights: weights);
      weights['color'] = 2.0;
      expect(copy, original);
      expect(copy.hashCode, original.hashCode);
      expect(() => copy.ruleWeights.clear(), throwsUnsupportedError);
    });
  });

  test('OutfitSuggestion copies its reasons and omits absent garments', () {
    final jeans = shirt.copyWith(id: 'jeans', category: GarmentCategory.bottom);
    final shoes = shirt.copyWith(id: 'shoes', category: GarmentCategory.shoes);
    final jacket = shirt.copyWith(
      id: 'jacket',
      category: GarmentCategory.outerwear,
    );
    final reasons = ['Los colores combinan.'];
    final suggestion = OutfitSuggestion(
      top: shirt,
      bottom: jeans,
      shoes: shoes,
      outerwear: jacket,
      score: 1,
      reasons: reasons,
    );

    reasons.clear();
    expect(suggestion.reasons, ['Los colores combinan.']);
    expect(() => suggestion.reasons.clear(), throwsUnsupportedError);
    expect(suggestion.garments, [shirt, jeans, shoes, jacket]);
    expect(suggestion.copyWith(outerwear: null).garments, [
      shirt,
      jeans,
      shoes,
    ]);
    final copy = suggestion.copyWith();
    expect(copy, suggestion);
    expect(copy.hashCode, suggestion.hashCode);
  });
}
