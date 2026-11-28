import 'package:drift/drift.dart';
import 'package:outfit_engine/outfit_engine.dart';

part 'app_database.g.dart';

@DataClassName('GarmentRow')
class Garments extends Table {
  TextColumn get id => text()();
  TextColumn get category => textEnum<GarmentCategory>()();
  TextColumn get subtype => text()();
  IntColumn get formality => integer().customConstraint(
    'NOT NULL CHECK (formality BETWEEN 1 AND 5)',
  )();
  IntColumn get primaryColor => integer()();
  TextColumn get colorFamily => textEnum<ColorFamily>()();
  IntColumn get secondaryColor => integer().nullable()();
  TextColumn get secondaryColorFamily => textEnum<ColorFamily>().nullable()();
  TextColumn get pattern =>
      textEnum<GarmentPattern>().withDefault(const Constant('solid'))();
  TextColumn get fit => textEnum<Fit>().nullable()();
  TextColumn get warmth => textEnum<Warmth>().nullable()();
  DateTimeColumn get lastWornAt => dateTime().nullable()();
  IntColumn get timesWorn => integer().withDefault(const Constant(0))();
  BoolColumn get isVirtual => boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class OutfitLogs extends Table {
  TextColumn get id => text()();
  DateTimeColumn get wornAt => dateTime()();
  TextColumn get garmentIds => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Setting')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Garments, OutfitLogs, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await transaction(() async {
          await migrator.addColumn(garments, garments.secondaryColor);
          await migrator.addColumn(garments, garments.secondaryColorFamily);
          await migrator.addColumn(garments, garments.pattern);
        });
      }
    },
  );
}
