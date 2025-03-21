import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinflow/UX/home_design.dart';
import '../Services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CurrencyService _currencyService = CurrencyService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // Instancia de Firestore

  double cantidad = 0.0;
  String? monedaOrigen;
  String? monedaDestino;
  double resultado = 0.0;
  bool _isLoading = false;
  bool _isLoadingCurrencies = false;
  List<String> _monedas = [];

  @override
  void initState() {
    super.initState();
    loadCurrencies();
  }

  // Método para cargar las monedas disponibles
  Future<void> loadCurrencies() async {
    setState(() {
      _isLoadingCurrencies = true;
    });
    try {
      final monedasDisponibles = await _currencyService.getAvailableCurrencies('USD');
      setState(() {
        _monedas = monedasDisponibles;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar monedas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingCurrencies = false;
      });
    }
  }

  // Método para guardar la conversión en Firestore
  Future<void> _guardarConversion() async {
    try {
      // Guardar la conversión en la colección 'conversiones'
      await _firestore.collection('conversiones').add({
        'cantidad': cantidad,
        'monedaOrigen': monedaOrigen,
        'monedaDestino': monedaDestino,
        'resultado': resultado,
        'fecha': DateTime.now(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar la conversión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Método para realizar la conversión
  Future<void> convertirMoneda() async {
    if (cantidad <= 0 || monedaOrigen == null || monedaDestino == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final resultadoConversion = await _currencyService.convertCurrency(
        cantidad,
        monedaOrigen!,
        monedaDestino!,
      );
      setState(() {
        resultado = resultadoConversion;
      });
      await _guardarConversion(); // Llamada para guardar la conversión en Firestore
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: [
                // Banner informativo
                ConversionBanner(),
                SizedBox(height: 24),

                // Tarjeta de conversión
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Campo de cantidad (TextField estilizado)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),  // Bordes más suaves
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.15),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Cantidad',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              border: InputBorder.none,  // Eliminamos el borde predeterminado
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                cantidad = double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Selectores de moneda (DropdownButton estilizado)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),  // Bordes más suaves
                                  color: Theme.of(context).colorScheme.surface.withOpacity(0.15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'De',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: monedaOrigen,
                                      hint: const Text('Selecciona una moneda'),
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,  // Eliminamos el borde predeterminado
                                      ),
                                      items: _monedas.map((moneda) {
                                        return DropdownMenuItem(
                                          value: moneda,
                                          child: Text('$moneda'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          monedaOrigen = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  final temp = monedaOrigen;
                                  monedaOrigen = monedaDestino;
                                  monedaDestino = temp;
                                });
                              },
                              icon: const Icon(Icons.swap_horiz, size: 32),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),  // Bordes más suaves
                                  color: Theme.of(context).colorScheme.surface.withOpacity(0.15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'A',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: monedaDestino,
                                      hint: const Text('Selecciona una moneda'),
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,  // Eliminamos el borde predeterminado
                                      ),
                                      items: _monedas.map((moneda) {
                                        return DropdownMenuItem(
                                          value: moneda,
                                          child: Text('$moneda'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          monedaDestino = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Botón de conversión
                        ElevatedButton(
                          onPressed: (monedaOrigen == null || monedaDestino == null || _isLoading)
                              ? null
                              : convertirMoneda,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Convertir'),
                        ),
                        const SizedBox(height: 16),

                        // Resultado de la conversión
                        if (resultado > 0)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
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
                                Text(
                                  '$resultado $monedaDestino',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
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
      ),
    );
  }
}