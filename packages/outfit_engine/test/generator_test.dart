import 'package:outfit_engine/outfit_engine.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  const engine = OutfitEngine();
  final minimum = [top, bottom, shoes];
  List<OutfitSuggestion> suggest(
    List<Garment> closet, {
    int seed = 0,
    StyleProfile? style,
  }) => engine.suggest(closet, style: style ?? casual, now: now, seed: seed);

  test('requires a real top, bottom and shoes', () {
    expect(suggest([]), isEmpty);
    expect(missingFor([]), {
      GarmentCategory.top,
      GarmentCategory.bottom,
      GarmentCategory.shoes,
    });
    final incomplete = [bottom, shoes, top.copyWith(isVirtual: true)];
    expect(missingFor(incomplete), {GarmentCategory.top});
    expect(suggest(incomplete), isEmpty);
    expect(missingFor(minimum), isEmpty);
    expect(suggest(minimum), hasLength(1));
    expect(
      suggest([...minimum, layer.copyWith(isVirtual: true)]),
      suggest(minimum),
    );
  });

  test('suggestions never repeat a top and bottom pair', () {
    final suggestions = suggest([
      ...minimum,
      top.copyWith(id: 'other top'),
      shoes.copyWith(id: 'other shoes'),
    ]);
    expect(suggestions, hasLength(2));
    expect(
      suggestions.map((outfit) => (outfit.top.id, outfit.bottom.id)).toSet(),
      hasLength(2),
    );
  });

  test('rotation ranks a fresh top ahead of the one worn yesterday', () {
    final worn = top.copyWith(
      id: 'worn',
      lastWornAt: now.subtract(const Duration(days: 1)),
    );
    expect(suggest([worn, ...minimum]).first.top, top);
  });

  test('one accent outranks two accents', () {
    final accentTop = top.copyWith(
      id: 'accent top',
      colorFamily: ColorFamily.accent,
    );
    final accentBottom = bottom.copyWith(colorFamily: ColorFamily.accent);
    final suggestions = suggest([accentTop, top, accentBottom, shoes]);
    expect(suggestions.first.top, top);
    expect(suggestions.first.score, greaterThan(suggestions.last.score));
  });

  test('one protagonist outranks a second patterned garment', () {
    final graphic = top.copyWith(pattern: GarmentPattern.graphic);
    final plaid = bottom.copyWith(id: 'plaid', pattern: GarmentPattern.print);
    final suggestions = suggest([graphic, bottom, plaid, shoes]);
    expect(suggestions.first.bottom, bottom);
    expect(
      suggestions.first.reasons,
      contains('Una sola prenda protagonista, el resto la acompaña'),
    );
    expect(suggestions.first.score, greaterThan(suggestions.last.score));
  });

  test('changing style changes the ranking', () {
    final closet = [
      top.copyWith(formality: 1),
      bottom.copyWith(formality: 1),
      shoes.copyWith(formality: 1),
      top.copyWith(id: 'formal top', formality: 4),
      bottom.copyWith(id: 'formal bottom', formality: 4),
      shoes.copyWith(id: 'formal shoes', formality: 4),
    ];
    expect(suggest(closet).first.top.id, top.id);
    expect(
      suggest(closet, style: predefinedStyles[1]).first.top.id,
      'formal top',
    );
  });

  test('layers must strictly improve the score', () {
    final accentLayer = layer.copyWith(colorFamily: ColorFamily.accent);
    final improved = suggest([...minimum, accentLayer]).single;
    expect(improved.outerwear, accentLayer);
    expect(improved.score, greaterThan(suggest(minimum).single.score));
    expect(suggest([...minimum, layer]).single.outerwear, isNull);
    expect(
      suggest([...minimum, accentLayer.copyWith(formality: 5)])
          .single
          .outerwear,
      isNull,
    );
  });

  test('seeds reproduce results and can break ties in a new order', () {
    final closet = [
      ...minimum,
      for (var i = 0; i < 8; i++) top.copyWith(id: 'top $i'),
    ];
    final original = suggest(closet);
    expect(suggest(closet), original);
    expect([
      for (var seed = 1; seed <= 5; seed++)
        suggest(closet, seed: seed).first.top,
    ], contains(isNot(original.first.top)));
  });

  test('reasons are capped and have a fallback', () {
    final dated = minimum
        .map((garment) => garment.copyWith(lastWornAt: DateTime.utc(2025)))
        .toList();
    expect(suggest(dated).single.reasons, [
      'Todo está en el mismo nivel de formalidad',
      'Encaja con el estilo Casual',
      'Rescata prendas que no usas hace tiempo',
    ]);
    const noRules = OutfitEngine(rules: []);
    expect(noRules.suggest(minimum, style: casual, now: now).single.reasons, [
      'Combinación equilibrada',
    ]);
  });

  test('samples a large product within the runtime budget', () {
    final closet = [
      for (var i = 0; i < 40; i++) top.copyWith(id: 'top $i'),
      for (var i = 0; i < 30; i++) bottom.copyWith(id: 'bottom $i'),
      for (var i = 0; i < 10; i++) shoes.copyWith(id: 'shoes $i'),
      for (var i = 0; i < 5; i++) layer.copyWith(id: 'layer $i'),
    ];
    final stopwatch = Stopwatch()..start();
    final suggestions = suggest(closet, seed: 5);
    stopwatch.stop();
    expect(suggestions, hasLength(3));
    expect(stopwatch.elapsedMilliseconds, lessThan(500));
    expect(suggest(closet, seed: 5), suggestions);
  });
}
