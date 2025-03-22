import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coinflow/UX/theme_manager.dart';

/// Pantalla de configuración de la aplicación
/// Permite al usuario ajustar preferencias como el tema, idioma y notificaciones
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el proveedor del tema para gestionar el modo claro/oscuro
    final proveedorTema = Provider.of<ThemeManager>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de configuración de apariencia
          Card(
            margin: const EdgeInsets.only(bottom:16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la sección
                  const Text('Apariencia',
                   style: TextStyle(
                   fontSize: 18,
                   fontWeight:FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height:16),
                  // Interruptor para alternar entre modo claro y oscuro
                  SwitchListTile(
                    title: const Text('Modo oscuro'),
                    subtitle: Text(
                      proveedorTema.isDarkMode ? 'Activado':'Desactivado'
                    ),
                    value: proveedorTema.isDarkMode,
                    onChanged: (_) {
                      proveedorTema.toggleTheme();
                    },
                    secondary: Icon(
                      proveedorTema.isDarkMode 
                          ? Icons.dark_mode: Icons.light_mode,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Tarjeta de configuración de idioma
          Card(
            margin: const EdgeInsets.only(bottom:16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la sección
                  const Text('Idioma',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 16),
                  // Opción de idioma español (actualmente la única disponible)
                  ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Español'),
                  subtitle: const Text('Idioma predeterminado'),
                  trailing: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  ),
                  // Nota informativa sobre futuros idiomas
                  Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Text(
                    'Más idiomas estarán disponibles próximamente',
                    style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
          
          // Configuración de notificaciones
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
                value: true, // Valor fijo de ejemplo
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  // Funcionalidad para implementar en el futuro
                },
              ),
            ),
          ),
          
          // Acerca de los desarrolladores
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
                // Muestra un diálogo con información sobre los desarrolladores
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
          
          // Información de versión de la aplicación
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