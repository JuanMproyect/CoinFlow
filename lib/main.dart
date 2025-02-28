import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'Screens/favorites.dart';
import 'Screens/history.dart';
import 'Screens/settings.dart';

void main() {
  runApp(const CoinFlowApp());
}

class CoinFlowApp extends StatelessWidget {
  const CoinFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoinFlow',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Azul más profundo como color base
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF0EA5E9), // Azul celeste vibrante
          tertiary: const Color(0xFF38BDF8), // Azul claro
          background: const Color(0xFFF8FAFC), // Fondo ligeramente azulado
          surface: Colors.white,
          error: const Color(0xFFE11D48), // Rojo intenso para errores
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: const Color(0xFF1E293B), // Azul oscuro casi negro
          onSurface: const Color(0xFF1E293B), // Consistencia en textos
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 4, // Mayor elevación
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          shadowColor: Colors.black38, // Color de sombra más oscuro
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 4, // Sombra más pronunciada
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shadowColor: Colors.black54, // Sombra más oscura para botones
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF0078FF), width: 2),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color.fromARGB(255, 158, 158, 158),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}