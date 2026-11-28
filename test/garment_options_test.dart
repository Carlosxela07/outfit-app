import 'package:flutter_test/flutter_test.dart';
import 'package:outfit_app/features/wardrobe/presentation/garment_options.dart';

void main() {
  test('defines the requested typical formality for every subtype', () {
    const expectedSubtypesByFormality = {
      1: ['sweatshirt', 'shorts', 'joggers', 'sandals'],
      2: [
        'tshirt',
        'jeans',
        'overshirt',
        'casual_jacket',
        'sneakers',
        'belt',
        'cap',
        'scarf',
        'watch',
        'bag',
      ],
      3: [
        'shirt',
        'polo',
        'blouse',
        'pants',
        'skirt',
        'jacket',
        'sweater',
        'vest',
        'cardigan',
        'boots',
      ],
      4: ['coat', 'blazer', 'loafers'],
    };
    expect(typicalFormalityBySubtype, {
      for (final entry in expectedSubtypesByFormality.entries)
        for (final subtype in entry.value) subtype: entry.key,
    });
    expect(
      typicalFormalityBySubtype.keys,
      unorderedEquals(subtypeLabels.values.expand((labels) => labels.keys)),
    );
  });
}
