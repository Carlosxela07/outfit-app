# DECISIONS — Registro de decisiones

Formato: fecha · decisión · por qué. No se reabren sin una razón nueva.

- 2026-11-27 · **Flutter + Dart, solo Android** · Carlos tiene Android; iOS no es prioridad.
- 2026-11-27 · **MVP 100% local, sin backend ni cuentas** · Validar la idea rápido y gratis; el motor no depende de dónde viven los datos, así que un backend se agrega después sin reescribir.
- 2026-11-27 · **Motor de outfits como paquete Dart puro (`packages/outfit_engine`)** · Testeable en milisegundos y aislado de la UI; Codex no puede romperlo tocando pantallas.
- 2026-11-27 · **Motor determinista basado en reglas, sin IA en el MVP** · Explicable ("por qué funciona") y testeable.
- 2026-11-27 · **Cargar prenda en <10 s (foto + 3 toques)** · El mayor riesgo del producto es el abandono al catalogar.
- 2026-11-27 · **Perfil físico completo, tendencias y clima fuera del MVP** · Complejos o sensibles; clima es candidato a v1.1.
- 2026-11-27 · **Estilos = sets de pesos del motor** · El mismo mecanismo sirve para el selector diario y para agregar estilos nuevos.
- 2026-11-27 · **Gap analysis por simulación de prendas virtuales** · Sale casi gratis con el motor y no requiere catálogos externos.
- 2026-11-27 · **Stack: Riverpod, go_router, Drift** · Estándar actual de Flutter, buena documentación para agentes.
- 2026-11-27 · **Flujo de trabajo: Claude escribe tickets y revisa; Codex implementa en ramas; Carlos hace merge** · Separación clara de roles; el repo es la fuente de verdad.
