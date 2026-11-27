import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:outfit_engine/outfit_engine.dart';

import '../application/wardrobe_providers.dart';
import 'garment_editor.dart';
import 'garment_options.dart';
import 'garment_photo.dart';

class WardrobeScreen extends ConsumerStatefulWidget {
  const WardrobeScreen({super.key});

  @override
  ConsumerState<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends ConsumerState<WardrobeScreen> {
  GarmentCategory? _category;
  bool _adding = false;

  Future<void> _add() async {
    if (_adding) return;
    setState(() => _adding = true);
    try {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Cámara'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Galería'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );
      if (!mounted || source == null) return;
      final photo = await ref.read(garmentPhotoPickerProvider)(source);
      if (!mounted || photo == null) return;
      final saved = await Navigator.of(context, rootNavigator: true).push<bool>(
        MaterialPageRoute(builder: (context) => GarmentEditor.add(photo)),
      );
      if (mounted && saved == true) setState(() => _category = null);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir la foto. Intenta de nuevo.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(wardrobeItemsProvider(_category));
    return Scaffold(
      appBar: AppBar(title: const Text('Clóset')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar prenda',
        onPressed: _adding ? null : () => unawaited(_add()),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final entry in {null: 'Todo', ...categoryLabels}.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.value),
                      selected: entry.key == _category,
                      onSelected: (_) => setState(() => _category = entry.key),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.invalidate(wardrobeItemsProvider(_category)),
                  child: const Text('No se pudo cargar el clóset. Reintentar'),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  final all = _category == null;
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          all
                              ? 'Tu clóset está listo para tu primera prenda.'
                              : 'Todavía no hay prendas en esta categoría.',
                        ),
                        if (all)
                          FilledButton(
                            onPressed: _adding ? null : () => unawaited(_add()),
                            child: const Text('Agregar primera prenda'),
                          ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final category = item.garment.category;
                    final label =
                        subtypeLabels[category]?[item.garment.subtype] ??
                        categoryLabels[category]!;
                    return Semantics(
                      label: label,
                      child: InkWell(
                        key: ValueKey(item.garment.id),
                        onTap: () => unawaited(
                          Navigator.of(context, rootNavigator: true).push<bool>(
                            MaterialPageRoute(
                              builder: (context) => GarmentEditor.edit(item),
                            ),
                          ),
                        ),
                        child: GarmentPhoto(item.photoPath, cacheWidth: 360),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
