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
import 'garment_editor_scaffold.dart';
import 'garment_fields.dart';

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
  GarmentCategory? _subtypeFilter;
  String _subtype = '';
  int _formality = 2;
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
      _category = _subtypeFilter = garment.category;
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
      final secondaryFamily = secondary == null
          ? null
          : classifyColor(secondary);
      final family = classifyColor(_color);
      final garment = widget.item?.garment;
      if (garment == null) {
        await actions.add(
          GarmentDraft(
            category: category,
            subtype: _subtype,
            formality: _formality,
            primaryColor: _color,
            colorFamily: family,
            secondaryColor: secondary,
            secondaryColorFamily: secondaryFamily,
            pattern: _pattern,
            photoPath: widget.photo!.path,
            fit: _fit,
            warmth: _warmth,
          ),
        );
      } else {
        await actions.update(
          garment.copyWith(
            category: category,
            subtype: _subtype,
            formality: _formality,
            primaryColor: _color,
            colorFamily: family,
            secondaryColor: secondary,
            secondaryColorFamily: secondaryFamily,
            pattern: _pattern,
            fit: _fit,
            warmth: _warmth,
          ),
        );
      }
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
        batch.advance((
          category: _category!,
          subtype: _subtype,
          formality: _formality,
        ));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final batch = widget.batch;
    final editing = widget.item != null;
    final photoPath = widget.item?.photoPath ?? widget.photo!.path;
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GarmentColorPicker(
            path: photoPath,
            enabled: !_busy,
            onPrimary: _setPrimaryColor,
            onSamplingChanged: (value) =>
                setState(() => _samplingPrimary = value),
          ),
          if (_busy) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          GarmentClassification(
            category: _category,
            subtypeFilter: _subtypeFilter,
            subtype: _subtype,
            formality: _formality,
            onCategory: _busy
                ? null
                : (value) => setState(() {
                    if (_category != value) _subtype = '';
                    _category = _subtypeFilter = value;
                  }),
            onSubtype: _busy
                ? null
                : (category, subtype) => setState(() {
                    _category = category;
                    _subtype = subtype ?? '';
                  }),
            onFormality: _busy
                ? null
                : (value) => setState(() => _formality = value!),
          ),
          GarmentAppearance(
            primary: _color,
            secondary: _secondaryColor,
            photoPath: photoPath,
            pattern: _pattern,
            onPrimary: _busy ? null : _setPrimaryColor,
            onSecondary: _busy ? null : _setSecondaryColor,
            onPattern: _busy
                ? null
                : (value) => setState(() => _pattern = value),
          ),
          GarmentDetails(
            fit: _fit,
            warmth: _warmth,
            onFitChanged: _busy
                ? null
                : (value) => setState(() => _fit = value),
            onWarmthChanged: _busy
                ? null
                : (value) => setState(() => _warmth = value),
          ),
          if (editing)
            TextButton(
              onPressed: _busy ? null : () => unawaited(_delete()),
              child: const Text('Eliminar'),
            ),
        ],
      ),
    );
  }
}
