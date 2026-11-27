# 003 — Persistencia local: Drift + repositorio de prendas

**Rama:** `feat/003-persistencia`
**Depende de:** 002 mergeado
**Lee antes:** `AGENTS.md`, `docs/ARCHITECTURE.md` (Base de datos, Fotos, Capas)

## Contexto
Las prendas tienen que sobrevivir a cerrar la app. Creamos la base local y un repositorio que traduce entre Drift y los modelos de `outfit_engine`.

## Qué hacer
1. Dependencias: `drift`, `drift_flutter`, `path_provider`, `path`, `uuid`; dev: `drift_dev`, `build_runner`.
2. `lib/core/db/app_database.dart` con tablas `Garments`, `OutfitLogs` y `Settings` según `ARCHITECTURE.md`. `schemaVersion = 1` y `MigrationStrategy` lista para crecer.
   - Enums se guardan como texto (nombre del enum), colores como entero.
   - `OutfitLogs` guarda los ids de prendas como texto JSON o en tabla puente (elige y justifica en tu resumen).
3. Genera el código con `dart run build_runner build --delete-conflicting-outputs`. Los archivos `*.g.dart` **sí** se commitean.
4. Provider de Riverpod para la base de datos (una sola instancia).
5. `lib/features/wardrobe/data/garment_repository.dart`:
   - `Stream<List<Garment>> watchAll({GarmentCategory? category})`
   - `Future<Garment?> getById(String id)`
   - `Future<String> add(GarmentDraft draft)` → genera id con uuid, guarda `createdAt`.
   - `Future<void> update(Garment garment)`
   - `Future<void> delete(String id)`
   - `Future<void> markWorn(List<String> ids, DateTime when)` → actualiza `lastWornAt`, incrementa `timesWorn` y crea un registro en `OutfitLogs`, todo en una transacción.
   - Expón también `photoPath` (puede ser con una clase `WardrobeItem { Garment garment; String photoPath; }` en la capa de datos de la app; **no** agregues `photoPath` a `Garment` del motor).
6. Tests con base en memoria (`NativeDatabase.memory()`): add/getById, watchAll con filtro, update, delete, y markWorn (verifica contador, fecha y log).

## Criterios de aceptación
- [ ] Todos los métodos del repositorio con tests pasando.
- [ ] `markWorn` es atómico (transacción).
- [ ] La app sigue arrancando igual que tras el ticket 001.
- [ ] Todos los checks de `AGENTS.md` pasan.

## Fuera de alcance
UI del clóset, cámara, guardado de archivos de foto (solo el campo `photoPath`), export/import.
