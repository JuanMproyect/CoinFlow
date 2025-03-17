import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'Screens/favorites.dart';
import 'Screens/history.dart';
import 'Screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // ChangeNotifierProvider: Permite gestionar el estado del tema en toda la app
    ChangeNotifierProvider(
      create: (context) => GestorTema(),
      child: const CoinFlowApp(),
    ),
  );
}

// Proveedor que maneja el estado del tema
class GestorTema extends ChangeNotifier {
  ThemeMode _modoTema = ThemeMode.light;
  ThemeMode get themeMode => _modoTema;
  bool get isDarkMode => _modoTema == ThemeMode.dark;

  // Método para alternar entre tema claro y oscuro
  void toggleTheme() {
    _modoTema = _modoTema == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notifica a los widgets que escuchan este cambio
  }
}

class CoinFlowApp extends StatelessWidget {
  const CoinFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene el proveedor del tema para acceder al modo actual
    final themeProvider = Provider.of<GestorTema>(context);

    // MaterialApp: Widget raíz que configura la aplicación
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      title: 'CoinFlow',
      themeMode: themeProvider.themeMode, // Usa el modo de tema actual (claro/oscuro)
      theme: _buildLightTheme(), // Definición del tema claro
      darkTheme: _buildDarkTheme(), // Definición del tema oscuro
      home: const NavigationScreen(), // Pantalla inicial con navegación
    );
  }

  // Tema claro original
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      // ColorScheme: Define los colores principales del tema claro
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
      // AppBarTheme: Estilo para la barra superior de la aplicación
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        shadowColor: Colors.black38,
      ),
      // ElevatedButtonTheme: Estilo para los botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 4,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shadowColor: Colors.black54,
        ),
      ),
      // InputDecorationTheme: Estilo para los campos de entrada de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        // borde cuando el texto está habilitado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        // borde cuando el texto está enfocado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        // borde cuando hay error en la entrada
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        floatingLabelStyle: const TextStyle(color: Color(0xFF3B82F6)),
      ),
      // CardTheme: Estilo para las tarjetas
      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      // BottomNavigationBarTheme: Estilo para la barra de navegación inferior
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF2563EB),
        unselectedItemColor: Color.fromARGB(255, 158, 158, 158),
      ),
    );
  }

  // Tema oscuro
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      // ColorScheme: Define los colores principales del tema oscuro
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        primary: const Color(0xFF3B82F6),
        secondary: const Color(0xFF38BDF8),
        tertiary: const Color(0xFF7DD3FC),
        background: const Color(0xFF0F172A), // Fondo oscuro
        surface: const Color(0xFF1E293B), // Superficie oscura
        error: const Color(0xFFF87171),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        brightness: Brightness.dark,
      ),
      // AppBarTheme: Estilo para la barra superior oscura
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(57, 30, 64, 175), // azul más oscuro
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        shadowColor: Colors.black54,
      ),
      // ElevatedButtonTheme: Estilo para botones en modo oscuro
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 4,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shadowColor: Colors.black87,
        ),
      ),
      // InputDecorationTheme: Estilo para campos de entrada en modo oscuro
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.5),
        ),
        floatingLabelStyle: const TextStyle(color: Color(0xFF60A5FA)),
      ),
      // CardTheme: Estilo para tarjetas en modo oscuro
      cardTheme: CardTheme(
        elevation: 3,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      // BottomNavigationBarTheme: Estilo para la barra inferior en modo oscuro
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0F172A),
        selectedItemColor: Color(0xFF60A5FA),
        unselectedItemColor: Color(0xFF94A3B8),
      ),
    );
  }
}

// Navegación principal con la barra de navegación inferior
class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas a navegar
  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice actual de la barra
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
            _selectedIndex = index; // Cambia la pantalla cuando se toca
          });
        },
      ),
    );
  }
}