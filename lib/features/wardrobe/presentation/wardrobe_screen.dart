import 'package:material_ui/material_ui.dart';

import '../../../core/placeholder_screen.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Clóset',
      description: 'Aquí podrás ver y organizar tus prendas.',
    );
  }
}
