import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:outfit_app/core/db/app_database.dart';
import 'package:outfit_app/core/db/app_database_provider.dart';
import 'package:outfit_app/core/storage/dominant_color.dart';
import 'package:outfit_app/core/storage/garment_photos.dart';
import 'package:outfit_app/features/settings/presentation/settings_screen.dart';
import 'package:outfit_app/features/wardrobe/application/wardrobe_providers.dart';
import 'package:outfit_app/features/wardrobe/data/capture_settings_repository.dart';
import 'package:outfit_app/features/wardrobe/data/garment_repository.dart';
import 'package:outfit_app/features/wardrobe/presentation/garment_photo.dart';
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
    expect(find.text('Toca la prenda para ajustar el color'), findsOneWidget);
    expect(find.text('Más detalles'), findsOneWidget);
    await tester.tap(find.byType(GarmentPhoto));
    await tester.pumpAndSettle();
    expect(find.text('Color actualizado'), findsOneWidget);
    expect(find.byKey(const ValueKey('sampled-color')), findsOneWidget);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(repository.item?.garment.primaryColor, 0xffcfb084);

    await tester.tap(tile);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Tomar color secundario de la foto'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(GarmentPhoto),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Listo'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Liso'))
          .selected,
      isTrue,
    );
    await tester.tap(find.text('Color'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Azul marino'));
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(repository.item?.garment.primaryColor, 0xff20385e);
    expect(repository.item?.garment.secondaryColor, 0xffcfb084);
    expect(repository.item?.garment.pattern, GarmentPattern.solid);

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

  _testCapture(
    'selects category from subtype and remembers values until disabled',
    (tester, database) async {
      await _openPicker(tester, 'Galería');
      final shoes = find.widgetWithText(ChoiceChip, 'Calzado');
      expect(tester.widget<ChoiceChip>(shoes).selected, isFalse);
      await _tapChip(tester, 'Tenis');
      expect(tester.widget<ChoiceChip>(shoes).selected, isTrue);
      await tester.tap(find.widgetWithText(TextButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(await GarmentRepository(database).readCaptureSettings(), (
        remember: true,
        defaults: (
          category: GarmentCategory.shoes,
          subtype: 'sneakers',
          formality: 2,
        ),
      ));
      await _openPicker(tester, 'Galería');
      expect(tester.widget<ChoiceChip>(shoes).selected, isTrue);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Tenis'))
            .selected,
        isTrue,
      );
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Casual'))
            .selected,
        isTrue,
      );
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Guardar'))
            .onPressed,
        isNotNull,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Abrir ajustes'));
      await tester.pumpAndSettle();
      final setting = find.widgetWithText(
        SwitchListTile,
        'Recordar últimos valores',
      );
      expect(tester.widget<SwitchListTile>(setting).value, isTrue);
      await tester.tap(setting);
      await tester.pumpAndSettle();
      expect(tester.widget<SwitchListTile>(setting).value, isFalse);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await _openPicker(tester, 'Galería');
      expect(tester.widget<ChoiceChip>(shoes).selected, isFalse);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Tenis'))
            .selected,
        isFalse,
      );
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Guardar'))
            .onPressed,
        isNull,
      );
    },
  );

  _testCapture('saves the first and third batch photos and skips the second', (
    tester,
    database,
  ) async {
    await _openPicker(tester, 'Varias desde galería');
    expect(find.text('Prenda 1 de 3'), findsOneWidget);
    await _tapChip(tester, 'Tenis');
    await tester.tap(find.text('Guardar y siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Prenda 2 de 3'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Tenis'))
          .selected,
      isTrue,
    );
    await tester.tap(find.text('Omitir'));
    await tester.pumpAndSettle();
    expect(find.text('Prenda 3 de 3'), findsOneWidget);
    await tester.tap(find.text('Guardar y terminar'));
    await tester.pumpAndSettle();
    expect(find.text('2 prendas agregadas'), findsOneWidget);
    expect(await database.select(database.garments).get(), hasLength(2));
  });

  _testCapture(
    'confirms discarding remaining photos and keeps saved garments',
    (tester, database) async {
      await _openPicker(tester, 'Varias desde galería');
      await _tapChip(tester, 'Tenis');
      await tester.tap(find.text('Guardar y siguiente'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar las 2 fotos restantes?'), findsOneWidget);
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text('Prenda 2 de 3'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();
      expect(find.text('Clóset'), findsOneWidget);
      expect(await database.select(database.garments).get(), hasLength(1));
    },
  );

  _testCapture('saves ten photos in one batch', photoCount: 10, (
    tester,
    database,
  ) async {
    await _openPicker(tester, 'Varias desde galería');
    await _tapChip(tester, 'Tenis');
    for (var i = 1; i <= 10; i++) {
      expect(find.text('Prenda $i de 10'), findsOneWidget);
      await tester.tap(
        find.text(i == 10 ? 'Guardar y terminar' : 'Guardar y siguiente'),
      );
      await tester.pumpAndSettle();
    }
    expect(find.text('10 prendas agregadas'), findsOneWidget);
    expect(await database.select(database.garments).get(), hasLength(10));
  });

  _testCapture('takes another camera photo with remembered selections', (
    tester,
    _,
  ) async {
    await _openPicker(tester, 'Cámara');
    await _tapChip(tester, 'Tenis');
    await tester.tap(find.widgetWithText(TextButton, 'Guardar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tomar otra'));
    await tester.pumpAndSettle();
    expect(find.text('Agregar prenda'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Tenis'))
          .selected,
      isTrue,
    );
  });
}

void _testCapture(
  String description,
  Future<void> Function(WidgetTester, AppDatabase) test, {
  int photoCount = 3,
}) {
  testWidgets(description, (tester) async {
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    try {
      await _openCaptureTest(tester, database, photoCount);
      await test(tester, database);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      final closed = database.close();
      await tester.pump();
      await closed;
    }
  });
}

Future<void> _openCaptureTest(
  WidgetTester tester,
  AppDatabase database,
  int photoCount,
) async {
  await database.select(database.settings).get();

  final directory = Directory.systemTemp.createTempSync('capture_test');
  addTearDown(() => directory.deleteSync(recursive: true));
  final photos = [
    for (var i = 0; i < photoCount; i++)
      XFile(
        (File(path.join(directory.path, 'photo_$i.jpg'))..writeAsBytesSync(
              image.encodeJpg(image.Image(width: 24, height: 24)),
            ))
            .path,
      ),
  ];
  tester.view.physicalSize = const Size(900, 1500);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        garmentPhotoPickerProvider.overrideWithValue((_) async => photos.first),
        garmentMultiPhotoPickerProvider.overrideWithValue(() async => photos),
        garmentPhotosProvider.overrideWithValue(_TestGarmentPhotos(directory)),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (context) => Stack(
            children: [
              const WardrobeScreen(),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  tooltip: 'Abrir ajustes',
                  icon: const Icon(Icons.settings),
                  onPressed: () => unawaited(
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openPicker(WidgetTester tester, String option) async {
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option));
  await tester.pumpAndSettle();
}

Future<void> _tapChip(WidgetTester tester, String label) async {
  final chip = find.widgetWithText(ChoiceChip, label);
  await tester.ensureVisible(chip);
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

class _TestGarmentPhotos extends GarmentPhotos {
  const _TestGarmentPhotos(this.directory);

  final Directory directory;

  @override
  Future<DetectedColors> detectPhotoColors(String source) async =>
      detectColors(File(source).readAsBytesSync());

  @override
  Future<int?> sampleColor(
    String source,
    BoxFit fit,
    Size viewport,
    Offset position,
  ) async => 0xffcfb084;

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
  Future<({bool remember, GarmentDefaults? defaults})>
  readCaptureSettings() async => (remember: true, defaults: null);

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
