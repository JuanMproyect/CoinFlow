import 'package:flutter/material.dart';

// Gestor del tema de la aplicación
class ThemeManager extends ChangeNotifier {
  ThemeMode _modoTema = ThemeMode.light;
  ThemeMode get themeMode => _modoTema;
  bool get isDarkMode => _modoTema == ThemeMode.dark;

  // Temas preconstruidos
  ThemeData get lightTheme => _buildLightTheme();
  ThemeData get darkTheme => _buildDarkTheme();

  // Método para alternar entre tema claro y oscuro
  void toggleTheme() {
    _modoTema = _modoTema == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notifica a los widgets que escuchan este cambio
  }

  //Tema claro original
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

  //Tema oscuro
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
        backgroundColor: Color.fromARGB(57, 30, 64, 175), //azul más oscuro
        foregroundColor: Colors.white,
        elevation:4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        shadowColor: Colors.black54,
      ),
      // ElevatedButtonTheme: Estilo para botones en modo oscuro
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
        //borde de error
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
