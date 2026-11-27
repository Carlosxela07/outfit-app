import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outfit_app/core/db/app_database.dart';
import 'package:outfit_app/features/wardrobe/data/garment_repository.dart';
import 'package:outfit_engine/outfit_engine.dart';

void main() {
  late AppDatabase database;
  late GarmentRepository repository;

  const top = GarmentDraft(
    category: GarmentCategory.top,
    subtype: 'tshirt',
    formality: 2,
    primaryColor: 0xFF123456,
    colorFamily: ColorFamily.cool,
    photoPath: 'garments/top.jpg',
    fit: Fit.regular,
    warmth: Warmth.light,
  );
  const shoes = GarmentDraft(
    category: GarmentCategory.shoes,
    subtype: 'sneakers',
    formality: 2,
    primaryColor: 0xFFFFFFFF,
    colorFamily: ColorFamily.neutral,
    photoPath: 'garments/shoes.jpg',
  );

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = GarmentRepository(database);
  });

  tearDown(() => database.close());

  test(
    'add stores a UUID, garment fields, photo path and creation time',
    () async {
      final before = DateTime.now().toUtc();
      final id = await repository.add(top);
      expect(
        id,
        matches(
          RegExp(
            r'^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$',
          ),
        ),
      );
      final expected = Garment(
        id: id,
        category: top.category,
        subtype: top.subtype,
        formality: top.formality,
        primaryColor: top.primaryColor,
        colorFamily: top.colorFamily,
        fit: top.fit,
        warmth: top.warmth,
      );
      expect(await repository.getById(id), expected);
      final item = (await repository.getItemById(id))!;
      expect(item.garment, expected);
      expect(item.photoPath, top.photoPath);
      final row = await database.select(database.garments).getSingle();
      expect(row.createdAt.isBefore(before), isFalse);
      expect(row.createdAt.isAfter(DateTime.now().toUtc()), isFalse);
      expect(row.updatedAt, row.createdAt);
      expect(await repository.getById('missing'), isNull);
    },
  );

  test('watchAll emits changes for the requested category', () async {
    final shoesId = await repository.add(shoes);
    final initial = await repository.watchAll().first;
    expect(initial.single.id, shoesId);

    final watched = expectLater(
      repository.watchAll(category: GarmentCategory.top),
      emitsInOrder([
        isEmpty,
        [
          isA<Garment>().having(
            (garment) => garment.category,
            'category',
            GarmentCategory.top,
          ),
        ],
        isEmpty,
      ]),
    );
    await repository.watchAll(category: GarmentCategory.top).first;
    final id = await repository.add(top);
    final items = await repository
        .watchItems(category: GarmentCategory.top)
        .first;
    expect(items.single.photoPath, top.photoPath);
    await repository.delete(id);
    await watched;
    expect((await repository.watchAll().first).single.id, shoesId);
  });

  test('watchItems lists garments from newest to oldest', () async {
    for (final (id, date) in [
      ('a', DateTime.utc(2026, 10, 1)),
      ('c', DateTime.utc(2026, 10, 3)),
      ('b', DateTime.utc(2026, 10, 4)),
    ]) {
      await database
          .into(database.garments)
          .insert(
            GarmentsCompanion.insert(
              id: id,
              category: top.category,
              subtype: top.subtype,
              formality: top.formality,
              primaryColor: top.primaryColor,
              colorFamily: top.colorFamily,
              photoPath: top.photoPath,
              createdAt: date,
              updatedAt: date,
            ),
          );
    }

    final items = await repository.watchItems().first;
    expect(items.map((item) => item.garment.id), ['b', 'c', 'a']);
  });

  test(
    'update writes nullable fields and preserves the photo and creation time',
    () async {
      final id = await repository.add(top);
      final original = await database.select(database.garments).getSingle();
      final garment = (await repository.getById(id))!;
      final edited = garment.copyWith(
        subtype: 'shirt',
        fit: null,
        warmth: null,
      );
      await repository.update(edited);

      expect(await repository.getById(id), edited);
      final row = await database.select(database.garments).getSingle();
      expect(row.photoPath, top.photoPath);
      expect(row.createdAt, original.createdAt);
      expect(row.updatedAt.isBefore(original.updatedAt), isFalse);
    },
  );

  test('delete removes the garment', () async {
    final id = await repository.add(top);
    await repository.delete(id);
    expect(await repository.getItemById(id), isNull);
    expect(await repository.watchAll().first, isEmpty);
  });

  test('markWorn increments counters and records one log per outfit', () async {
    final topId = await repository.add(top);
    final shoesId = await repository.add(shoes);
    final when = DateTime.utc(2026, 10, 3, 14, 25, 30, 456, 789);
    final next = when.add(const Duration(days: 1));

    await repository.markWorn([topId, shoesId, topId], when);
    await repository.markWorn([topId], next);

    final wornTop = (await repository.getById(topId))!;
    expect(wornTop.lastWornAt, next);
    expect(wornTop.timesWorn, 2);
    final wornShoes = (await repository.getById(shoesId))!;
    expect(wornShoes.lastWornAt, when);
    expect(wornShoes.timesWorn, 1);

    final logs = await database.select(database.outfitLogs).get();
    expect(logs, hasLength(2));
    expect(
      jsonDecode(logs.singleWhere((log) => log.wornAt == when).garmentIds),
      [topId, shoesId],
    );
    expect(
      jsonDecode(logs.singleWhere((log) => log.wornAt == next).garmentIds),
      [topId],
    );
  });

  test('markWorn rolls back when a garment is missing', () async {
    final id = await repository.add(top);
    final before = await database.select(database.garments).getSingle();

    await expectLater(
      repository.markWorn([id, 'missing'], DateTime.utc(2026)),
      throwsStateError,
    );

    expect(await database.select(database.garments).getSingle(), before);
    expect(await database.select(database.outfitLogs).get(), isEmpty);
  });
}
