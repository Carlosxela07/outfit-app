import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:outfit_app/core/storage/garment_photos.dart';

void main() {
  test(
    'samples a 9 by 9 area in the cropped source of a cover photo',
    () async {
      final directory = await Directory.systemTemp.createTemp('eyedropper');
      addTearDown(() => directory.delete(recursive: true));
      final photo = image.Image(width: 200, height: 100)
        ..clear(image.ColorRgb8(0, 0, 255));
      image.fillRect(
        photo,
        x1: 66,
        x2: 74,
        y1: 46,
        y2: 54,
        color: image.ColorRgb8(255, 0, 0),
      );
      photo.setPixelRgb(70, 50, 0, 0, 255);
      final file = File('${directory.path}/photo.png');
      await file.writeAsBytes(image.encodePng(photo));

      final color = await const GarmentPhotos().sampleColor(
        file.path,
        BoxFit.cover,
        const Size(100, 100),
        const Offset(20, 50),
      );

      expect(color, 0xfffc0003);
    },
  );
}
