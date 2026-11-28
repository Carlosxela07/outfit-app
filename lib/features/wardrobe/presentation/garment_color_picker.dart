import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../application/wardrobe_providers.dart';
import 'garment_photo.dart';

class GarmentColorPicker extends StatelessWidget {
  const GarmentColorPicker({
    required this.path,
    required this.enabled,
    required this.onPrimary,
    required this.onSamplingChanged,
    super.key,
  });

  final String path;
  final bool enabled;
  final ValueChanged<int> onPrimary;
  final ValueChanged<bool> onSamplingChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 180,
        child: _SwatchPhoto(
          path: path,
          onSamplingChanged: onSamplingChanged,
          onChanged: enabled
              ? (color) {
                  if (color != null) onPrimary(color);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          color == null
                              ? 'No se pudo tomar el color de ese punto.'
                              : 'Color actualizado',
                        ),
                      ),
                    );
                }
              : null,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'Toca la prenda para ajustar el color',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class SecondaryColorPicker extends StatelessWidget {
  const SecondaryColorPicker({
    required this.path,
    required this.onChanged,
    super.key,
  });

  final String path;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Tomar color secundario de la foto',
    icon: const Icon(Icons.colorize),
    onPressed: onChanged == null
        ? null
        : () => unawaited(
            showDialog<void>(
              context: context,
              builder: (context) =>
                  _SecondaryColorDialog(path: path, onChanged: onChanged!),
            ),
          ),
  );
}

class _SecondaryColorDialog extends StatefulWidget {
  const _SecondaryColorDialog({required this.path, required this.onChanged});

  final String path;
  final ValueChanged<int> onChanged;

  @override
  State<_SecondaryColorDialog> createState() => _SecondaryColorDialogState();
}

class _SecondaryColorDialogState extends State<_SecondaryColorDialog> {
  bool _failed = false;
  bool _sampling = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Toca la foto para elegir el color secundario'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 320,
          height: 180,
          child: _SwatchPhoto(
            path: widget.path,
            onSamplingChanged: (value) => setState(() => _sampling = value),
            onChanged: (color) {
              setState(() => _failed = color == null);
              if (color != null) widget.onChanged(color);
            },
          ),
        ),
        if (_failed) const Text('No se pudo tomar el color de ese punto.'),
      ],
    ),
    actions: [
      TextButton(
        onPressed: _sampling ? null : () => Navigator.pop(context),
        child: const Text('Listo'),
      ),
    ],
  );
}

class _SwatchPhoto extends ConsumerStatefulWidget {
  const _SwatchPhoto({
    required this.path,
    required this.onChanged,
    required this.onSamplingChanged,
  });

  final String path;
  final ValueChanged<int?>? onChanged;
  final ValueChanged<bool> onSamplingChanged;

  @override
  ConsumerState<_SwatchPhoto> createState() => _SwatchPhotoState();
}

class _SwatchPhotoState extends ConsumerState<_SwatchPhoto> {
  (Offset, int)? _swatch;
  int _request = 0;

  Future<void> _sample(Size viewport, Offset position) async {
    final request = ++_request;
    widget.onSamplingChanged(true);
    int? color;
    try {
      color = await ref
          .read(garmentPhotosProvider)
          .sampleColor(widget.path, GarmentPhoto.fit, viewport, position);
    } on Exception {
      // An unreadable photo is reported through the same callback as no sample.
    }
    if (!mounted || request != _request) return;
    widget.onSamplingChanged(false);
    if (widget.onChanged == null) return;
    if (ModalRoute.of(context)?.isCurrent == false) return;
    setState(() => _swatch = color == null ? null : (position, color));
    widget.onChanged?.call(color);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: widget.onChanged == null
          ? null
          : (details) =>
                unawaited(_sample(constraints.biggest, details.localPosition)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GarmentPhoto(widget.path),
          if (_swatch case (final position, final color))
            Positioned(
              left: position.dx - 10,
              top: position.dy - 10,
              child: Container(
                key: const ValueKey('sampled-color'),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(color),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
