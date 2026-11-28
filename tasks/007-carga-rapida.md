# 007 — Carga rápida: varias fotos seguidas, subtipo que define categoría y valores recordados

**Rama:** `feat/007-carga-rapida`
**Depende de:** 006 mergeado
**Lee antes:** `AGENTS.md`, `docs/PRD.md` (principio 1: cargar una prenda en < 10 s)

## Contexto
En la prueba real, Carlos sintió tardado elegir categoría, subtipo y demás en cada prenda. La detección de color y el gotero ya funcionan bien; ahora hay que quitar toques y permitir cargar el clóset por tandas.

## Parte A — El subtipo define la categoría
- Cuando no hay categoría elegida, muestra **todos los subtipos agrupados por categoría** (encabezado pequeño por grupo: Superior, Inferior, Capas, Calzado, Accesorios).
- Tocar un subtipo **selecciona su categoría automáticamente** (un toque en vez de dos).
- Elegir primero la categoría sigue funcionando como hoy (filtra los subtipos).
- Agrega subtipos que faltan: Inferior → jeans, pantalón, joggers, short, falda; Capas → chaqueta, sobrecamisa, suéter, chaleco, chamarra; Accesorios → gorra, cinturón, reloj, bolso. Revisa los existentes para que no haya duplicados.
- `Guardar` sigue habilitado en cuanto hay categoría.

## Parte B — Recordar los últimos valores
- Al guardar una prenda, guarda en la tabla `Settings` la última **categoría**, **subtipo** y **formalidad** usados.
- La siguiente prenda nueva arranca con esa **formalidad** y con la categoría y subtipo **sugeridos** (preseleccionados). Si la foto es de otra cosa, el usuario cambia con un toque.
- Opción en Ajustes para no recordar (switch "Recordar últimos valores", activo por defecto).

## Parte C — Varias prendas seguidas
En el bottom sheet del botón "+" agrega una tercera opción: **"Varias desde galería"** (usa `pickMultiImage`, máximo 20).
1. Se crea una **cola** con las fotos elegidas. Para cada una se calcula el color en segundo plano (isolate) mientras el usuario revisa la anterior.
2. Se abre el formulario de la primera foto con un indicador "Prenda 1 de N" y los valores recordados (Parte B).
3. Botones: **"Guardar y siguiente"** (principal) y **"Omitir"** (descarta esa foto). En la última: "Guardar y terminar".
4. Al terminar, vuelve al clóset con un SnackBar "N prendas agregadas".
5. Si el usuario sale a mitad de camino, pide confirmación ("¿Descartar las M fotos restantes?"). Las ya guardadas se quedan.

Además, en la opción **Cámara**, después de guardar muestra una acción rápida **"Tomar otra"** (SnackBar con acción o botón) que abre la cámara de nuevo con los valores recordados.

## Tests
- Parte A: tocar un subtipo sin categoría selecciona la categoría correcta.
- Parte B: después de guardar una prenda de Calzado/Tenis/Casual, la siguiente arranca con esos valores; con el switch apagado, no.
- Parte C: flujo con 3 fotos falsas: guardar, omitir, guardar → 2 prendas en la base y SnackBar "2 prendas agregadas". Salir a mitad pide confirmación.

## Criterios de aceptación
- [ ] Con valores recordados y color bien detectado, agregar una prenda del mismo tipo que la anterior toma: foto → **Guardar** (0 toques intermedios).
- [ ] Se pueden cargar 10 fotos de galería en una sola tanda.
- [ ] Prueba manual de Carlos en el Motorola: cargar al menos 8 prendas por tanda sin frustrarse.
- [ ] Todos los checks de `AGENTS.md` pasan.

## Fuera de alcance
IA o ML Kit para reconocer la prenda, pantalla Hoy, cambios al motor.
