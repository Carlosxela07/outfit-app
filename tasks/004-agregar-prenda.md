# 004 — Clóset: agregar prenda en menos de 10 segundos + grid

**Rama:** `feat/004-agregar-prenda`
**Depende de:** 003 mergeado
**Lee antes:** `AGENTS.md`, `docs/PRD.md` (sección 4.A y principio 1), `docs/ARCHITECTURE.md` (Fotos)

## Contexto
Es la pantalla más importante para que la app no se abandone. Meta: **foto + 3 toques + guardar**.

## Qué hacer
1. Dependencias: `image_picker`, `image`.
2. Pestaña **Clóset**:
   - Grid de 3 columnas con las fotos (cuadradas, `BoxFit.cover`), reactivo a `watchAll`.
   - Chips de filtro arriba: Todo · Superior · Inferior · Capas · Calzado · Accesorios.
   - Estado vacío amable con botón para agregar la primera prenda.
   - FAB "+" para agregar.
3. Flujo **agregar prenda**:
   1. FAB → bottom sheet: **Cámara** o **Galería**.
   2. Se toma/elige la foto (`maxWidth: 1080`, `imageQuality: 85`) y se copia a `<documents>/garments/<id>.jpg` (servicio en `lib/core/storage/`).
   3. Pantalla de datos con la foto arriba y:
      - **Categoría** (chips, obligatorio) → al elegir, aparecen chips de **subtipo** sugeridos para esa categoría (opcional, ej. Superior: camiseta, camisa, polo, sudadera, blusa).
      - **Formalidad** (5 chips o slider con etiquetas: Muy casual · Casual · Intermedio · Arreglado · Formal; default 2).
      - **Color**: preseleccionado con el color dominante de la foto (calculado en un isolate con `compute` usando el paquete `image`: reduce la imagen a ~64 px y toma el color más frecuente ignorando casi-blancos del fondo si es posible). Se muestra como círculo + `colorFamily` vía `classifyColor`. Tocar permite elegir de una paleta de ~16 colores básicos.
      - "Más detalles" colapsado: fit y abrigo (opcionales).
   4. **Guardar** habilitado en cuanto hay categoría. Vuelve al grid y muestra la prenda nueva.
4. **Detalle/edición**: tocar una prenda abre la misma pantalla de datos precargada, con opción **Eliminar** (con confirmación) que borra registro y archivo.
5. Permisos de cámara configurados en Android según lo que requiera `image_picker` (documenta en el resumen si tocaste `AndroidManifest.xml`).
6. Tests: widget test del flujo de datos (sin cámara real: inyecta la foto mediante un provider o fake), y test unitario de la función de color dominante con imágenes sintéticas (ej. imagen 100% roja → rojo).

## Criterios de aceptación
- [ ] Desde el grid: FAB → cámara → elegir categoría → Guardar, en **3 toques** después de la foto (formalidad y color tienen defaults).
- [ ] El color sale preseleccionado y es editable.
- [ ] Filtros por categoría funcionan.
- [ ] Editar y eliminar funcionan; eliminar borra también la foto del disco.
- [ ] Probado en dispositivo real (Motorola) con cámara y galería.
- [ ] Todos los checks de `AGENTS.md` pasan.

## Fuera de alcance
Quitar fondo, auto-etiquetado con IA, generación de outfits, pantalla Hoy.
