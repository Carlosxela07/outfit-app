import 'package:material_ui/material_ui.dart';
import 'package:outfit_engine/outfit_engine.dart';

import 'garment_options.dart';

class GarmentChoices<T> extends StatelessWidget {
  const GarmentChoices({
    required this.title,
    required this.labels,
    required this.value,
    required this.onChanged,
    this.optional = false,
    super.key,
  });

  final String title;
  final Map<T, String> labels;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      Wrap(
        spacing: 8,
        children: [
          for (final entry in labels.entries)
            ChoiceChip(
              label: Text(entry.value),
              selected: value == entry.key,
              onSelected: onChanged == null
                  ? null
                  : (selected) {
                      if (selected || optional) {
                        onChanged?.call(selected ? entry.key : null);
                      }
                    },
            ),
        ],
      ),
    ],
  );
}

class GarmentColorField extends StatelessWidget {
  const GarmentColorField({
    required this.color,
    required this.onChanged,
    super.key,
  });

  final int color;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: _swatch(context, color),
    title: const Text('Color'),
    subtitle: Text(colorFamilyLabels[classifyColor(color)]!),
    enabled: onChanged != null,
    onTap: onChanged == null
        ? null
        : () async {
            final selected = await showDialog<int>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Elegir color'),
                content: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final entry in garmentPalette.entries)
                      IconButton(
                        tooltip: entry.key,
                        onPressed: () => Navigator.pop(context, entry.value),
                        icon: _swatch(context, entry.value),
                      ),
                  ],
                ),
              ),
            );
            if (context.mounted && selected != null) onChanged?.call(selected);
          },
  );

  Widget _swatch(BuildContext context, int value) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: Color(value),
      shape: BoxShape.circle,
      border: Border.all(color: Theme.of(context).colorScheme.outline),
    ),
  );
}
