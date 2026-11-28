import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outfit_engine/outfit_engine.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/app_database_provider.dart';

import 'capture_settings_repository.dart';

final garmentRepositoryProvider = Provider<GarmentRepository>(
  (ref) => GarmentRepository(ref.watch(appDatabaseProvider)),
);

class GarmentDraft {
  const GarmentDraft({
    required this.category,
    required this.subtype,
    required this.formality,
    required this.primaryColor,
    required this.colorFamily,
    required this.photoPath,
    this.secondaryColor,
    this.secondaryColorFamily,
    this.pattern = GarmentPattern.solid,
    this.fit,
    this.warmth,
  });

  final GarmentCategory category;
  final String subtype;
  final int formality;
  final int primaryColor;
  final ColorFamily colorFamily;
  final String photoPath;
  final int? secondaryColor;
  final ColorFamily? secondaryColorFamily;
  final GarmentPattern pattern;
  final Fit? fit;
  final Warmth? warmth;
}

class WardrobeItem {
  const WardrobeItem({required this.garment, required this.photoPath});

  final Garment garment;
  final String photoPath;
}

class GarmentRepository {
  GarmentRepository(this._database);

  final AppDatabase _database;
  static const _uuid = Uuid();

  Stream<List<Garment>> watchAll({GarmentCategory? category}) =>
      watchItems(category: category)
          .map((items) => items.map((item) => item.garment).toList());

  Stream<List<WardrobeItem>> watchItems({GarmentCategory? category}) {
    final query = _database.select(_database.garments)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    if (category != null) {
      query.where((row) => row.category.equalsValue(category));
    }
    return query.watch().map((rows) => rows.map(_toItem).toList());
  }

  Future<Garment?> getById(String id) async => (await getItemById(id))?.garment;

  Future<WardrobeItem?> getItemById(String id) async {
    final query = _database.select(_database.garments)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toItem(row);
  }

  Future<({bool remember, GarmentDefaults? defaults})> readCaptureSettings() =>
      CaptureSettingsRepository(_database).read();

  Future<String> add(GarmentDraft draft, {String? id}) =>
      _database.transaction(() async {
        final garmentId = id ?? _uuid.v4();
        final now = DateTime.now().toUtc();
        await _database
            .into(_database.garments)
            .insert(
              GarmentsCompanion.insert(
                id: garmentId,
                category: draft.category,
                subtype: draft.subtype,
                formality: draft.formality,
                primaryColor: draft.primaryColor,
                colorFamily: draft.colorFamily,
                secondaryColor: Value(draft.secondaryColor),
                secondaryColorFamily: Value(draft.secondaryColorFamily),
                pattern: Value(draft.pattern),
                fit: Value(draft.fit),
                warmth: Value(draft.warmth),
                photoPath: draft.photoPath,
                createdAt: now,
                updatedAt: now,
              ),
            );
        await CaptureSettingsRepository(_database).remember((
          category: draft.category,
          subtype: draft.subtype,
          formality: draft.formality,
        ));
        return garmentId;
      });

  Future<void> update(Garment garment) async {
    final query = _database.update(_database.garments)
      ..where((row) => row.id.equals(garment.id));
    await query.write(
      GarmentsCompanion(
        category: Value(garment.category),
        subtype: Value(garment.subtype),
        formality: Value(garment.formality),
        primaryColor: Value(garment.primaryColor),
        colorFamily: Value(garment.colorFamily),
        secondaryColor: Value(garment.secondaryColor),
        secondaryColorFamily: Value(garment.secondaryColorFamily),
        pattern: Value(garment.pattern),
        fit: Value(garment.fit),
        warmth: Value(garment.warmth),
        lastWornAt: Value(garment.lastWornAt?.toUtc()),
        timesWorn: Value(garment.timesWorn),
        isVirtual: Value(garment.isVirtual),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> delete(String id, {Future<void> Function()? deletePhoto}) =>
      _database.transaction(() async {
        final query = _database.delete(_database.garments)
          ..where((row) => row.id.equals(id));
        await query.go();
        await deletePhoto?.call();
      });

  Future<void> markWorn(List<String> ids, DateTime when) async {
    final garmentIds = ids.toSet();
    if (garmentIds.isEmpty) return;

    await _database.transaction(() async {
      final query = _database.update(_database.garments)
        ..where((row) => row.id.isIn(garmentIds));
      final wornAt = when.toUtc();
      final updated = await query.write(
        GarmentsCompanion.custom(
          lastWornAt: Variable(wornAt),
          timesWorn: _database.garments.timesWorn + const Constant(1),
          updatedAt: Variable(DateTime.now().toUtc()),
        ),
      );
      if (updated != garmentIds.length) {
        throw StateError('At least one garment does not exist.');
      }
      await _database
          .into(_database.outfitLogs)
          .insert(
            OutfitLogsCompanion.insert(
              id: _uuid.v4(),
              wornAt: wornAt,
              garmentIds: jsonEncode(garmentIds.toList()),
            ),
          );
    });
  }

  WardrobeItem _toItem(GarmentRow row) => WardrobeItem(
    garment: Garment(
      id: row.id,
      category: row.category,
      subtype: row.subtype,
      formality: row.formality,
      primaryColor: row.primaryColor,
      colorFamily: row.colorFamily,
      secondaryColor: row.secondaryColor,
      secondaryColorFamily: row.secondaryColorFamily,
      pattern: row.pattern,
      fit: row.fit,
      warmth: row.warmth,
      lastWornAt: row.lastWornAt,
      timesWorn: row.timesWorn,
      isVirtual: row.isVirtual,
    ),
    photoPath: row.photoPath,
  );
}
