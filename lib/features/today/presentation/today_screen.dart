import 'package:material_ui/material_ui.dart';

import '../../../core/placeholder_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Hoy',
      description: 'Aquí verás sugerencias de conjuntos para hoy.',
    );
  }
}
