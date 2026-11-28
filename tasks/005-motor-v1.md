# 005 — Motor v1: reglas, scoring y 3 outfits explicados

**Rama:** `feat/005-motor-v1`
**Depende de:** 004 mergeado
**Lee antes:** `AGENTS.md`, `docs/PRD.md` (4.B, 4.C, 6), `docs/ARCHITECTURE.md` (Regla de oro, Motor v1)

## Contexto
Este es el cerebro de la app. Todo ocurre dentro de `packages/outfit_engine` (Dart puro). **No toques `lib/` ni la UI** en este ticket: la pantalla Hoy llega en el 006.

## Parte A — Corregir neutros de moda en `classifyColor`
En moda, azul marino, denim, café, verde olivo y caqui funcionan como **neutros** (combinan con casi todo). Hoy el clasificador los marca como warm/cool, y el motor rechazaría combinaciones buenas como jeans + camisa café.

Ajusta `classifyColor` (documenta los umbrales en el código) para que estos casos den **neutral**:
| Color | ARGB | Esperado |
|---|---|---|
| Azul marino | `0xff1f2a44` | neutral |
| Denim medio | `0xff3b5b8c` | neutral |
| Café | `0xff5c4033` | neutral |
| Verde olivo | `0xff556b2f` | neutral |
| Caqui | `0xffc3b091` | neutral |

Y que **sigan igual**:
| Color | ARGB | Esperado |
|---|---|---|
| Rojo | `0xffb52e32` | warm |
| Naranja intenso | `0xffff8000` | accent |
| Verde neón | `0xff39ff14` | accent |
| Azul rey | `0xff4169e1` | cool |
| Mostaza | `0xffd4a017` | warm |
| Negro / blanco / gris / beige | (tests actuales) | neutral |

Reemplaza el caso de test `navy 0xff000080` por los de la tabla (ese azul puro saturado no es un marino realista).

## Parte A2 — Prendas multicolor y con estampado
Hay prendas que no son de un solo color (ej. una sudadera azul marino con franja blanca y letras celestes, una camisa a rayas, una playera con estampado grande). Agrega al modelo `Garment` (con defaults para no romper nada):
```dart
enum GarmentPattern { solid, stripes, graphic, print }   // liso, rayas, estampado/logo grande, print (cuadros, flores, camuflaje...)

final int? secondaryColor;              // ARGB, opcional
final ColorFamily? secondaryColorFamily;
final GarmentPattern pattern;           // default: GarmentPattern.solid
```
- Actualiza `copyWith`, `==`, `hashCode` y tests.
- Una prenda con `pattern != solid` o con `secondaryColor` es una **prenda protagonista**.
- **No** toques la base de datos ni la UI: eso va en el ticket 006.

## Parte B — Reglas
En `lib/src/rules/`, una regla por archivo, con una interfaz común:
```dart
abstract interface class OutfitRule {
  String get id;                       // clave en StyleProfile.ruleWeights
  RuleResult evaluate(OutfitCandidate candidate, EngineContext context);
}

final class RuleResult {
  final double score;                  // 0.0 (malo) .. 1.0 (excelente)
  final String? reason;                // frase en español si la regla aporta algo notable
}
```
`OutfitCandidate` = top, bottom, shoes, outerwear? (sin score). `EngineContext` = style, `now` y lo que haga falta.

Reglas v1 (ids exactos):
1. **`formality`**: coherencia entre prendas. Diferencia máx. de formalidad entre todas las prendas: 0–1 → 1.0, 2 → 0.6, ≥3 → 0.1. Razón ejemplo: "Todo está en el mismo nivel de formalidad".
2. **`style`**: qué tanto cae el outfit en `style.formalityRange` (promedio de formalidad dentro del rango → 1.0, se reduce según la distancia). El calzado pesa doble en el promedio. Razón: "Encaja con el estilo {nombre}".
3. **`color`**: neutros combinan con todo; **máximo 1 color accent** (2+ → score muy bajo); warm + cool juntos sin neutros que los separen → penaliza moderado; todo neutro → bueno pero no perfecto (0.8). Los colores secundarios cuentan, pero un accent secundario vale **medio** accent. **Máximo 1 prenda protagonista** (Parte A2) por outfit: 2+ → score bajo; 1 protagonista con el resto liso y neutro → excelente. Razones: "Base neutra con un toque de color", "Paleta neutra y fácil de combinar", "Una sola prenda protagonista, el resto la acompaña".
4. **`volume`**: si arriba y abajo son ambos `loose` → 0.3; uno ajustado/regular y otro holgado → 1.0 con razón "Equilibra volumen arriba y abajo"; sin datos de fit → 0.7 neutro, sin razón.
5. **`rotation`**: penaliza prendas usadas recientemente según días desde `lastWornAt` (respecto a `now`): hoy → 0.0, 1–2 días → 0.3, 3–6 → 0.7, ≥7 o nunca → 1.0. Se toma el **promedio** de las prendas. Razón si todo lleva ≥7 días: "Rescata prendas que no usas hace tiempo".

