import 'dart:io';

import 'package:material_ui/material_ui.dart';

class GarmentPhoto extends StatelessWidget {
  const GarmentPhoto(this.path, {super.key, this.cacheWidth});

  final String path;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) => Image.file(
    File(path),
    width: double.infinity,
    height: double.infinity,
    cacheWidth: cacheWidth,
    fit: BoxFit.cover,
    excludeFromSemantics: true,
    errorBuilder: (context, error, stackTrace) => const Center(
      child: Icon(
        Icons.broken_image_outlined,
        semanticLabel: 'Foto no disponible',
      ),
    ),
  );
}
