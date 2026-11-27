# 002 — Paquete `outfit_engine`: modelos de dominio

**Rama:** `feat/002-motor-modelos`
**Depende de:** 001 mergeado
**Lee antes:** `AGENTS.md`, `docs/ARCHITECTURE.md` (Regla de oro, Modelo de datos)

## Contexto
El corazón de la app es un motor de outfits en **Dart puro**. En este ticket solo creamos el paquete y sus modelos; el algoritmo llega en el 005.

## Qué hacer
1. Crea el paquete con `dart create -t package packages/outfit_engine` y limpia el ejemplo generado.
2. Agrégalo como dependencia local de la app (`path: packages/outfit_engine`).
3. En `packages/outfit_engine/lib/src/models/` implementa (inmutables, `const` constructors donde se pueda, `copyWith`, `==`/`hashCode`):
   - Enums: `GarmentCategory`, `ColorFamily`, `Fit`, `Warmth` (ver `ARCHITECTURE.md`).
   - `Garment` con los campos de `ARCHITECTURE.md`. Valida en el constructor (assert) que `formality` esté entre 1 y 5.
   - `StyleProfile` y una lista `const` con los 4 estilos predefinidos: `casual` (formalidad 1–2), `smart_casual` (2–4), `streetwear` (1–3), `minimal` (2–4). `ruleWeights` puede quedar con valores iniciales razonables; se afinan en el 005.
   - `OutfitSuggestion` con `garments` (getter que devuelve la lista no nula de prendas), `score` y `reasons`.
4. Helper puro `ColorFamily classifyColor(int argb)`: clasifica un color en neutral/warm/cool/accent usando HSV (neutral = saturación baja o luminosidad muy baja/alta; warm = tonos rojo-amarillo; cool = verde-azul-morado; accent = saturación y brillo altos). Documenta los umbrales en el código.
5. Exporta todo lo público desde `lib/outfit_engine.dart`.
6. Tests en `packages/outfit_engine/test/`:
   - Igualdad y `copyWith` de `Garment`.
   - `classifyColor`: negro, blanco, gris, beige → neutral; rojo/naranja → warm o accent según saturación; azul marino → cool; verde neón → accent.
   - Los 4 estilos existen y sus rangos son válidos.

## Criterios de aceptación
- [ ] `cd packages/outfit_engine && dart test` pasa.
- [ ] El paquete **no** importa `package:flutter`, `dart:io`, Drift ni nada de UI (verificable con búsqueda en `packages/outfit_engine/lib`).
- [ ] La app compila usando el paquete (aunque todavía no lo use en pantallas).
- [ ] Todos los checks de `AGENTS.md` pasan.

## Fuera de alcance
Reglas de scoring, generación de outfits, base de datos, UI.
