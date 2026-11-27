# ARCHITECTURE — Outfit App

## Stack
| Pieza | Elección | Por qué |
|---|---|---|
| Framework | Flutter (stable), Dart 3.14+ | Android primero, un solo código |
| UI | Material 3 vía `package:material_ui` (como genera la plantilla de Flutter actual) | Consistencia con la plantilla |
| Estado | `flutter_riverpod` | Simple, testeable, sin contexto mágico |
| Navegación | `go_router` | Rutas declarativas, tabs con `StatefulShellRoute` |
| Base de datos | `drift` + `drift_flutter` (SQLite) | Tipado, migraciones, queries reactivas |
| Generación de código | `build_runner`, `drift_dev` (dev) | Requerido por Drift |
| Fotos | `image_picker`, `path_provider`, `path` | Cámara/galería y guardar archivos |
| Color desde foto | `image` (Dart puro) | Calcular color dominante sin servicios externos |
| IDs | `uuid` | IDs estables para prendas y outfits |
| Lints | `flutter_lints` + reglas extra (ver abajo) | Atrapar errores antes de la revisión |

Cualquier dependencia fuera de esta lista requiere aprobación (ver `AGENTS.md`).

## Estructura de carpetas
```
outfit_app/
├── AGENTS.md
├── docs/                      # PRD, arquitectura, decisiones
├── tasks/                     # tickets
├── packages/
│   └── outfit_engine/         # Dart puro: modelos + motor de outfits
│       ├── lib/
│       │   ├── outfit_engine.dart      # exports públicos
│       │   └── src/
│       │       ├── models/             # Garment, Outfit, enums, StyleProfile
│       │       ├── rules/              # una regla por archivo
│       │       └── engine/             # generador, scoring, reroll, gap analysis
│       └── test/
├── lib/
│   ├── main.dart
│   ├── app/                   # MaterialApp, router, tema
│   ├── core/                  # base de datos, almacenamiento de fotos, utilidades
│   │   ├── db/
│   │   └── storage/
│   └── features/
│       ├── wardrobe/          # clóset: lista, agregar, editar
│       ├── today/             # pantalla diaria
│       ├── gaps/              # qué me falta
│       └── settings/          # perfil, respaldo
│           (cada feature: data/ · application/ · presentation/)
└── test/                      # tests de la app (widgets, repositorios)
```

### Capas dentro de cada feature
- `presentation/`: pantallas y widgets. Solo leen providers, no hablan con la BD.
- `application/`: providers/notifiers de Riverpod, casos de uso.
- `data/`: repositorios que traducen entre Drift y los modelos de `outfit_engine`.

## Regla de oro: el motor es Dart puro
`packages/outfit_engine` **no conoce Flutter, Drift, archivos ni fechas del sistema**:
- Recibe una lista de `Garment`, un `StyleProfile`, la fecha "hoy" y opciones (ancla, pool previo, semilla aleatoria).
- Devuelve `List<OutfitSuggestion>` con `score` y `reasons` (frases en español).
- La aleatoriedad usa una semilla inyectada → mismos datos + misma semilla = mismo resultado (testeable).
- Se prueba con `dart test` en milisegundos.

La app lo usa como dependencia local en `pubspec.yaml`:
```yaml
dependencies:
  outfit_engine:
    path: packages/outfit_engine
```

## Modelo de datos (dominio, en `outfit_engine`)
```dart
enum GarmentCategory { top, bottom, outerwear, shoes, accessory }
enum ColorFamily { neutral, warm, cool, accent }
enum Fit { slim, regular, loose }
enum Warmth { light, medium, warm }

class Garment {
  final String id;
  final GarmentCategory category;
  final String subtype;          // 'tshirt', 'shirt', 'jeans', 'sneakers'...
  final int formality;           // 1..5
  final int primaryColor;        // ARGB
  final ColorFamily colorFamily;
  final Fit? fit;
  final Warmth? warmth;
  final DateTime? lastWornAt;
  final int timesWorn;
  final bool isVirtual;          // true solo en gap analysis
}

class StyleProfile {             // un estilo = pesos del motor
  final String id;               // 'casual', 'smart_casual', 'streetwear', 'minimal'
  final String name;
  final (int, int) formalityRange;
  final Map<String, double> ruleWeights;
}

class OutfitSuggestion {
  final Garment top, bottom, shoes;
  final Garment? outerwear, accessory;
  final double score;
  final List<String> reasons;
}
```
La foto **no** vive en el motor: la app guarda `photoPath` en la tabla de Drift.

## Base de datos (Drift)
- `garments`: columnas del modelo + `photoPath`, `createdAt`, `updatedAt`.
- `outfit_logs`: `id`, `wornAt`, ids de prendas usadas (para historial y rotación).
- `settings`: clave-valor (estilo por defecto, fit preferido).
- Migraciones versionadas desde el día 1 (`schemaVersion` + `MigrationStrategy`).

## Fotos
- Se copian a `getApplicationDocumentsDirectory()/garments/<id>.jpg`, redimensionadas a máx. 1080 px de lado y calidad ~85 (`image_picker` permite `maxWidth` y `imageQuality`).
- Al borrar una prenda se borra su archivo.

## Motor v1 (resumen; detalle en su ticket)
Score = suma ponderada de reglas, cada una devuelve `(puntos, frase?)`:
- **Formalidad coherente:** diferencia máx. entre prendas ≤ 2; calzado dentro del rango del estilo.
- **Color:** neutros combinan con todo; máximo 1 acento; evitar dos cálidos fuertes juntos.
- **Volumen:** penaliza holgado arriba + holgado abajo (si hay datos de fit).
- **Rotación:** penaliza prendas usadas hace poco (por días desde `lastWornAt`).
- **Estilo:** bonus si la formalidad cae en el rango del `StyleProfile`.
Las 3 sugerencias deben ser distintas entre sí (no compartir top+bottom).

## Lints extra (`analysis_options.yaml`)
Además de `flutter_lints`: `prefer_const_constructors`, `prefer_final_locals`, `always_declare_return_types`, `avoid_print`, `require_trailing_commas`, `unawaited_futures`, `directives_ordering`.

## Tests
- Motor: tests unitarios exhaustivos (`packages/outfit_engine/test`).
- Repositorios: tests con Drift en memoria (`NativeDatabase.memory()`).
- UI: algunos widget tests por pantalla principal (no buscamos 100%).
