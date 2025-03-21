import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Función para borrar todos los registros de la colección 'conversiones'
  Future<void> _borrarHistorial(BuildContext context) async {
    try {
      // Confirmar con el usuario antes de eliminar
      final confirm = await showDialog<bool>(
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

      if (confirm == true) {
        // Obtener todos los documentos de la colección 'conversiones'
        final collection = FirebaseFirestore.instance.collection('conversiones');
        final snapshot = await collection.get();

        // Eliminar cada documento
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historial eliminado correctamente')),
        );
      }
    } catch (e) {
      // Si ocurre un error al eliminar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar historial: $e')),
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
          // Botón para eliminar historial
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _borrarHistorial(context),  // Llamar a la función de borrado
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('conversiones')
            .orderBy('fecha', descending: true) // Ordenar por la fecha de forma ascendente
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

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

          // Mostrar las conversiones
          final conversiones = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversiones.length,
            itemBuilder: (context, index) {
              var conversion = conversiones[index];
              var cantidad = conversion['cantidad'];
              var monedaOrigen = conversion['monedaOrigen'];
              var monedaDestino = conversion['monedaDestino'];
              var resultado = conversion['resultado'];
              var fecha = (conversion['fecha'] as Timestamp).toDate();

              // Formato de la fecha
              String formattedDate = "${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute}";

              return Card(
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
                    'Fecha: $formattedDate',
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
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}