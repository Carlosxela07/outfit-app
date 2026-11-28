import 'package:material_ui/material_ui.dart';

class GarmentEditorScaffold extends StatelessWidget {
  const GarmentEditorScaffold({
    required this.editing,
    required this.busy,
    required this.onSave,
    required this.body,
    this.position,
    this.total,
    this.onExit,
    this.onSkip,
    super.key,
  });

  final bool editing;
  final bool busy;
  final VoidCallback? onSave;
  final Widget body;
  final int? position;
  final int? total;
  final VoidCallback? onExit;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: !busy && position == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !busy) onExit?.call();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            position == null
                ? (editing ? 'Editar prenda' : 'Agregar prenda')
                : 'Prenda $position de $total',
          ),
          actions: [
            if (position == null)
              TextButton(onPressed: onSave, child: const Text('Guardar')),
          ],
        ),
        bottomNavigationBar: position == null
            ? null
            : SafeArea(
                minimum: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: busy ? null : onSkip,
                      child: const Text('Omitir'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: onSave,
                      child: Text(
                        position == total
                            ? 'Guardar y terminar'
                            : 'Guardar y siguiente',
                      ),
                    ),
                  ],
                ),
              ),
        body: body,
      ),
    );
  }
}

Future<bool?> confirmGarmentDeletion(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('¿Eliminar prenda?'),
    content: const Text('Se eliminará también su foto.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Eliminar'),
      ),
    ],
  ),
);
