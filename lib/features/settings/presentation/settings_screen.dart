import 'package:material_ui/material_ui.dart';

import '../../../core/placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Ajustes',
      description: 'Aquí podrás configurar tu perfil y tus preferencias.',
    );
  }
}
