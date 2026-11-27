import 'package:material_ui/material_ui.dart';

import '../../../core/placeholder_screen.dart';

class GapsScreen extends StatelessWidget {
  const GapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Qué me falta',
      description: 'Aquí verás qué prendas podrían complementar tu clóset.',
    );
  }
}
