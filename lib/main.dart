import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'Screens/favorites.dart';
import 'Screens/history.dart';
import 'Screens/settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GestorTema(),
      child:const CoinFlowApp(),
    ),
  );
}
//Proveedor que maneja el estado del tema
class GestorTema extends ChangeNotifier {
  ThemeMode _modoTema = ThemeMode.light;
  ThemeMode get themeMode => _modoTema;
  bool get isDarkMode => _modoTema == ThemeMode.dark;

  void toggleTheme() {
    _modoTema=_modoTema == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class CoinFlowApp extends StatelessWidget {
  const CoinFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GestorTema>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoinFlow',
      themeMode: themeProvider.themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: const NavigationScreen(),
    );
  }

  //Tema claro original
  ThemeData _buildLightTheme() {
    return ThemeData(
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        //borde cuando el texto está habilitado
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        //borde cuando el texto está enfocado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        //borde cuando hay error en la entrada
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        floatingLabelStyle: const TextStyle(color: Color(0xFF3B82F6)),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF2563EB),
        unselectedItemColor: Color.fromARGB(255, 158, 158, 158),
      ),
    );
  }

  //Tema oscuro
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        primary: const Color(0xFF3B82F6),
        secondary: const Color(0xFF38BDF8),
        tertiary: const Color(0xFF7DD3FC),
        background: const Color(0xFF0F172A), 
        surface: const Color(0xFF1E293B), 
        error: const Color(0xFFF87171), 
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E40AF), //azul más oscuro
        foregroundColor: Colors.white,
        elevation:4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        shadowColor: Colors.black54,
      ),
      elevatedButtonTheme:ElevatedButtonThemeData(
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
      //diseño de los TextFields
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
        //borde de error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.5),
        ),
        floatingLabelStyle: const TextStyle(color: Color(0xFF60A5FA)),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0F172A),
        selectedItemColor: Color(0xFF60A5FA),
        unselectedItemColor: Color(0xFF94A3B8),
      ),
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