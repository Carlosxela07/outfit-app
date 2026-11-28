import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:outfit_engine/outfit_engine.dart';

import '../../../core/storage/dominant_color.dart';
import '../application/wardrobe_providers.dart';
import '../data/garment_repository.dart';
import 'garment_color_picker.dart';
import 'garment_fields.dart';
import 'garment_options.dart';

class GarmentEditor extends ConsumerStatefulWidget {
  const GarmentEditor.add(XFile this.photo, {super.key}) : item = null;
  const GarmentEditor.edit(WardrobeItem this.item, {super.key}) : photo = null;

  final XFile? photo;
  final WardrobeItem? item;

  @override
  ConsumerState<GarmentEditor> createState() => _GarmentEditorState();
}

class _GarmentEditorState extends ConsumerState<GarmentEditor> {
  GarmentCategory? _category;
  String _subtype = '';
  int _formality = 2;
  int _color = defaultGarmentColor;
  int? _secondaryColor;
  GarmentPattern _pattern = GarmentPattern.solid;
  Fit? _fit;
  Warmth? _warmth;
  bool _busy = false;
  bool _colorChosen = false;
  bool _secondaryChosen = false;
  bool _patternChosen = false;
  Future<void>? _colorDetection;

  @override
  void initState() {
    super.initState();
    final garment = widget.item?.garment;
    if (garment == null) {
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
      final colors = await ref
          .read(garmentPhotosProvider)
          .detectPhotoColors(photo.path);
      if (!mounted) return;
      setState(() {
        if (!_colorChosen) _color = colors.primary;
        if (!_secondaryChosen) {
          _secondaryColor = colors.secondary;
          if (!_patternChosen && colors.secondary != null) {
            _pattern = GarmentPattern.graphic;
          }
        }
      });
    } on Exception {
      // Use the default color if the photo cannot be sampled.
    }
  }

  Future<void> _save() async {
    final category = _category;
    if (category == null || _busy) return;

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar prenda?'),
        content: const Text('Se eliminará también su foto.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
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
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtypes = subtypeLabels[_category];
    final editing = widget.item != null;
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar prenda' : 'Agregar prenda'),
          actions: [
            TextButton(
              onPressed: _busy || _category == null
                  ? null
                  : () => unawaited(_save()),
              child: const Text('Guardar'),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GarmentColorPicker(
              path: widget.item?.photoPath ?? widget.photo!.path,
              enabled: !_busy,
              onPrimary: _setPrimaryColor,
              onSecondary: _setSecondaryColor,
            ),
            if (_busy) const LinearProgressIndicator(),
            const SizedBox(height: 16),
            GarmentChoices<GarmentCategory>(
              title: 'Categoría',
              labels: categoryLabels,
              value: _category,
              onChanged: _busy
                  ? null
                  : (value) => setState(() {
                      if (_category != value) _subtype = '';
                      _category = value;
                    }),
            ),
            if (subtypes != null)
              GarmentChoices<String>(
                title: 'Subtipo',
                labels: subtypes,
                value: _subtype,
                optional: true,
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _subtype = value ?? ''),
              ),
            GarmentChoices<int>(
              title: 'Formalidad',
              labels: {
                for (var i = 0; i < formalityLabels.length; i++)
                  i + 1: formalityLabels[i],
              },
              value: _formality,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _formality = value!),
            ),
            GarmentAppearance(
              primary: _color,
              secondary: _secondaryColor,
              pattern: _pattern,
              onPrimary: _busy ? null : _setPrimaryColor,
              onSecondary: _busy ? null : _setSecondaryColor,
              onPattern: _busy
                  ? null
                  : (value) => setState(() {
                      _patternChosen = true;
                      _pattern = value;
                    }),
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
      ),
    );
  }
}
