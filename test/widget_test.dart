import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:outfit_app/app/app.dart';
import 'package:outfit_app/features/wardrobe/application/wardrobe_providers.dart';

void main() {
  testWidgets('Starts on Hoy and opens all four tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeItemsProvider(null).overrideWith((ref) => Stream.value([])),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    final navigationBar = find.byType(NavigationBar);
    final appBar = find.byType(AppBar);
    expect(tester.widget<NavigationBar>(navigationBar).selectedIndex, 0);
    expect(
      find.descendant(of: appBar, matching: find.text('Hoy')),
      findsOneWidget,
    );

    for (final label in ['Clóset', 'Qué me falta', 'Ajustes', 'Hoy']) {
      await tester.tap(
        find.descendant(of: navigationBar, matching: find.text(label)),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: appBar, matching: find.text(label)),
        findsOneWidget,
      );
    }
  });
}
