import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GestorTema>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom:16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Apariencia',
                   style: TextStyle(
                   fontSize: 18,
                   fontWeight:FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height:16),
                  SwitchListTile(
                    title: const Text('Modo oscuro'),
                    subtitle: Text(
                      themeProvider.isDarkMode ? 'Activado':'Desactivado'
                    ),
                    value: themeProvider.isDarkMode,
                    onChanged: (_) {
                      themeProvider.toggleTheme();
                    },
                    secondary: Icon(
                      themeProvider.isDarkMode 
                          ? Icons.dark_mode: Icons.light_mode,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          //Notificaciones **
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