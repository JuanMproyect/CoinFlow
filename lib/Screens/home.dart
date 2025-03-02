import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar: Barra superior con el logo de la aplicación
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
        toolbarHeight: 80, // Altura personalizada para la barra
        centerTitle: true,
      ),
      // Body: Contenido principal de la pantalla usando desplazamiento
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner informativo: Muestra información sobre la conversión
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Título del banner
                    const Text( "Convierte tu dinero al instante 💱",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Descripción del servicio
                    Text( "Elige la moneda que deseas convertir y obtén el cambio al instante",
                      style:TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height:16),
                    // Visualización de ejemplo de conversión
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Chip para moneda origen (USD)
                        Chip(
                          backgroundColor: Colors.white,
                          avatar: const Icon(Icons.attach_money, color: Colors.green),
                          label: const Text(
                            "USD",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        // Icono de intercambio
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.primary, size: 28),
                        ),
                        // Chip para moneda destino (EUR)
                        Chip(
                          backgroundColor: Colors.white,
                          avatar: const Icon(Icons.euro, color: Colors.blue),
                          label: const Text(
                            "EUR",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Tarjeta de conversión: Contiene los campos para realizar la conversión
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Campo de entrada para la cantidad a convertir
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {}, // Limpiar el campo
                          ),
                        ),
                        keyboardType: TextInputType.number, // Teclado numérico
                      ),
                      const SizedBox(height: 20),
                      // Selector de monedas con intercambio
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Selector de moneda origen
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'De',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Menú desplegable para seleccionar moneda origen
                                    DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'USD', child: Text('USD 🇺🇸')),
                                        DropdownMenuItem(value: 'EUR', child: Text('EUR 🇪🇺')),
                                        DropdownMenuItem(value: 'GBP', child: Text('GBP 🇬🇧')),
                                        DropdownMenuItem(value: 'HNL', child: Text('HNL 🇭🇳')),
                                      ],
                                      onChanged: (value) {}, // Actualizar moneda origen
                                    ),
                                  ],
                                ),
                              ),
                              // Botón para intercambiar monedas
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {}, // Intercambiar monedas
                                  icon: const Icon(Icons.swap_horiz),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              // Selector de moneda destino
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'A',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Menú desplegable para seleccionar moneda destino
                                    DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'EUR', child: Text('EUR 🇪🇺')),
                                        DropdownMenuItem(value: 'USD', child: Text('USD 🇺🇸')),
                                        DropdownMenuItem(value: 'GBP', child: Text('GBP 🇬🇧')),
                                        DropdownMenuItem(value: 'HNL', child: Text('HNL 🇭🇳')),
                                      ],
                                      onChanged: (value) {}, // Actualizar moneda destino
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Botón para realizar la conversión
                      ElevatedButton.icon(
                        onPressed: () {}, // Realizar el cálculo de conversión
                        icon: const Icon(Icons.currency_exchange),
                        label: const Text('Convertir'),
                      ),
                      const SizedBox(height: 16),
                      // Contenedor para mostrar el resultado de la conversión
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Resultado:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Valor resultado de la conversión
                            Text(
                              '€ 0.00',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}