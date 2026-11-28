import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outfit_app/core/db/app_database.dart';
import 'package:outfit_app/features/wardrobe/data/garment_repository.dart';
import 'package:outfit_engine/outfit_engine.dart';

void main() {
  test('v1 garments migrate as solid and remain editable', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (db) {
          db.execute("""
        CREATE TABLE garments (
          id TEXT NOT NULL PRIMARY KEY, category TEXT NOT NULL,
          subtype TEXT NOT NULL,
          formality INTEGER NOT NULL CHECK (formality BETWEEN 1 AND 5),
          primary_color INTEGER NOT NULL, color_family TEXT NOT NULL,
          fit TEXT, warmth TEXT, last_worn_at TEXT,
          times_worn INTEGER NOT NULL DEFAULT 0,
          is_virtual INTEGER NOT NULL DEFAULT 0, photo_path TEXT NOT NULL,
          created_at TEXT NOT NULL, updated_at TEXT NOT NULL
        );
        CREATE TABLE outfit_logs (
          id TEXT NOT NULL PRIMARY KEY, worn_at TEXT NOT NULL,
          garment_ids TEXT NOT NULL
        );
        CREATE TABLE settings (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL);
        INSERT INTO garments (
          id, category, subtype, formality, primary_color, color_family,
          photo_path, created_at, updated_at
        ) VALUES ('old', 'top', 'tshirt', 2, 4294967295, 'neutral',
                  'garments/old.jpg',
                  '2026-10-01T00:00:00.000Z', '2026-10-01T00:00:00.000Z');
        PRAGMA user_version = 1;
      """);
        },
      ),
    );
    addTearDown(database.close);
    final repository = GarmentRepository(database);
    final item = (await repository.watchItems().first).single;
    final garment = item.garment;
    expect(item.photoPath, 'garments/old.jpg');
    expect(garment.pattern, GarmentPattern.solid);
    expect(garment.secondaryColor, isNull);
    expect(garment.secondaryColorFamily, isNull);

    final edited = garment.copyWith(
      secondaryColor: 0xff2233ff,
      secondaryColorFamily: ColorFamily.cool,
      pattern: GarmentPattern.stripes,
    );
    await repository.update(edited);
    expect(await repository.getById('old'), edited);

    final cleared = edited.copyWith(
      secondaryColor: null,
      secondaryColorFamily: null,
    );
    await repository.update(cleared);
    expect(await repository.getById('old'), cleared);
  });
}
