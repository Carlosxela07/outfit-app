import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outfit_engine/outfit_engine.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/app_database_provider.dart';

typedef GarmentDefaults = ({
  GarmentCategory category,
  String subtype,
  int formality,
});

final captureSettingsRepositoryProvider = Provider<CaptureSettingsRepository>(
  (ref) => CaptureSettingsRepository(ref.watch(appDatabaseProvider)),
);

final rememberGarmentValuesProvider = StreamProvider<bool>(
  (ref) => ref.watch(captureSettingsRepositoryProvider).watchRemember(),
);

class CaptureSettingsRepository {
  const CaptureSettingsRepository(this._database);

  final AppDatabase _database;
  static const _rememberKey = 'remember_garment_values';
  static const _categoryKey = 'last_garment_category';
  static const _subtypeKey = 'last_garment_subtype';
  static const _formalityKey = 'last_garment_formality';

  Selectable<Setting> _setting(String key) =>
      _database.select(_database.settings)..where((row) => row.key.equals(key));

  Stream<bool> watchRemember() =>
      _setting(_rememberKey)
          .watchSingleOrNull()
          .map((row) => row?.value != 'false');

  Future<void> setRemember(bool value) => _database
      .into(_database.settings)
      .insertOnConflictUpdate(
        Setting(key: _rememberKey, value: value.toString()),
      );

  Future<({bool remember, GarmentDefaults? defaults})> read() async {
    final query = _database.select(_database.settings)
      ..where(
        (row) => row.key.isIn([
          _rememberKey,
          _categoryKey,
          _subtypeKey,
          _formalityKey,
        ]),
      );
    final values = {for (final row in await query.get()) row.key: row.value};
    if (values[_rememberKey] == 'false') {
      return (remember: false, defaults: null);
    }

    final category = GarmentCategory.values.asNameMap()[values[_categoryKey]];
    final formality = int.tryParse(values[_formalityKey] ?? '');
    return (
      remember: true,
      defaults:
          category == null ||
              formality == null ||
              formality < 1 ||
              formality > 5
          ? null
          : (
              category: category,
              subtype: values[_subtypeKey] ?? '',
              formality: formality,
            ),
    );
  }

  Future<void> remember(GarmentDefaults values) async {
    if ((await _setting(_rememberKey).getSingleOrNull())?.value == 'false') {
      return;
    }
    await _database.batch((batch) {
      batch.insertAllOnConflictUpdate(_database.settings, [
        Setting(key: _categoryKey, value: values.category.name),
        Setting(key: _subtypeKey, value: values.subtype),
        Setting(key: _formalityKey, value: values.formality.toString()),
      ]);
    });
  }
}
