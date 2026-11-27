import 'dart:typed_data';

import 'package:image/image.dart' as image;

const defaultGarmentColor = 0xff808080;

int dominantColor(Uint8List bytes) {
  final decoded = image.decodeImage(bytes);
  if (decoded == null) return defaultGarmentColor;

  final sample = decoded.width <= 64 && decoded.height <= 64
      ? decoded
      : image.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? 64 : null,
          height: decoded.height > decoded.width ? 64 : null,
          interpolation: image.Interpolation.average,
        );
  final buckets = <int, (int, int, int, int)>{};
  var hasWhite = false;
  for (final pixel in sample) {
    if (pixel.aNormalized < 0.5) continue;
    final r = (pixel.rNormalized * 255).round();
    final g = (pixel.gNormalized * 255).round();
    final b = (pixel.bNormalized * 255).round();
    if (r >= 240 && g >= 240 && b >= 240) {
      hasWhite = true;
      continue;
    }
    final key = (r >> 4) << 8 | (g >> 4) << 4 | (b >> 4);
    final (count, red, green, blue) = buckets[key] ?? (0, 0, 0, 0);
    buckets[key] = (count + 1, red + r, green + g, blue + b);
  }
  if (buckets.isEmpty) return hasWhite ? 0xffffffff : defaultGarmentColor;

  final (count, r, g, b) = buckets.values.reduce(
    (best, next) => next.$1 > best.$1 ? next : best,
  );
  return 0xff000000 | ((r ~/ count) << 16) | ((g ~/ count) << 8) | (b ~/ count);
}
