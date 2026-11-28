import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:outfit_app/core/storage/dominant_color.dart';
import 'package:outfit_app/core/storage/garment_photos.dart';
import 'package:outfit_app/features/wardrobe/application/wardrobe_providers.dart';
import 'package:outfit_app/features/wardrobe/data/garment_repository.dart';
import 'package:outfit_app/features/wardrobe/presentation/wardrobe_screen.dart';
import 'package:outfit_engine/outfit_engine.dart';
import 'package:path/path.dart' as path;

void main() {
  testWidgets('adds, filters, edits and deletes a garment', (tester) async {
    final directory = Directory.systemTemp.createTempSync('wardrobe_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    final repository = _TestGarmentRepository();
    addTearDown(() => unawaited(repository.changes.close()));
    final photo = File(path.join(directory.path, 'photo.jpg'))
      ..writeAsBytesSync(
        image.encodeJpg(
          image.Image(width: 24, height: 24)..clear(image.ColorRgb8(255, 0, 0)),
        ),
      );
    tester.view.physicalSize = const Size(900, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          garmentRepositoryProvider.overrideWithValue(repository),
          garmentPhotoPickerProvider.overrideWithValue((source) async {
            expect(source, ImageSource.gallery);
            return XFile(photo.path);
          }),
          garmentPhotosProvider.overrideWithValue(
            _TestGarmentPhotos(directory),
          ),
        ],
        child: const MaterialApp(home: WardrobeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Galería'));
    await tester.pumpAndSettle();

    final save = find.widgetWithText(TextButton, 'Guardar');
    expect(tester.widget<TextButton>(save).onPressed, isNull);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Superior'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Casual'))
          .selected,
      isTrue,
    );
    expect(tester.widget<TextButton>(save).onPressed, isNotNull);

    await tester.tap(save);
    await tester.pumpAndSettle();

    final item = repository.item!;
    expect(item.garment.category, GarmentCategory.top);
    expect(item.garment.formality, 2);
    expect(item.garment.primaryColor & 0xff0000, greaterThan(0xf00000));
    expect(path.basename(item.photoPath), '${item.garment.id}.jpg');
    expect(File(item.photoPath).existsSync(), isTrue);

    final tile = find.byKey(ValueKey(item.garment.id));
    await tester.tap(find.widgetWithText(FilterChip, 'Calzado'));
    await tester.pumpAndSettle();
    expect(tile, findsNothing);
    await tester.tap(find.widgetWithText(FilterChip, 'Todo'));
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Editar prenda'), findsOneWidget);
    await tester.tap(find.text('Color'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Azul marino'));
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(repository.item?.garment.primaryColor, 0xff20385e);

    await tester.tap(tile);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    final confirm = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('Eliminar'),
    );
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(tile, findsNothing);
    expect(File(item.photoPath).existsSync(), isFalse);
  });
}

class _TestGarmentPhotos extends GarmentPhotos {
  const _TestGarmentPhotos(this.directory);

  final Directory directory;

  @override
  Future<DetectedColors> detectPhotoColors(String source) async =>
      detectColors(File(source).readAsBytesSync());

  @override
  Future<String> save(String id, String source) async =>
      File(source).copySync(path.join(directory.path, '$id.jpg')).path;

  @override
  Future<void> delete(String photoPath) async => File(photoPath).deleteSync();
}

class _TestGarmentRepository implements GarmentRepository {
  final changes = StreamController<void>.broadcast();
  WardrobeItem? item;

  @override
  Stream<List<WardrobeItem>> watchItems({GarmentCategory? category}) async* {
    List<WardrobeItem> matchingItems() {
      final current = item;
      return [
        if (current != null &&
            (category == null || current.garment.category == category))
          current,
      ];
    }

    yield matchingItems();
    yield* changes.stream.map((_) => matchingItems());
  }

  @override
  Future<String> add(GarmentDraft draft, {String? id}) async {
    item = WardrobeItem(
      garment: Garment(
        id: id!,
        category: draft.category,
        subtype: draft.subtype,
        formality: draft.formality,
        primaryColor: draft.primaryColor,
        colorFamily: draft.colorFamily,
        fit: draft.fit,
        warmth: draft.warmth,
      ),
      photoPath: draft.photoPath,
    );
    changes.add(null);
    return id;
  }

  @override
  Future<void> update(Garment garment) async {
    item = WardrobeItem(garment: garment, photoPath: item!.photoPath);
    changes.add(null);
  }

  @override
  Future<void> delete(String id, {Future<void> Function()? deletePhoto}) async {
    await deletePhoto?.call();
    item = null;
    changes.add(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
