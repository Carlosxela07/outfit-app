import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'dominant_color.dart';

class GarmentPhotos {
  const GarmentPhotos();

  Future<int> detectColor(String source) async =>
      compute(dominantColor, await File(source).readAsBytes());

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
