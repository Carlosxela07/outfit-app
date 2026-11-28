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
    required this.onSecondary,
    super.key,
  });

  final String path;
  final bool enabled;
  final ValueChanged<int> onPrimary;
  final ValueChanged<int> onSecondary;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: !enabled
        ? null
        : () => unawaited(
            showDialog<void>(
              context: context,
              builder: (context) => _Eyedropper(
                path: path,
                onPrimary: onPrimary,
                onSecondary: onSecondary,
              ),
            ),
          ),
    child: SizedBox(
      height: 180,
      child: Semantics(
        button: enabled,
        label: 'Elegir color de la foto',
        child: GarmentPhoto(path),
      ),
    ),
  );
}

enum _ColorTarget { primary, secondary }

class _Eyedropper extends ConsumerStatefulWidget {
  const _Eyedropper({
    required this.path,
    required this.onPrimary,
    required this.onSecondary,
  });

  final String path;
  final ValueChanged<int> onPrimary;
  final ValueChanged<int> onSecondary;

  @override
  ConsumerState<_Eyedropper> createState() => _EyedropperState();
}

class _EyedropperState extends ConsumerState<_Eyedropper> {
  _ColorTarget _target = _ColorTarget.primary;
  Offset? _position;
  int? _color;
  int _request = 0;
  bool _failed = false;

  Future<void> _sample(Size viewport, Offset position) async {
    final target = _target;
    final request = ++_request;
    int? color;
    try {
      color = await ref
          .read(garmentPhotosProvider)
          .sampleColor(widget.path, GarmentPhoto.fit, viewport, position);
    } on Exception {
      // Report an unreadable photo in the dialog.
    }
    if (!mounted || request != _request) return;
    setState(() {
      _failed = color == null;
      _position = color == null ? null : position;
      _color = color;
    });
    if (color == null) return;
    final assign = target == _ColorTarget.primary
        ? widget.onPrimary
        : widget.onSecondary;
    assign(color);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Toca la foto para elegir un color'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SegmentedButton<_ColorTarget>(
          segments: const [
            ButtonSegment(
              value: _ColorTarget.primary,
              label: Text('Principal'),
            ),
            ButtonSegment(
              value: _ColorTarget.secondary,
              label: Text('Secundario'),
            ),
          ],
          selected: {_target},
          onSelectionChanged: (selection) => setState(() {
            _target = selection.single;
            _request++;
            _position = null;
            _failed = false;
          }),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 320,
          height: 180,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              onTapUp: (details) => unawaited(
                _sample(constraints.biggest, details.localPosition),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GarmentPhoto(widget.path),
                  if (_position case final position?)
                    Positioned(
                      left: position.dx - 10,
                      top: position.dy - 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(_color!),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_failed) const Text('No se pudo tomar el color de ese punto.'),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Listo'),
      ),
    ],
  );
}
