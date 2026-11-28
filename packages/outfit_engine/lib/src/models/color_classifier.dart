import 'dart:math' as math;

import 'garment_enums.dart';

/// Classifies the RGB channels of an ARGB color in HSV space, ignoring alpha.
ColorFamily classifyColor(int argb) {
  final red = ((argb >> 16) & 0xff) / 255;
  final green = ((argb >> 8) & 0xff) / 255;
  final blue = (argb & 0xff) / 255;
  final value = math.max(red, math.max(green, blue));
  final chroma = value - math.min(red, math.min(green, blue));
  final saturation = value == 0 ? 0.0 : chroma / value;

  // Near-black, muted, or very light low-chroma tones (including beige).
  if (value <= 0.12 ||
      saturation <= 0.16 ||
      (value >= 0.85 && saturation <= 0.32)) {
    return ColorFamily.neutral;
  }

  // Bright, highly saturated colors take precedence over hue.
  if (value >= 0.85 && saturation >= 0.80) {
    return ColorFamily.accent;
  }

  final double hueSector;
  if (value == red) {
    hueSector = (green - blue) / chroma;
  } else if (value == green) {
    hueSector = (blue - red) / chroma + 2;
  } else {
    hueSector = (red - green) / chroma + 4;
  }

  final hue = (hueSector * 60) % 360;
  // Muted blues (200–235°) include navy and denim below 60% value.
  final mutedBlue =
      hue >= 200 && hue <= 235 && value <= 0.60 && saturation <= 0.65;
  // Browns are dark oranges; khaki is a less saturated orange or yellow.
  final brown = hue >= 10 && hue <= 50 && value <= 0.45 && saturation <= 0.65;
  final khaki = hue >= 25 && hue <= 55 && saturation <= 0.32;
  // Olive is a dark yellow-green (55–100°).
  final olive = hue >= 55 && hue <= 100 && value <= 0.50 && saturation <= 0.70;
  if (mutedBlue || brown || khaki || olive) return ColorFamily.neutral;

  // Red through yellow is warm ([330, 360) or [0, 70) degrees).
  return hue >= 330 || hue < 70 ? ColorFamily.warm : ColorFamily.cool;
}
