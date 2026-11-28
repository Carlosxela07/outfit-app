import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:outfit_engine/outfit_engine.dart';

import '../../../core/storage/dominant_color.dart';
import '../application/wardrobe_providers.dart';
import '../data/capture_settings_repository.dart';
import '../data/garment_repository.dart';
import 'garment_classification.dart';
import 'garment_color_picker.dart';
import 'garment_editor_body.dart';
import 'garment_editor_scaffold.dart';
import 'garment_fields.dart';
import 'garment_options.dart';

class GarmentEditor extends ConsumerStatefulWidget {
  const GarmentEditor.add(
    XFile this.photo, {
    this.defaults,
    this.batch,
    super.key,
  }) : item = null;

  const GarmentEditor.edit(WardrobeItem this.item, {super.key})
    : photo = null,
      defaults = null,
      batch = null;

  final XFile? photo;
  final WardrobeItem? item;
  final GarmentDefaults? defaults;
  final ({
    int position,
    int total,
    Future<DetectedColors?> colors,
    ValueChanged<GarmentDefaults?> advance,
    VoidCallback exit,
  })?
  batch;

  @override
  ConsumerState<GarmentEditor> createState() => _GarmentEditorState();
}

class _GarmentEditorState extends ConsumerState<GarmentEditor> {
  GarmentCategory? _category;
  String _subtype = '';
  int _formality = 2;
  bool _formalityEdited = false;
  int _color = defaultGarmentColor;
  int? _secondaryColor;
  GarmentPattern _pattern = GarmentPattern.solid;
  Fit? _fit;
  Warmth? _warmth;
  bool _busy = false;
  bool _samplingPrimary = false;
  bool _colorChosen = false;
  bool _secondaryChosen = false;
  Future<void>? _colorDetection;

  @override
  void initState() {
    super.initState();
    final garment = widget.item?.garment;
    if (garment == null) {
      final defaults = widget.defaults;
      if (defaults != null) {
        _category = defaults.category;
        _subtype = defaults.subtype;
        _formality = defaults.formality;
      }
      _colorDetection = _detectColor(widget.photo!);
    } else {
      _category = garment.category;
      _subtype = garment.subtype;
      _formality = garment.formality;
      _color = garment.primaryColor;
      _secondaryColor = garment.secondaryColor;
      _pattern = garment.pattern;
      _fit = garment.fit;
      _warmth = garment.warmth;
    }
  }

  Future<void> _detectColor(XFile photo) async {
    try {
      final colors =
          await (widget.batch?.colors ??
              ref.read(garmentPhotosProvider).detectPhotoColors(photo.path));
      if (!mounted || colors == null) return;
      setState(() {
        if (!_colorChosen) _color = colors.primary;
        if (!_secondaryChosen) _secondaryColor = colors.secondary;
      });
    } on Exception {
      // Use the default color if the photo cannot be sampled.
    }
  }

  Future<void> _save() async {
    final category = _category;
    if (category == null || _busy || _samplingPrimary) return;

    await _submit((actions) async {
      await _colorDetection;
      final secondary = _secondaryColor;
      await actions.save(
        GarmentDraft(
          category: category,
          subtype: _subtype,
          formality: _formality,
          primaryColor: _color,
          colorFamily: classifyColor(_color),
          secondaryColor: secondary,
          secondaryColorFamily: secondary == null
              ? null
              : classifyColor(secondary),
          pattern: _pattern,
          photoPath: _photoPath,
          fit: _fit,
          warmth: _warmth,
        ),
        existing: widget.item?.garment,
      );
    }, 'No se pudo guardar la prenda. Intenta de nuevo.');
  }

  void _setPrimaryColor(int color) => setState(() {
    _colorChosen = true;
    _color = color;
  });

  void _setSecondaryColor(int? color) => setState(() {
    _secondaryChosen = true;
    _secondaryColor = color;
  });

  Future<void> _delete() async {
    final confirmed = await confirmGarmentDeletion(context);
    if (!mounted || confirmed != true || _busy) return;
    await _submit(
      (actions) => actions.delete(widget.item!),
      'No se pudo eliminar la prenda. Intenta de nuevo.',
    );
  }

  Future<void> _submit(
    Future<void> Function(WardrobeActions) operation,
    String errorMessage,
  ) async {
    setState(() => _busy = true);
    try {
      await operation(ref.read(wardrobeActionsProvider));
      if (!mounted) return;
      final batch = widget.batch;
      if (batch == null) {
        Navigator.pop(context, true);
      } else {
        batch.advance(_selectedValues);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  GarmentDefaults get _selectedValues =>
      (category: _category!, subtype: _subtype, formality: _formality);

  String get _photoPath => widget.item?.photoPath ?? widget.photo!.path;

  @override
  Widget build(BuildContext context) {
    final batch = widget.batch;
    final editing = widget.item != null;
    final compact = widget.defaults != null;
    return GarmentEditorScaffold(
      editing: editing,
      busy: _busy,
      position: batch?.position,
      total: batch?.total,
      onExit: batch?.exit,
      onSkip: batch == null ? null : () => batch.advance(null),
      onSave: _busy || _samplingPrimary || _category == null
          ? null
          : () => unawaited(_save()),
      body: GarmentEditorBody(
        summary: compact ? _selectedValues : null,
        color: _color,
        busy: _busy,
        photo: GarmentColorPicker(
          path: _photoPath,
          enabled: !_busy,
          onPrimary: _setPrimaryColor,
          onSamplingChanged: (value) =>
              setState(() => _samplingPrimary = value),
        ),
        classification: GarmentClassification(
          category: _category,
          subtype: _subtype,
          onCategory: _busy
              ? null
              : (value) => setState(() {
                  _category = value;
                  _subtype = '';
                }),
          onSubtype: _busy
              ? null
              : (category, subtype) => setState(() {
                  _category = category;
                  _subtype = subtype ?? '';
                  final typical = typicalFormalityBySubtype[subtype];
                  if (!_formalityEdited && typical != null) {
                    _formality = typical;
                  }
                }),
        ),
        formality: GarmentFormalityField(
          value: _formality,
          onChanged: _busy
              ? null
              : (value) => setState(() {
                  _formality = value;
                  _formalityEdited = true;
                }),
        ),
        colors: GarmentAppearance(
          primary: _color,
          secondary: _secondaryColor,
          photoPath: _photoPath,
          onPrimary: _busy ? null : _setPrimaryColor,
          onSecondary: _busy ? null : _setSecondaryColor,
        ),
        pattern: GarmentPatternField(
          pattern: _pattern,
          onChanged: _busy ? null : (value) => setState(() => _pattern = value),
        ),
        details: GarmentDetails(
          fit: _fit,
          warmth: _warmth,
          initiallyExpanded: compact,
          onFitChanged: _busy ? null : (value) => setState(() => _fit = value),
          onWarmthChanged: _busy
              ? null
              : (value) => setState(() => _warmth = value),
        ),
        onDelete: editing ? () => unawaited(_delete()) : null,
      ),
    );
  }
}
