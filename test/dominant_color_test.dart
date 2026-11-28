import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:outfit_app/core/storage/dominant_color.dart';

void main() {
  test('returns exact red for a solid red photo', () {
    final photo = image.Image(width: 128, height: 128)
      ..clear(image.ColorRgb8(255, 0, 0));
    expect(dominantColor(image.encodePng(photo)), 0xffff0000);
  });

  test('ignores a nearly white background but accepts an all-white photo', () {
    final photo = image.Image(width: 32, height: 32)
      ..clear(image.ColorRgb8(250, 250, 250));
    expect(dominantColor(image.encodePng(photo)), 0xffffffff);
    image.fillRect(
      photo,
      x1: 8,
      y1: 8,
      x2: 16,
      y2: 16,
      color: image.ColorRgb8(0, 0, 255),
    );
    expect(dominantColor(image.encodePng(photo)), 0xff0000ff);
  });

  test('finds a beige garment against patterned navy bedding', () {
    final photo = image.Image(width: 64, height: 64)
      ..clear(image.ColorRgb8(14, 24, 72));
    for (var y = 0; y < 64; y++) {
      if (y % 8 < 2) {
        fill(photo, 0, y, 63, y, 0x9edcff);
      }
    }
    fill(photo, 9, 9, 54, 54, 0xd3b38b);
    expect(detectColors(image.encodePng(photo)).primary, 0xffd3b38b);
  });

  test('finds a large yellow garment on blue', () {
    final photo = image.Image(width: 64, height: 64)
      ..clear(image.ColorRgb8(0, 0, 180));
    fill(photo, 8, 8, 55, 55, 0xeed322);
    expect(detectColors(image.encodePng(photo)).primary, 0xffeed322);
  });

  test('finds both colors of a black garment with a white stripe', () {
    final photo = image.Image(width: 64, height: 64)
      ..clear(image.ColorRgb8(0, 0, 180));
    fill(photo, 10, 10, 53, 53, 0x000000);
    fill(photo, 10, 24, 53, 39, 0xffffff);
    final colors = detectColors(image.encodePng(photo));
    expect([
      colors.primary,
      colors.secondary,
    ], unorderedEquals([0xff000000, 0xffffffff]));
  });

  test('returns the exact color and no secondary for a uniform photo', () {
    final photo = image.Image(width: 128, height: 128)
      ..clear(image.ColorRgb8(250, 250, 250));
    final colors = detectColors(image.encodePng(photo));
    expect(colors.primary, 0xfffafafa);
    expect(colors.secondary, isNull);
  });

  test('returns an opaque primary color for a noisy photo', () {
    final random = Random(6);
    final photo = image.Image(width: 64, height: 64);
    for (final pixel in photo) {
      pixel.setRgb(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }
    expect(detectColors(image.encodePng(photo)).primary >> 24, 255);
  });
}

void fill(image.Image photo, int x1, int y1, int x2, int y2, int rgb) {
  image.fillRect(
    photo,
    x1: x1,
    y1: y1,
    x2: x2,
    y2: y2,
    color: image.ColorRgb8((rgb >> 16) & 255, (rgb >> 8) & 255, rgb & 255),
  );
}
