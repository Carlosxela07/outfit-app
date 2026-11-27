# 001 — Base del proyecto: estructura, dependencias y navegación

**Rama:** `feat/001-base-proyecto`
**Lee antes:** `AGENTS.md`, `docs/ARCHITECTURE.md` (Stack, Estructura de carpetas, Lints extra)

## Contexto
Hoy el repo tiene la plantilla del contador de Flutter. Queremos el esqueleto real de la app: carpetas, dependencias base, tema, y navegación con pestañas vacías. Nada de lógica todavía.

## Qué hacer
1. Reemplaza la app del contador por la estructura de `docs/ARCHITECTURE.md` (crea las carpetas de `lib/app`, `lib/core`, `lib/features/{wardrobe,today,gaps,settings}` con lo mínimo necesario; no crees archivos vacíos sin uso).
2. Agrega dependencias con `flutter pub add`: `flutter_riverpod`, `go_router`.
   (Drift, image_picker, etc. llegan en sus tickets; **no** las agregues aquí.)
3. `lib/main.dart`: envuelve la app en `ProviderScope` y arranca `App` (en `lib/app/app.dart`).
4. `lib/app/router.dart`: `GoRouter` con `StatefulShellRoute.indexedStack` y **4 pestañas** en una `NavigationBar` inferior:
   | Ruta | Pestaña | Icono sugerido |
   |---|---|---|
   | `/today` (inicial) | Hoy | checkroom / wb_sunny |
   | `/wardrobe` | Clóset | dresser / inventory |
   | `/gaps` | Qué me falta | shopping_bag |
   | `/settings` | Ajustes | settings |
5. Cada pestaña es una pantalla placeholder con `AppBar` (título en español) y un texto centrado describiendo qué irá ahí.
6. `lib/app/theme.dart`: tema Material 3 claro y oscuro con `ColorScheme.fromSeed` (seed a tu criterio, tonos sobrios), `themeMode: ThemeMode.system`.
7. Nombre visible de la app: **"Outfit"** (`title` de MaterialApp y `android:label` en `AndroidManifest.xml`).
8. Actualiza `analysis_options.yaml` con las reglas extra de `docs/ARCHITECTURE.md` y deja `flutter analyze` en **0 issues**.
9. Reemplaza `test/widget_test.dart` por un test que verifique: la app arranca en "Hoy", y al tocar cada pestaña se muestra su pantalla.
10. Reemplaza `README.md` por uno corto: qué es la app, cómo correrla (`flutter run`), y que las reglas para agentes están en `AGENTS.md`.

## Criterios de aceptación
- [ ] `flutter run` abre la app en la pestaña **Hoy** con barra de navegación inferior de 4 pestañas.
- [ ] Cambiar de pestaña conserva el estado de cada una (indexedStack).
- [ ] Respeta modo claro/oscuro del sistema.
- [ ] `dart format .`, `flutter analyze` (0 issues) y `flutter test` pasan.
- [ ] No queda rastro del contador de la plantilla.

## Fuera de alcance
Base de datos, fotos, el paquete `outfit_engine`, cualquier lógica de outfits, diseño final de pantallas.
