import 'copy_with.dart';
import 'garment.dart';

final class OutfitSuggestion {
  OutfitSuggestion({
    required this.top,
    required this.bottom,
    required this.shoes,
    this.outerwear,
    this.accessory,
    required this.score,
    required List<String> reasons,
  }) : reasons = List.unmodifiable(reasons);

  final Garment top;
  final Garment bottom;
  final Garment shoes;
  final Garment? outerwear;
  final Garment? accessory;
  final double score;
  final List<String> reasons;

  List<Garment> get garments =>
      List.unmodifiable([top, bottom, shoes, ?outerwear, ?accessory]);

  OutfitSuggestion copyWith({
    Garment? top,
    Garment? bottom,
    Garment? shoes,
    Object? outerwear = CopyWithValue.unchanged,
    Object? accessory = CopyWithValue.unchanged,
    double? score,
    List<String>? reasons,
  }) {
    return OutfitSuggestion(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      shoes: shoes ?? this.shoes,
      outerwear: outerwear == CopyWithValue.unchanged
          ? this.outerwear
          : outerwear as Garment?,
      accessory: accessory == CopyWithValue.unchanged
          ? this.accessory
          : accessory as Garment?,
      score: score ?? this.score,
      reasons: reasons ?? this.reasons,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutfitSuggestion &&
          top == other.top &&
          bottom == other.bottom &&
          shoes == other.shoes &&
          outerwear == other.outerwear &&
          accessory == other.accessory &&
          score == other.score &&
          _sameReasons(other.reasons);

  @override
  int get hashCode => Object.hash(
    top,
    bottom,
    shoes,
    outerwear,
    accessory,
    score,
    Object.hashAll(reasons),
  );

  bool _sameReasons(List<String> other) {
    if (reasons.length != other.length) return false;
    for (var index = 0; index < reasons.length; index++) {
      if (reasons[index] != other[index]) return false;
    }
    return true;
  }
}
