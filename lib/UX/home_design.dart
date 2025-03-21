import 'package:flutter/material.dart';

/// Widget para el banner informativo de la aplicación
/// Muestra un contenedor con gradiente y una breve descripción del conversor
class ConversionBanner extends StatelessWidget {
  const ConversionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      //Decoración con gradiente para efecto visual atractivo
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Título del banner
          const Text(
            "Convierte tu dinero al instante 💱",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Elige la moneda que deseas convertir y obtén el cambio al instante",
            style: TextStyle(
              fontSize: 16, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey[300] 
                  : Colors.grey[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          //Chips de ejemplo con monedas populares
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CurrencyChip(flagEmoji: '🇺🇸', currencyCode: 'USD'),
              //Icono de intercambio entre monedas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.primary, size: 28),
              ),
              const CurrencyChip(flagEmoji: '🇪🇺', currencyCode: 'EUR'),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar un chip de moneda con bandera y código
/// Utilizado en el banner para mostrar ejemplos de monedas
class CurrencyChip extends StatelessWidget {
  final String flagEmoji; //Emoji de bandera del país
  final String currencyCode; //Código de la moneda (USD, EUR, etc.)

  const CurrencyChip({super.key, required this.flagEmoji, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? Theme.of(context).colorScheme.surface 
          : Colors.white,
      shadowColor: Colors.black26,
      elevation: 2,
      //Muestra la bandera del país 
      avatar: Text(flagEmoji, style: const TextStyle(fontSize: 18)),
      // Muestra el código de la moneda
      label: Text(
        currencyCode,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white 
              : Colors.black, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}