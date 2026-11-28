import 'copy_with.dart';
import 'garment_enums.dart';

final class Garment {
  const Garment({
    required this.id,
    required this.category,
    required this.subtype,
    required this.formality,
    required this.primaryColor,
    required this.colorFamily,
    this.secondaryColor,
    this.secondaryColorFamily,
    this.pattern = GarmentPattern.solid,
    this.fit,
    this.warmth,
    this.lastWornAt,
    this.timesWorn = 0,
    this.isVirtual = false,
  }) : assert(formality >= 1 && formality <= 5);

  final String id;
  final GarmentCategory category;
  final String subtype;
  final int formality;
  final int primaryColor;
  final ColorFamily colorFamily;
  final int? secondaryColor;
  final ColorFamily? secondaryColorFamily;
  final GarmentPattern pattern;
  final Fit? fit;
  final Warmth? warmth;
  final DateTime? lastWornAt;
  final int timesWorn;
  final bool isVirtual;

  Garment copyWith({
    String? id,
    GarmentCategory? category,
    String? subtype,
    int? formality,
    int? primaryColor,
    ColorFamily? colorFamily,
    Object? secondaryColor = CopyWithValue.unchanged,
    Object? secondaryColorFamily = CopyWithValue.unchanged,
    GarmentPattern? pattern,
    Object? fit = CopyWithValue.unchanged,
    Object? warmth = CopyWithValue.unchanged,
    Object? lastWornAt = CopyWithValue.unchanged,
    int? timesWorn,
    bool? isVirtual,
  }) {
    return Garment(
      id: id ?? this.id,
      category: category ?? this.category,
      subtype: subtype ?? this.subtype,
      formality: formality ?? this.formality,
      primaryColor: primaryColor ?? this.primaryColor,
      colorFamily: colorFamily ?? this.colorFamily,
      secondaryColor: secondaryColor == CopyWithValue.unchanged
          ? this.secondaryColor
          : secondaryColor as int?,
      secondaryColorFamily: secondaryColorFamily == CopyWithValue.unchanged
          ? this.secondaryColorFamily
          : secondaryColorFamily as ColorFamily?,
      pattern: pattern ?? this.pattern,
      fit: fit == CopyWithValue.unchanged ? this.fit : fit as Fit?,
      warmth: warmth == CopyWithValue.unchanged
          ? this.warmth
          : warmth as Warmth?,
      lastWornAt: lastWornAt == CopyWithValue.unchanged
          ? this.lastWornAt
          : lastWornAt as DateTime?,
      timesWorn: timesWorn ?? this.timesWorn,
      isVirtual: isVirtual ?? this.isVirtual,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Garment &&
          id == other.id &&
          category == other.category &&
          subtype == other.subtype &&
          formality == other.formality &&
          primaryColor == other.primaryColor &&
          colorFamily == other.colorFamily &&
          secondaryColor == other.secondaryColor &&
          secondaryColorFamily == other.secondaryColorFamily &&
          pattern == other.pattern &&
          fit == other.fit &&
          warmth == other.warmth &&
          lastWornAt == other.lastWornAt &&
          timesWorn == other.timesWorn &&
          isVirtual == other.isVirtual;

  @override
  int get hashCode => Object.hash(
    id,
    category,
    subtype,
    formality,
    primaryColor,
    colorFamily,
    secondaryColor,
    secondaryColorFamily,
    pattern,
    fit,
    warmth,
    lastWornAt,
    timesWorn,
    isVirtual,
  );
}
