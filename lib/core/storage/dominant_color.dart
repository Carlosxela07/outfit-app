import 'dart:typed_data';

import 'package:image/image.dart' as image;

const defaultGarmentColor = 0xff808080;

int dominantColor(Uint8List bytes) {
  final decoded = image.decodeImage(bytes);
  if (decoded == null) return defaultGarmentColor;

  return _legacyColor(_downsample(decoded));
}

int _legacyColor(image.Image sample) {
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

image.Image _downsample(image.Image decoded) =>
    decoded.width <= 64 && decoded.height <= 64
    ? decoded
    : image.copyResize(
        decoded,
        width: decoded.width >= decoded.height ? 64 : null,
        height: decoded.height > decoded.width ? 64 : null,
        interpolation: image.Interpolation.average,
      );

class DetectedColors {
  const DetectedColors(this.primary, [this.secondary]);

  final int primary;
  final int? secondary;
}

DetectedColors detectColors(Uint8List bytes) {
  final decoded = image.decodeImage(bytes);
  if (decoded == null) return const DetectedColors(defaultGarmentColor);
  final sample = _downsample(decoded);
  final buckets = <int, _ColorBucket>{};
  final edgeWidth = (sample.width * 0.12).ceil();
  final edgeHeight = (sample.height * 0.12).ceil();
  var edgeCount = 0;
  for (final pixel in sample) {
    if (pixel.aNormalized < 0.5) continue;
    final r = (pixel.rNormalized * 255).round();
    final g = (pixel.gNormalized * 255).round();
    final b = (pixel.bNormalized * 255).round();
    final key = (r >> 4) << 8 | (g >> 4) << 4 | (b >> 4);
    final bucket = buckets.putIfAbsent(key, _ColorBucket.new);
    final dx = ((2 * pixel.x + 1) / sample.width - 1).abs();
    final dy = ((2 * pixel.y + 1) / sample.height - 1).abs();
    bucket.count++;
    bucket.red += r;
    bucket.green += g;
    bucket.blue += b;
    bucket.weight += 1 - 0.4 * (dx + dy);
    if (pixel.x < edgeWidth ||
        pixel.x >= sample.width - edgeWidth ||
        pixel.y < edgeHeight ||
        pixel.y >= sample.height - edgeHeight) {
      bucket.edgeCount++;
      edgeCount++;
    }
  }

  final background = buckets.values
      .where((bucket) => bucket.edgeCount >= edgeCount * 0.15)
      .map((bucket) => bucket.color)
      .toList();
  // A radius of 32 RGB units includes nearby shades in adjacent buckets.
  final foreground = buckets.values.where((bucket) {
    return !background.any(
      (color) => _distanceSquared(color, bucket.color) <= 32 * 32,
    );
  }).toList();
  final count = foreground.fold(0, (total, bucket) => total + bucket.count);
  if (count < sample.width * sample.height * 0.05) {
    if (buckets.length == 1) {
      return DetectedColors(buckets.values.single.color);
    }
    return DetectedColors(_legacyColor(sample));
  }

  foreground.sort((a, b) => b.weight.compareTo(a.weight));
  final primary = foreground.first;
  for (final candidate in foreground.skip(1)) {
    if (candidate.weight < primary.weight * 0.2) break;
    // A separation of 72 RGB units keeps nearby shades out of the palette.
    if (_distanceSquared(primary.color, candidate.color) >= 72 * 72) {
      return DetectedColors(primary.color, candidate.color);
    }
  }
  return DetectedColors(primary.color);
}

int _distanceSquared(int a, int b) {
  final dr = ((a >> 16) & 255) - ((b >> 16) & 255);
  final dg = ((a >> 8) & 255) - ((b >> 8) & 255);
  final db = (a & 255) - (b & 255);
  return dr * dr + dg * dg + db * db;
}

class _ColorBucket {
  int count = 0;
  int edgeCount = 0;
  int red = 0;
  int green = 0;
  int blue = 0;
  double weight = 0;

  int get color =>
      0xff000000 |
      ((red ~/ count) << 16) |
      ((green ~/ count) << 8) |
      (blue ~/ count);
}
