# AGENTS.md — Reglas para el agente de código

Lees este archivo antes de cualquier tarea. Si una instrucción de un ticket contradice este archivo, **detente y pregunta**; no adivines.

## Contexto
- App: **Outfit App**, estilista personal que arma outfits solo con la ropa que el usuario ya tiene.
- Plataforma: **Android** (Flutter). Sin iOS, web ni escritorio por ahora.
- Datos: **100% locales** en el teléfono. Sin backend, sin cuentas, sin red (salvo que un ticket lo pida).
- Documentos fuente: `docs/PRD.md` (qué y por qué), `docs/ARCHITECTURE.md` (cómo), `docs/DECISIONS.md` (decisiones tomadas). Léelos cuando el ticket los mencione.

## Roles
- **Claude (PM/arquitecto)** escribe los tickets en `tasks/` y revisa tu código.
- **Tú (agente de código)** implementas **un ticket a la vez**.
- **Carlos (dueño)** aprueba y hace merge.

## Flujo por ticket
1. Lee el ticket completo (`tasks/NNN-*.md`) y los docs que mencione.
2. Crea una rama: `feat/NNN-nombre-corto` (ej. `feat/001-base-proyecto`).
3. Implementa **solo** lo que pide el ticket. Lo que está en "Fuera de alcance" no se toca.
4. Corre los checks obligatorios (abajo). Todos deben pasar.
5. Commit con mensaje convencional: `feat(wardrobe): ...`, `fix(engine): ...`, `chore: ...`, `test: ...`.
6. `git push -u origin <rama>`.
7. Al final, responde con un resumen: qué hiciste, archivos tocados, decisiones que tomaste y cualquier duda.

## Checks obligatorios antes de cada commit
```bash
dart format .
flutter analyze
flutter test
cd packages/outfit_engine && dart test && cd ../..
```
(El último aplica desde que exista el paquete, ticket 002.)
Si algo falla y no puedes arreglarlo dentro del alcance del ticket, **no hagas push**: explica el problema.

## Reglas de código
- Idioma: identificadores, nombres de archivos y comentarios técnicos en **inglés**. Textos visibles al usuario en **español**.
- Sigue la estructura de carpetas de `docs/ARCHITECTURE.md`. No inventes carpetas nuevas sin justificarlo en tu resumen.
- **No agregues dependencias** que no estén en `docs/ARCHITECTURE.md` o en el ticket. Si crees que hace falta una, propónla en el resumen en vez de instalarla.
- Instala paquetes con `flutter pub add <paquete>` (o `dart pub add` dentro de `packages/outfit_engine`) para tomar versiones compatibles.
- `packages/outfit_engine` es **Dart puro**: prohibido importar `package:flutter`, Drift, `dart:io` o cualquier cosa de UI/BD. Su lógica debe ser determinista y testeable.
- Sin código muerto, sin `print` (usa `debugPrint` solo si hace falta temporalmente y quítalo antes del commit).
- Widgets pequeños: si un archivo de UI pasa ~250 líneas, divídelo.
- Nada de secretos, llaves ni datos personales en el repo.

## Lo que NO debes hacer
- No modifiques archivos fuera del alcance del ticket (incluido este AGENTS.md y `docs/`), salvo que el ticket lo pida.
- No cambies versiones de Flutter/Dart/Gradle/NDK ni la configuración de `android/` salvo que el ticket lo pida.
- No hagas merge a `main` ni push a `main`.
- No borres ni reescribas tests existentes para que "pasen".
