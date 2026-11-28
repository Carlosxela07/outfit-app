# 006 — Color confiable: ignorar fondo, gotero y prendas multicolor

**Rama:** `feat/006-color-y-estampado`
**Depende de:** 005 mergeado (usa `secondaryColor`, `secondaryColorFamily` y `GarmentPattern` del motor)
**Lee antes:** `AGENTS.md`, `docs/ARCHITECTURE.md` (Fotos, Base de datos)

## Contexto (bug real de la prueba en dispositivo)
`dominantColor` cuenta el color más frecuente de **toda** la foto. Fotografiando sobre una colcha azul con dibujos, unos tenis beige salieron como "gris azulado / Frío": ganó el fondo. Solo acierta cuando la prenda ocupa casi toda la imagen.

## Parte A — Detección de color sin fondo
Reescribe `lib/core/storage/dominant_color.dart` (sigue corriendo en isolate con `compute`):
1. Reduce la imagen a ~64 px de lado (como hoy) y cuantiza en buckets (como hoy).
2. **Estimar el fondo:** toma los píxeles del **marco exterior** (≈ 12% de cada borde). Los buckets que en el marco sumen ≥ 15% de sus píxeles se consideran fondo, junto con sus vecinos cercanos (distancia RGB pequeña, documenta el umbral).
3. **Peso central:** cada píxel pesa según su cercanía al centro (gaussiana o lineal; centro = 1.0, esquinas ≈ 0.2).
4. Descarta buckets de fondo y elige por **peso total**:
   - `primary` = bucket de mayor peso.
   - `secondary` = siguiente bucket de mayor peso que sea **perceptiblemente distinto** del primario (distancia RGB mínima, documenta) y que pese al menos **20%** del primario. Si no hay, `null`.
5. Si tras quitar el fondo no queda casi nada (< 5% de los píxeles), cae al método actual (sin quitar fondo).
6. Nueva firma: `DetectedColors detectColors(Uint8List bytes)` con `primary` y `secondary?`.

Tests con imágenes sintéticas generadas en el test (paquete `image`):
- Prenda beige centrada (60% del cuadro) sobre fondo azul marino con líneas celestes → primario beige (no azul).
- Prenda amarilla grande sobre fondo azul → amarillo.
- Prenda negra con franja blanca ancha al centro sobre fondo azul → primario negro o blanco y secundario el otro.
- Imagen 100% de un color → ese color, sin secundario.
- Imagen ruidosa/sin fondo claro → no lanza error.

## Parte B — Gotero (tocar la foto para elegir color)
En la pantalla de agregar/editar prenda:
- Tocar la foto abre un modo gotero: el usuario toca un punto y se toma el color promedio de un área pequeña (≈ 9×9 px de la imagen original) en ese punto; muestra un indicador donde tocó.
- Se puede asignar a **color principal** o **secundario** (dos chips o toggle "Principal / Secundario" mientras el gotero está activo).
- Debe respetar el `BoxFit` con el que se muestra la foto (mapear bien la coordenada del toque a la imagen).
- La paleta de 16 colores sigue disponible como alternativa.

## Parte C — Multicolor y estampado en la UI y la BD
1. Migración Drift a **`schemaVersion = 2`**: columnas `secondaryColor` (int, nullable), `secondaryColorFamily` (texto enum, nullable), `pattern` (texto enum, default `solid`). Prendas existentes quedan `solid` sin secundario. Incluye test de migración v1 → v2 (o verificación con base en memoria creada en v1).
2. Repositorio y `GarmentDraft` mapean los campos nuevos.
3. Formulario:
   - Debajo del color principal, **color secundario** (prellenado si la detección encontró uno; botón para quitarlo).
   - **Estampado**: chips Liso · Rayas · Estampado/logo · Print (default Liso). Si se detectó secundario, preselecciona "Estampado/logo"; el usuario corrige.

## Criterios de aceptación
- [ ] En el Motorola, unos tenis beige fotografiados sobre una colcha con dibujos proponen un color beige/café claro (prueba manual de Carlos).
- [ ] Tocar la foto cambia el color principal o secundario al del punto tocado.
- [ ] Prendas guardadas antes de la migración siguen apareciendo y editándose.
- [ ] Tests de las Partes A y C pasan; todos los checks de `AGENTS.md` pasan.

## Fuera de alcance
Modo ráfaga y defaults inteligentes (ticket 007), ML Kit / IA, pantalla Hoy.
