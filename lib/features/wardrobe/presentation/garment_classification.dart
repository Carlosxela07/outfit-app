import 'package:material_ui/material_ui.dart';
import 'package:outfit_engine/outfit_engine.dart';

import 'garment_fields.dart';
import 'garment_options.dart';

class GarmentClassification extends StatefulWidget {
  const GarmentClassification({
    required this.category,
    required this.subtype,
    required this.onCategory,
    required this.onSubtype,
    super.key,
  });

  final GarmentCategory? category;
  final String subtype;
  final ValueChanged<GarmentCategory>? onCategory;
  final void Function(GarmentCategory, String?)? onSubtype;

  @override
  State<GarmentClassification> createState() => _GarmentClassificationState();
}

class _GarmentClassificationState extends State<GarmentClassification> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final grouped = category == null || _showAll;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GarmentChoices<GarmentCategory>(
          title: 'Categoría',
          labels: categoryLabels,
          value: category,
          onChanged: widget.onCategory == null
              ? null
              : (value) {
                  setState(() => _showAll = false);
                  widget.onCategory?.call(value!);
                },
        ),
        Text('Subtipo', style: Theme.of(context).textTheme.titleMedium),
        for (final entry in subtypeLabels.entries)
          if (grouped || entry.key == category)
            GarmentChoices<String>(
              title: grouped ? categoryLabels[entry.key] : null,
              compactTitle: true,
              labels: entry.value,
              value: category == entry.key ? widget.subtype : null,
              optional: true,
              trailing: grouped
                  ? null
                  : ActionChip(
                      label: const Text('Otro tipo…'),
                      onPressed: widget.onSubtype == null
                          ? null
                          : () => setState(() => _showAll = true),
                    ),
              onChanged: widget.onSubtype == null
                  ? null
                  : (value) {
                      setState(() => _showAll = false);
                      if (value != null || !grouped) {
                        widget.onSubtype?.call(entry.key, value);
                      }
                    },
            ),
      ],
    );
  }
}

class GarmentFormalityField extends StatelessWidget {
  const GarmentFormalityField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => GarmentChoices<int>(
    title: 'Formalidad',
    labels: {
      for (var i = 0; i < formalityLabels.length; i++)
        i + 1: formalityLabels[i],
    },
    value: value,
    onChanged: onChanged == null ? null : (value) => onChanged?.call(value!),
  );
}
