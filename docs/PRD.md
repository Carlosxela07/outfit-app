# PRD — Outfit App

## 1. Qué es
Una app Android de estilismo personal que arma outfits **usando solo la ropa y el calzado que el usuario ya tiene**. Combina reglas de proporción, color, formalidad y rotación de prendas, y explica por qué cada outfit funciona.

**Diferencial:** no te obliga a comprar nada para vestirte hoy. La operación diaria (usar lo que ya existe) está separada de la exploración de compras (qué prenda te falta).

## 2. Para quién
Primer usuario: Carlos (dueño del proyecto). Después: cualquier persona con un clóset normal que pierde tiempo decidiendo qué ponerse o siempre repite lo mismo.

## 3. Principios del MVP
1. **Cargar una prenda toma menos de 10 segundos.** Foto + 3 toques. Si catalogar es tedioso, la app muere.
2. **100% local.** Todo vive en el teléfono (SQLite). Sin cuentas ni servidor.
3. **Motor determinista y explicable.** Sin IA en el MVP. Cada regla que aplica genera una frase de explicación.
4. **El uso diario nunca mezcla ropa que no tienes** (`closet_only = true`).

## 4. Alcance del MVP

### A. Clóset digital
- Agregar prenda: foto (cámara o galería) → **tipo**, **formalidad**, **color principal** (preseleccionado automáticamente desde la foto, editable). Todo lo demás opcional con defaults.
- Atributos de prenda:
  - `category`: top, bottom, outerwear (capa), shoes, accessory
  - `subtype`: ej. camiseta, camisa, pantalón, short, sudadera, tenis, botas...
  - `formality`: 1 (muy casual) a 5 (formal)
  - `primaryColor` + `colorFamily` (neutral / warm / cool / accent)
  - `fit` (opcional): ajustado / regular / holgado
  - `warmth` (opcional): ligero / medio / abrigado
  - `lastWornAt`, `timesWorn`
- Grid del clóset con filtro por categoría. Editar y borrar prendas.

### B. Pantalla diaria
- **3 sugerencias** de outfit (top + bottom + shoes, y outerwear/accesorio opcional) con 1–3 frases de por qué funcionan.
- **"Me lo puse hoy"**: marca el outfit como usado (actualiza `lastWornAt` y `timesWorn`). Sin esto no hay rotación.
- **Reroll reutilizando el pool:** si no convencen, se generan 3 nuevas que reutilizan mayormente prendas del bloque anterior (cambiando capas, calzado o combinaciones), con un cambio perceptible.
- **Cambio de estilo** en la misma vista: selector de 4–5 estilos predefinidos que recalcula al instante.
- **Prenda ancla:** elegir una prenda obligatoria y armar outfits alrededor de ella.

### C. Estilos predefinidos (cada uno = un set de pesos del motor)
Casual, Smart casual, Streetwear, Minimalista. (Se pueden agregar más después sin tocar el motor.)

### D. Pestaña "Qué me falta" (gap analysis)
- Simula prendas virtuales comunes (ej. "camisa blanca oxford", "tenis blancos", "jeans oscuros"), corre el motor y cuenta cuántos outfits buenos **nuevos** desbloquea cada una.
- Muestra el top de prendas sugeridas para comprar. Nunca aparecen en la pantalla diaria.

### E. Perfil mínimo
- Preferencia de fit general (opcional) y estilo por defecto.

## 5. Fuera del MVP (Fase 2+)
- Perfil físico completo (estatura, peso, complexión) y descubrimiento de estilos personalizado.
- Clima (Open-Meteo) → candidato a v1.1.
- Tendencias (TikTok/Pinterest) y modo tendencias vs atemporal.
- Auto-etiquetado de atributos con visión / IA; quitar fondo a las fotos.
- Aprender de outfits aceptados/rechazados.
- Backend, cuentas, sincronización entre dispositivos.
- Enlaces a tiendas o catálogos externos.

## 6. Casos límite que el MVP debe manejar
- **Cold start:** si no hay al menos 1 top, 1 bottom y 1 par de zapatos, la pantalla diaria muestra qué falta cargar en vez de outfits.
- **Clóset pequeño:** si no alcanzan 3 outfits distintos, se muestran los que haya, sin duplicados.
- **Respaldo:** exportar/importar el clóset (base de datos + fotos) en un archivo `.zip`. Si pierdes el cel no pierdes el clóset.

## 7. Cómo sabemos que el MVP funciona
- Carlos carga su clóset real (20+ prendas) sin frustrarse.
- Durante 2 semanas usa la app al menos 4 días por semana para decidir qué ponerse.
- Los outfits no se repiten de forma notoria (la rotación se siente).

## 8. Hitos
| # | Hito | Resultado |
|---|---|---|
| 1 | Base del proyecto | Estructura, navegación, checks pasando |
| 2 | Motor: modelos | Paquete Dart puro con modelos y tests |
| 3 | Persistencia | Base local Drift + repositorio de prendas |
| 4 | Clóset | Agregar prenda en <10 s, grid, editar, borrar |
| 5 | Motor v1 | Scoring + 3 outfits explicados, con tests |
| 6 | Pantalla diaria | 3 outfits + "me lo puse" + rotación |
| 7 | Reroll + estilos | Reroll con pool, selector de estilo |
| 8 | Prenda ancla | Outfits alrededor de una prenda fija |
| 9 | Qué me falta | Gap analysis por simulación |
| 10 | Respaldo | Export/import `.zip` |
