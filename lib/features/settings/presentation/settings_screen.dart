import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../wardrobe/data/capture_settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remember = ref.watch(rememberGarmentValuesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: SwitchListTile(
        title: const Text('Recordar últimos valores'),
        value: remember.value ?? true,
        onChanged: remember.hasValue
            ? (value) async {
                try {
                  await ref
                      .read(captureSettingsRepositoryProvider)
                      .setRemember(value);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo guardar el ajuste.'),
                    ),
                  );
                }
              }
            : null,
      ),
    );
  }
}
