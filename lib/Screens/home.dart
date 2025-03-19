import 'package:flutter/material.dart';
import 'package:coinflow/UX/home_design.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Barra superior con el logo de la aplicación
      appBar: AppBar(
        title: Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/logo.png',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      
      //Body: Contenido principal de la pantalla
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.background.withOpacity(0.8)
                  : Colors.white,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                //Banner informativo del Inicio
                ConversionBanner(),
                SizedBox(height: 24),
                
                //Tarjeta de conversión
                ConversionCard(),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}