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
}
