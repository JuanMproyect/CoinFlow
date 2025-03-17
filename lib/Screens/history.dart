import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Implementar función para borrar historial si es necesario
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('conversiones').get(),
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

              return ListTile(
                title: Text(
                  '$cantidad $monedaOrigen = $resultado $monedaDestino',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Fecha: ${fecha.toString()}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Aquí puedes agregar una acción al hacer clic, si lo deseas
                },
              );
            },
          );
        },
      ),
    );
  }
}