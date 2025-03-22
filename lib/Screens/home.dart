import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinflow/UX/home_design.dart';
import '../Services/api_service.dart';
import '../Services/currency_data.dart'; // Importamos la nueva clase

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CurrencyService _currencyService = CurrencyService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Estados de la conversión
  double cantidad = 0.0;
  String? monedaOrigen;
  String? monedaDestino;
  double resultado = 0.0;
  bool _isLoading = false;
  bool _isLoadingCurrencies = false;
  List<String> _monedas = [];
  List<String> _monedasFiltradas = [];
  String _busqueda = '';
  
  //usar las listas de currency data
  final List<String> _monedasMostrar = CurrencyData.monedasMostrar;
  final Map<String, String> _nombreMonedas = CurrencyData.nombreMonedas;
  final bool _filtrarMonedas = true;

  @override
  void initState() {
    super.initState();
    loadCurrencies();
  }

  //Método para cargar las monedas disponibles
  Future<void> loadCurrencies() async {
    setState(() => _isLoadingCurrencies = true);
    
    try {
      final monedasDisponibles = await _currencyService.getAvailableCurrencies('USD');
      
      setState(() {
        if (_filtrarMonedas) {
          _monedas = monedasDisponibles
              .where((moneda) => _monedasMostrar.contains(moneda))
              .toList();
          
          //usar la función de ordenamiento de CurrencyData
          _monedas = CurrencyData.ordenarMonedas(_monedas);
        } else {
          _monedas = monedasDisponibles;
        }
        _monedasFiltradas = List.from(_monedas);
      });
    } catch (e) {
      _mostrarError('Error al cargar monedas: $e');
    } finally {
      setState(() => _isLoadingCurrencies = false);
    }
  }

  //Método para filtrar monedas según búsqueda 
  void _filtrarPorBusqueda(String query) {
    setState(() {
      _busqueda = query;
      if (query.isEmpty) {
        _monedasFiltradas = List.from(_monedas);
      } else {
        _monedasFiltradas = _monedas.where((moneda) {
          final nombreCompleto = _nombreMonedas[moneda] ?? '';
          return moneda.toLowerCase().contains(query.toLowerCase()) ||
                 nombreCompleto.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // Método para mostrar errores
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red)
    );
  }

  // Método para guardar la conversión en Firestore
  Future<void> _guardarConversion() async {
    try {
      await _firestore.collection('conversiones').add({
        'cantidad': cantidad,
        'monedaOrigen': monedaOrigen,
        'monedaDestino': monedaDestino,
        'resultado': resultado,
        'fecha': DateTime.now(),
      });
    } catch (e) {
      _mostrarError('Error al guardar la conversión: $e');
    }
  }

  // Método para realizar la conversión
  Future<void> convertirMoneda() async {
    if (cantidad <= 0 || monedaOrigen == null || monedaDestino == null) {
      _mostrarError('Por favor, completa todos los campos.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final resultadoConversion = await _currencyService.convertCurrency(
        cantidad, monedaOrigen!, monedaDestino!,
      );
      setState(() => resultado = resultadoConversion);
      await _guardarConversion();
    } catch (e) {
      _mostrarError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConversorMonedaScreen(
      monedas: _monedasFiltradas,
      isLoadingCurrencies: _isLoadingCurrencies,
      isLoading: _isLoading,
      monedaOrigen: monedaOrigen,
      monedaDestino: monedaDestino,
      resultado: resultado,
      nombreMonedas: _nombreMonedas,
      textoBusqueda: _busqueda,
      // Callbacks para actualizar estado
      actualizarCantidad: (value) => setState(() => cantidad = double.tryParse(value) ?? 0.0),
      actualizarMonedaOrigen: (value) => setState(() => monedaOrigen = value),
      actualizarMonedaDestino: (value) => setState(() => monedaDestino = value),
      actualizarBusqueda: _filtrarPorBusqueda,
      intercambiarMonedas: () => setState(() {
        final temp = monedaOrigen;
        monedaOrigen = monedaDestino;
        monedaDestino = temp;
      }),
      convertirMoneda: convertirMoneda,
      monedaOriginal: _monedas,
    );
  }
}