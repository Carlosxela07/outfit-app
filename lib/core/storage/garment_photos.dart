import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'dominant_color.dart';

class GarmentPhotos {
  const GarmentPhotos();

  Future<DetectedColors> detectPhotoColors(String source) async =>
      compute(detectColors, await File(source).readAsBytes());

  Future<int?> sampleColor(
    String source,
    BoxFit fit,
    Size viewport,
    Offset position,
  ) => compute(_sampleColor, (source, fit, viewport, position));

  Future<String> save(String id, String source) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = await Directory(path.join(documents.path, 'garments'))
        .create(recursive: true);
    final destination = File(path.join(directory.path, '$id.jpg'));
    final jpeg = await compute(_encodePhoto, source);
    try {
      await destination.writeAsBytes(jpeg);
    } catch (_) {
      await delete(destination.path);
      rethrow;
    }
    return destination.path;
  }

  Future<void> delete(String photoPath) async {
    final file = File(photoPath);
    if (await file.exists()) await file.delete();
  }
}

Uint8List _encodePhoto(String source) {
  final bytes = File(source).readAsBytesSync();
  if (image.findDecoderForData(bytes) is image.JpegDecoder) return bytes;

  final decoded = image.decodeImage(bytes);
  if (decoded == null) throw const FormatException('Unsupported photo');
  return image.encodeJpg(decoded, quality: 85);
}

int? _sampleColor((String, BoxFit, Size, Offset) request) {
  final (source, fit, viewport, position) = request;
  final decoded = image.decodeImage(File(source).readAsBytesSync());
  if (decoded == null) return null;
  final photo = image.bakeOrientation(decoded);
  final size = Size(photo.width.toDouble(), photo.height.toDouble());
  final fitted = applyBoxFit(fit, size, viewport);
  final sourceRect = Alignment.center.inscribe(
    fitted.source,
    Offset.zero & size,
  );
  final destination = Alignment.center.inscribe(
    fitted.destination,
    Offset.zero & viewport,
  );
  if (!destination.contains(position)) return null;
  final x =
      (sourceRect.left +
              (position.dx - destination.left) *
                  sourceRect.width /
                  destination.width)
          .floor();
  final y =
      (sourceRect.top +
              (position.dy - destination.top) *
                  sourceRect.height /
                  destination.height)
          .floor();
  var count = 0;
  var red = 0.0;
  var green = 0.0;
  var blue = 0.0;
  for (
    var row = (y - 4).clamp(0, photo.height - 1);
    row <= (y + 4).clamp(0, photo.height - 1);
    row++
  ) {
    for (
      var column = (x - 4).clamp(0, photo.width - 1);
      column <= (x + 4).clamp(0, photo.width - 1);
      column++
    ) {
      final pixel = photo.getPixel(column, row);
      if (pixel.aNormalized < 0.5) continue;
      count++;
      red += pixel.rNormalized;
      green += pixel.gNormalized;
      blue += pixel.bNormalized;
    }
  }
  if (count == 0) return null;
  return 0xff000000 |
      ((red * 255 / count).round() << 16) |
      ((green * 255 / count).round() << 8) |
      (blue * 255 / count).round();
}
