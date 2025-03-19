 import 'package:coinflow/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _spinnerController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _spinnerFadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    //Controladores de animación
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _spinnerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    //Animaciones pop
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _textScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.elasticOut,
    ));
    
    //Animacion de spinner
    _spinnerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _spinnerController,
      curve: Curves.easeIn,
    ));

    _iniciarAnimaciones(); // Secuencia de animaciones
    _iniciarAplicacion();   // Navegar después de completar animaciones
  }
  
  void _iniciarAnimaciones() async { // Iniciar animaciones en secuencia
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 600));
    _spinnerController.forward();
  }

  Future<void> _iniciarAplicacion() async {
    //Tiempo para que se vean las animaciones
    await Future.delayed(const Duration(seconds: 3));
    if (mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _spinnerController.dispose();
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
            //Logo con animación pop
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: Image.asset(
                'assets/logo.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 30),
            
            //Texto con animación pop
            ScaleTransition(
              scale: _textScaleAnimation,
              child:Text(
                'Conversor de Monedas',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Indicador de carga 
            FadeTransition(
              opacity: _spinnerFadeAnimation,
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