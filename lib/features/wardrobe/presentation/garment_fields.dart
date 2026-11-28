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
    this.title = 'Color',
    this.onRemove,
    required this.onChanged,
    super.key,
  });

  final int? color;
  final String title;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: color == null
        ? const Icon(Icons.palette_outlined)
        : _swatch(context, color!),
    title: Text(title),
    subtitle: Text(
      color == null
          ? 'Sin color secundario'
          : colorFamilyLabels[classifyColor(color!)]!,
    ),
    trailing: color == null || onRemove == null
        ? null
        : IconButton(
            tooltip: 'Quitar color secundario',
            onPressed: onRemove,
            icon: const Icon(Icons.close),
          ),
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

class GarmentDetails extends StatelessWidget {
  const GarmentDetails({
    required this.fit,
    required this.warmth,
    required this.onFitChanged,
    required this.onWarmthChanged,
    super.key,
  });

  final Fit? fit;
  final Warmth? warmth;
  final ValueChanged<Fit?>? onFitChanged;
  final ValueChanged<Warmth?>? onWarmthChanged;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    tilePadding: EdgeInsets.zero,
    title: const Text('M?s detalles'),
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GarmentChoices<Fit>(
        title: 'Ajuste',
        labels: fitLabels,
        value: fit,
        optional: true,
        onChanged: onFitChanged,
      ),
      GarmentChoices<Warmth>(
        title: 'Abrigo',
        labels: warmthLabels,
        value: warmth,
        optional: true,
        onChanged: onWarmthChanged,
      ),
    ],
  );
}

class GarmentAppearance extends StatelessWidget {
  const GarmentAppearance({
    required this.primary,
    required this.secondary,
    required this.pattern,
    required this.onPrimary,
    required this.onSecondary,
    required this.onPattern,
    super.key,
  });

  final int primary;
  final int? secondary;
  final GarmentPattern pattern;
  final ValueChanged<int>? onPrimary;
  final ValueChanged<int?>? onSecondary;
  final ValueChanged<GarmentPattern>? onPattern;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GarmentColorField(color: primary, onChanged: onPrimary),
      GarmentColorField(
        title: 'Color secundario',
        color: secondary,
        onChanged: onSecondary,
        onRemove: onSecondary == null ? null : () => onSecondary?.call(null),
      ),
      GarmentChoices<GarmentPattern>(
        title: 'Estampado',
        labels: const {
          GarmentPattern.solid: 'Liso',
          GarmentPattern.stripes: 'Rayas',
          GarmentPattern.graphic: 'Estampado/logo',
          GarmentPattern.print: 'Print',
        },
        value: pattern,
        onChanged: onPattern == null
            ? null
            : (value) => onPattern?.call(value!),
      ),
    ],
  );
}
