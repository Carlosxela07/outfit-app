import 'package:material_ui/material_ui.dart';
import 'package:outfit_engine/outfit_engine.dart';

import 'garment_fields.dart';
import 'garment_options.dart';

class GarmentClassification extends StatelessWidget {
  const GarmentClassification({
    required this.category,
    required this.subtypeFilter,
    required this.subtype,
    required this.formality,
    required this.onCategory,
    required this.onSubtype,
    required this.onFormality,
    super.key,
  });

  final GarmentCategory? category;
  final GarmentCategory? subtypeFilter;
  final String subtype;
  final int formality;
  final ValueChanged<GarmentCategory?>? onCategory;
  final void Function(GarmentCategory, String?)? onSubtype;
  final ValueChanged<int?>? onFormality;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GarmentChoices<GarmentCategory>(
        title: 'Categoría',
        labels: categoryLabels,
        value: category,
        onChanged: onCategory,
      ),
      _GarmentSubtypes(
        category: category,
        filter: subtypeFilter,
        subtype: subtype,
        onChanged: onSubtype,
      ),
      GarmentChoices<int>(
        title: 'Formalidad',
        labels: {
          for (var i = 0; i < formalityLabels.length; i++)
            i + 1: formalityLabels[i],
        },
        value: formality,
        onChanged: onFormality,
      ),
    ],
  );
}

class _GarmentSubtypes extends StatelessWidget {
  const _GarmentSubtypes({
    required this.category,
    required this.filter,
    required this.subtype,
    required this.onChanged,
  });

  final GarmentCategory? category;
  final GarmentCategory? filter;
  final String subtype;
  final void Function(GarmentCategory, String?)? onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Subtipo', style: Theme.of(context).textTheme.titleMedium),
      for (final entry in subtypeLabels.entries)
        if (filter == null || filter == entry.key)
          GarmentChoices<String>(
            title: filter == null ? categoryLabels[entry.key] : null,
            compactTitle: true,
            labels: entry.value,
            value: category == entry.key ? subtype : null,
            optional: true,
            onChanged: onChanged == null
                ? null
                : (value) => onChanged?.call(entry.key, value),
          ),
    ],
  );
}
