import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, size: 28),
            SizedBox(width: 8),
            Text('Configuración'),
          ],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.color_lens,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Tema'),
              subtitle: const Text('Claro'),
              trailing: Switch(
                value: false,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {},
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Notificaciones'),
              subtitle: const Text('Activadas'),
              trailing: Switch(
                value: true,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {},
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Idioma'),
              subtitle: const Text('Español'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {},
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Sobre Nosotros'),
              trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sobre Nosotros'),
                  content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CoinFlow es un proyecto universitario desarrollado por:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('• Dariana Hernandez'),
                    Text('• Juan Morel'),
                    Text('• Abraham Escobar'),
                    SizedBox(height: 12),
                    Text('Centro Universitario Tecnologico (CEUTEC)',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                  ),
                  actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                  ],
                );
                },
              );
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Version Beta 1.0.0',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}