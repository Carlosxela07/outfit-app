import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/storage/dominant_color.dart';
import '../application/wardrobe_providers.dart';
import '../data/capture_settings_repository.dart';
import 'garment_editor.dart';

class GarmentBatchEditor extends ConsumerStatefulWidget {
  const GarmentBatchEditor({
    required this.photos,
    required this.remember,
    required this.defaults,
    super.key,
  });

  final List<XFile> photos;
  final bool remember;
  final GarmentDefaults? defaults;

  @override
  ConsumerState<GarmentBatchEditor> createState() => _GarmentBatchEditorState();
}

class _GarmentBatchEditorState extends ConsumerState<GarmentBatchEditor> {
  var _index = 0;
  var _saved = 0;
  var _confirmingExit = false;
  late GarmentDefaults? _defaults;
  late Future<DetectedColors?> _currentColors;
  Future<DetectedColors?>? _nextColors;

  @override
  void initState() {
    super.initState();
    _defaults = widget.defaults;
    _currentColors = _detect(0);
    _prefetchNext();
  }

  Future<DetectedColors?> _detect(int index) async {
    try {
      return await ref
          .read(garmentPhotosProvider)
          .detectPhotoColors(widget.photos[index].path);
    } on Exception {
      return null;
    }
  }

  void _prefetchNext() {
    final next = _index + 1;
    _nextColors = next < widget.photos.length ? _detect(next) : null;
  }

  void _advance(GarmentDefaults? saved) {
    if (saved != null) {
      _saved++;
      if (widget.remember) _defaults = saved;
    }
    if (_index + 1 == widget.photos.length) {
      Navigator.pop(context, _saved);
      return;
    }
    setState(() {
      _index++;
      _currentColors = _nextColors!;
      _prefetchNext();
    });
  }

  Future<void> _exit() async {
    if (_confirmingExit) return;
    _confirmingExit = true;
    final remaining = widget.photos.length - _index;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          remaining == 1
              ? '¿Descartar la foto restante?'
              : '¿Descartar las $remaining fotos restantes?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
    _confirmingExit = false;
    if (mounted && confirmed == true) Navigator.pop(context, _saved);
  }

  @override
  Widget build(BuildContext context) => GarmentEditor.add(
    widget.photos[_index],
    key: ValueKey(_index),
    defaults: _defaults,
    batch: (
      position: _index + 1,
      total: widget.photos.length,
      colors: _currentColors,
      advance: _advance,
      exit: () => unawaited(_exit()),
    ),
  );
}
