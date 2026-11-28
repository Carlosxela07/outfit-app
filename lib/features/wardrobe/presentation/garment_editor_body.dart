import 'package:material_ui/material_ui.dart';

import '../data/capture_settings_repository.dart';
import 'garment_options.dart';

enum _Section { classification, formality, colors, all }

class GarmentEditorBody extends StatefulWidget {
  const GarmentEditorBody({
    required this.summary,
    required this.color,
    required this.photo,
    required this.classification,
    required this.formality,
    required this.colors,
    required this.pattern,
    required this.details,
    required this.busy,
    this.onDelete,
    super.key,
  });

  final GarmentDefaults? summary;
  final int color;
  final Widget photo;
  final Widget classification;
  final Widget formality;
  final Widget colors;
  final Widget pattern;
  final Widget details;
  final bool busy;
  final VoidCallback? onDelete;

  @override
  State<GarmentEditorBody> createState() => _GarmentEditorBodyState();
}

class _GarmentEditorBodyState extends State<GarmentEditorBody> {
  _Section? _open;

  void _toggle(_Section section) =>
      setState(() => _open = _open == section ? null : section);

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final all = summary == null || _open == _Section.all;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        widget.photo,
        if (widget.busy) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        if (summary != null) ...[
          _SummaryCard(
            values: summary,
            color: widget.color,
            active: _open,
            onSelected: widget.busy ? null : _toggle,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.busy ? null : () => _toggle(_Section.all),
              child: Text(all ? 'Ver resumen' : 'Editar todo'),
            ),
          ),
        ],
        if (all || _open == _Section.classification) widget.classification,
        if (all || _open == _Section.formality) widget.formality,
        if (all || _open == _Section.colors) widget.colors,
        if (all) ...[widget.pattern, widget.details],
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.busy ? null : widget.onDelete,
            child: const Text('Eliminar'),
          ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.values,
    required this.color,
    required this.active,
    required this.onSelected,
  });

  final GarmentDefaults values;
  final int color;
  final _Section? active;
  final ValueChanged<_Section>? onSelected;

  @override
  Widget build(BuildContext context) {
    final category = categoryLabels[values.category]!;
    final subtype = subtypeLabels[values.category]?[values.subtype];
    return Card(
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          spacing: 6,
          children: [
            _chip(
              _Section.classification,
              subtype == null ? category : '$category · $subtype',
            ),
            _chip(_Section.formality, formalityLabels[values.formality - 1]),
            _chip(
              _Section.colors,
              'Color',
              avatar: Icon(
                Icons.circle,
                size: 16,
                color: Color(color),
                shadows: [
                  Shadow(
                    color: Theme.of(context).colorScheme.outline,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(_Section section, String label, {Widget? avatar}) => FilterChip(
    avatar: avatar,
    label: Text(label),
    selected: active == section,
    showCheckmark: false,
    onSelected: onSelected == null ? null : (_) => onSelected?.call(section),
  );
}
