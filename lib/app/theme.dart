import 'package:material_ui/material_ui.dart';

ThemeData outfitTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF425B57),
      brightness: brightness,
    ),
  );
}