Actualiza `predefinedStyles` para que cada estilo tenga pesos para las 5 reglas. Sugerencia (ajústalo si los tests lo justifican y explícalo):
| Estilo | formality | style | color | volume | rotation |
|---|---|---|---|---|---|
| casual | 1.0 | 1.0 | 1.0 | 0.5 | 1.0 |
| smart_casual | 1.5 | 1.5 | 1.0 | 0.75 | 1.0 |
| streetwear | 0.75 | 1.0 | 1.25 | 1.0 | 1.0 |
| minimal | 1.0 | 1.0 | 1.75 | 0.75 | 1.0 |

Score total = promedio ponderado de las reglas (0..1).

## Parte C — Generador
En `lib/src/engine/outfit_engine.dart`:
```dart
final class OutfitEngine {
  const OutfitEngine({List<OutfitRule>? rules});   // default: las 5 reglas v1

  List<OutfitSuggestion> suggest(
    List<Garment> closet, {
    required StyleProfile style,
    required DateTime now,
    int count = 3,
    int seed = 0,
  });
}
```
Comportamiento:
- Ignora prendas con `isVirtual == true`.
- Si falta al menos 1 top, 1 bottom o 1 shoes → devuelve lista vacía (la UI mostrará qué falta en el 006). Expón además un helper `MissingCategories missingFor(List<Garment> closet)` o similar que diga qué categorías faltan.
- Genera todas las combinaciones top × bottom × shoes. Si pasan de **5,000**, toma una muestra aleatoria **con `Random(seed)`** de 5,000.
- **Outerwear**: para cada combinación, evalúa sin capa y con cada capa disponible; quédate con la variante de mayor score (la capa solo se agrega si mejora el outfit).
- Aplica un *jitter* determinista pequeño (±3% del score, con `Random(seed)`) para que dos días con el mismo clóset no den siempre exactamente lo mismo cuando la app cambie la semilla.
- Selección de las `count` mejores con **diversidad**: dos sugerencias no pueden compartir **top y bottom a la vez**. Si no hay suficientes combinaciones distintas, devuelve las que haya (sin duplicados).
- `reasons`: hasta **3** frases, de las reglas con mayor contribución (peso × score) que hayan devuelto razón. Nunca vacía: si ninguna regla dio razón, usa "Combinación equilibrada".
- **Mismo clóset + mismo `now` + misma `seed` ⇒ mismo resultado exacto.**

Exporta lo público desde `outfit_engine.dart`. Anchor (prenda ancla) y reroll **no** se implementan aquí, pero diseña la firma para poder agregarlos como parámetros opcionales sin romper llamadas existentes.

## Tests (en `packages/outfit_engine/test/`, separa en varios archivos)
- Cada regla con casos buenos y malos.
- Colores de la Parte A.
- Generador:
  - Clóset vacío o incompleto → lista vacía y `missingFor` correcto.
  - Clóset mínimo (1 top, 1 bottom, 1 shoes) → exactamente 1 sugerencia.
  - Diversidad: ninguna pareja de sugerencias comparte top y bottom.
  - Rotación: con dos tops equivalentes, el usado ayer no aparece en la primera sugerencia.
  - Color: un outfit con 2 accents queda por debajo de uno con 1 accent.
  - Protagonista: sudadera con estampado + jeans lisos + tenis lisos queda por encima de sudadera con estampado + pantalón a cuadros.
  - Estilo: cambiar de `casual` a `smart_casual` cambia el orden cuando hay prendas formales y casuales.
  - Outerwear: solo aparece si sube el score.
  - Determinismo: misma entrada y semilla ⇒ resultados idénticos; otra semilla puede cambiar el orden entre empates.
  - Prendas virtuales ignoradas.
  - Rendimiento: un clóset de 40 tops × 30 bottoms × 10 shoes × 5 capas responde en < 500 ms (test con `Stopwatch`, tolerante).
- Un helper de test para construir prendas rápido (`garment(id, category, formality: ..., color: ...)`).

## Criterios de aceptación
- [ ] `cd packages/outfit_engine && dart test` pasa con todos los casos de arriba.
- [ ] El paquete sigue siendo Dart puro (solo `dart:` estándar sin `dart:io`, y archivos propios).
- [ ] `lib/` de la app no cambió (salvo que algo deje de compilar por los cambios de API; en ese caso, el ajuste mínimo y explicado).
- [ ] Todos los checks de `AGENTS.md` pasan.

## Fuera de alcance
UI, pantalla Hoy, "Me lo puse hoy", reroll, prenda ancla, gap analysis, clima.
