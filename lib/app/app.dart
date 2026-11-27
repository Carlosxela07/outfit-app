import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'router.dart';
import 'theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Outfit',
      routerConfig: _router,
      theme: outfitTheme(Brightness.light),
      darkTheme: outfitTheme(Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }
}
