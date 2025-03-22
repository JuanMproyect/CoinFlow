import 'package:coinflow/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Pantalla de carga inicial con animaciones
/// Se muestra mientras la aplicación inicializa componentes necesarios
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  // Controladores para las animaciones
  late AnimationController _controladorLogo;
  late AnimationController _controladorTexto;
  late AnimationController _controladorSpinner;
  
  // Animaciones de escala y opacidad
  late Animation<double> _animacionEscalaLogo;
  late Animation<double> _animacionEscalaTexto;
  late Animation<double> _animacionOpacidadSpinner;
  
  @override
  void initState() {
    super.initState();
    
    // Inicialización de controladores de animación
    _controladorLogo = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _controladorTexto = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _controladorSpinner = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Configuración de animaciones de escala con efecto elástico
    _animacionEscalaLogo = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controladorLogo,
      curve: Curves.elasticOut, // Efecto rebote al final
    ));
    
    _animacionEscalaTexto = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controladorTexto,
      curve: Curves.elasticOut,
    ));
    
    // Configuración de animación de opacidad para el spinner
    _animacionOpacidadSpinner = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controladorSpinner,
      curve: Curves.easeIn, // Aparición gradual
    ));

    _iniciarAnimaciones(); // Secuencia de animaciones
    _iniciarAplicacion();   // Navegar después de completar animaciones
  }
  
  /// Inicia la secuencia de animaciones con retrasos programados
  void _iniciarAnimaciones() async { 
    await Future.delayed(const Duration(milliseconds: 200));
    _controladorLogo.forward(); // Comienza la animación del logo
    
    await Future.delayed(const Duration(milliseconds: 400));
    _controladorTexto.forward(); // Comienza la animación del texto
    
    await Future.delayed(const Duration(milliseconds: 600));
    _controladorSpinner.forward(); // Comienza la animación del spinner
  }

  /// Navega a la pantalla principal después de un tiempo de espera
  Future<void> _iniciarAplicacion() async {
    // Tiempo para que se vean las animaciones completas
    await Future.delayed(const Duration(seconds: 3));
    if (mounted){ // Verifica que el widget aún esté montado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationScreen()),
      );
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores
    _controladorLogo.dispose();
    _controladorTexto.dispose();
    _controladorSpinner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo con animación de escala
            ScaleTransition(
              scale: _animacionEscalaLogo,
              child: Image.asset(
                'assets/logo.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 30),
            
            // Texto con animación de escala
            ScaleTransition(
              scale: _animacionEscalaTexto,
              child: Text(
                'Conversor de Monedas',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Indicador de carga con animación de opacidad
            FadeTransition(
              opacity: _animacionOpacidadSpinner,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}