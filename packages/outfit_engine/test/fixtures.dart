import 'package:outfit_engine/outfit_engine.dart';

final now = DateTime.utc(2026, 11, 27);
final casual = predefinedStyles.first;

Garment garment(
  String id,
  GarmentCategory category, {
  int formality = 2,
  int color = 0xffeeeeee,
  Fit? fit,
}) => Garment(
  id: id,
  category: category,
  subtype: category.name,
  formality: formality,
  primaryColor: color,
  colorFamily: classifyColor(color),
  fit: fit,
);

final top = garment('top', GarmentCategory.top);
final bottom = garment('bottom', GarmentCategory.bottom);
final shoes = garment('shoes', GarmentCategory.shoes);
final layer = garment('layer', GarmentCategory.outerwear);
