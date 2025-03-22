import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Pantalla que muestra el historial de conversiones realizadas
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  /// Borra todos los registros del historial de conversiones
  Future<void> _borrarHistorial(BuildContext context) async {
    try {
      // Solicitar confirmación al usuario antes de eliminar
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text('¿Estás seguro de que deseas borrar todo el historial?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );

      if (confirmar == true) {
        // Obtener todos los documentos de la colección 'conversiones'
        final coleccion = FirebaseFirestore.instance.collection('conversiones');
        final snapshot = await coleccion.get();

        // Eliminar cada documento
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historial eliminado correctamente')),
        );
      }
    } catch (e) {
      // Manejar errores durante la eliminación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar historial: $e')),
      );
    }
  }

  /// Borra una conversión individual del historial
  Future<void> _borrarConversion(BuildContext context, String idDocumento) async {
    try {
      // Obtener referencia al documento y eliminarlo
      await FirebaseFirestore.instance.collection('conversiones').doc(idDocumento).delete();
      
      // Mostrar confirmación al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversión eliminada'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Manejar errores durante la eliminación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 28),
            SizedBox(width: 8),
            Text('Historial'),
          ],
        ),
        actions: [
          // Botón para eliminar todo el historial
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _borrarHistorial(context),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('conversiones')
            .orderBy('fecha', descending: true) // Ordenar por fecha, más recientes primero
            .get(),
        builder: (context, snapshot) {
          // Mostrar indicador de carga mientras se obtienen los datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostrar mensaje si no hay conversiones
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Historial vacío',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tus conversiones aparecerán aquí\npara un fácil acceso',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          // Mostrar la lista de conversiones
          final conversiones = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversiones.length,
            itemBuilder: (context, index) {
              var conversion = conversiones[index];
              var idDocumento = conversion.id;
              var cantidad = conversion['cantidad'];
              var monedaOrigen = conversion['monedaOrigen'];
              var monedaDestino = conversion['monedaDestino'];
              var resultado = conversion['resultado'];
              var fecha = (conversion['fecha'] as Timestamp).toDate();

              // Formatear la fecha para mostrarla
              String fechaFormateada = "${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute}";

              // Widget Dismissible para permitir eliminar deslizando
              return Dismissible(
                key: Key(idDocumento),
                // Fondo mostrado al deslizar desde la izquierda
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Eliminar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Fondo mostrado al deslizar desde la derecha
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Eliminar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                // Pedir confirmación antes de eliminar
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmar'),
                        content: const Text('¿Estás seguro de eliminar esta conversión?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                // Acción al confirmar eliminación
                onDismissed: (direction) {
                  _borrarConversion(context, idDocumento);
                },
                // Contenido del elemento del historial
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      '$cantidad $monedaOrigen = $resultado $monedaDestino',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Fecha: $fechaFormateada',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    onTap: () {
                      // Acción al tocar un elemento (por implementar)
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}