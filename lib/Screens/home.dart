import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinflow/UX/home_design.dart';
import '../Services/api_service.dart';
import '../Services/currency_data.dart';

/// Pantalla principal para la conversión de monedas
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Servicios para API y base de datos
  final CurrencyService _servicioDivisas = CurrencyService();
  final FirebaseFirestore _baseDatos = FirebaseFirestore.instance;

  // Estados de la conversión
  double cantidad = 0.0;
  String? monedaOrigen;
  String? monedaDestino;
  double resultado = 0.0;
  bool _cargando = false;
  bool _cargandoDivisas = false;
  List<String> _divisas = []; // Lista completa de divisas
  List<String> _divisasFiltradas = []; // Lista de divisas filtrada por búsqueda
  String _busqueda = '';
  
  // Uso de las listas predefinidas de CurrencyData
  final List<String> _divisasMostrar = CurrencyData.monedasMostrar;
  final Map<String, String> _nombreDivisas = CurrencyData.nombreMonedas;
  final bool _filtrarDivisas = true;

  @override
  void initState() {
    super.initState();
    cargarDivisas(); // Cargar divisas al iniciar
  }

  /// Carga las divisas disponibles desde la API
  Future<void> cargarDivisas() async {
    setState(() => _cargandoDivisas = true);
    
    try {
      // Obtener las divisas disponibles desde el servicio
      final divisasDisponibles = await _servicioDivisas.getAvailableCurrencies('USD');
      
      setState(() {
        if (_filtrarDivisas) {
          // Filtrar solo las divisas que están en la lista predefinida
          _divisas = divisasDisponibles
              .where((divisa) => _divisasMostrar.contains(divisa))
              .toList();
          
          // Ordenar según el orden predefinido
          _divisas = CurrencyData.ordenarMonedas(_divisas);
        } else {
          _divisas = divisasDisponibles;
        }
        // Inicializar la lista filtrada con todas las divisas
        _divisasFiltradas = List.from(_divisas);
      });
    } catch (e) {
      _mostrarError('Error al cargar monedas: $e');
    } finally {
      setState(() => _cargandoDivisas = false);
    }
  }

  /// Filtra divisas según el texto de búsqueda
  void _filtrarPorBusqueda(String consulta) {
    setState(() {
      _busqueda = consulta;
      if (consulta.isEmpty) {
        // Si no hay texto de búsqueda, mostrar todas las divisas
        _divisasFiltradas = List.from(_divisas);
      } else {
        // Filtrar por código o nombre de divisa
        _divisasFiltradas = _divisas.where((divisa) {
          final nombreCompleto = _nombreDivisas[divisa] ?? '';
          return divisa.toLowerCase().contains(consulta.toLowerCase()) ||
                 nombreCompleto.toLowerCase().contains(consulta.toLowerCase());
        }).toList();
      }
    });
  }

  /// Muestra un mensaje de error al usuario
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red)
    );
  }

  /// Guarda la conversión realizada en Firestore
  Future<void> _guardarConversion() async {
    try {
      await _baseDatos.collection('conversiones').add({
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

  /// Realiza la conversión de moneda utilizando el servicio API
  Future<void> convertirMoneda() async {
    if (cantidad <= 0 || monedaOrigen == null || monedaDestino == null) {
      _mostrarError('Por favor, completa todos los campos.');
      return;
    }

    setState(() => _cargando = true);

    try {
      // Llamar al servicio para realizar la conversión
      final resultadoConversion = await _servicioDivisas.convertCurrency(
        cantidad, monedaOrigen!, monedaDestino!,
      );
      setState(() => resultado = resultadoConversion);
      // Guardar la conversión en la base de datos
      await _guardarConversion();
    } catch (e) {
      _mostrarError('Error: $e');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Utiliza el widget de diseño de la UI
    return ConversorMonedaScreen(
      monedas: _divisasFiltradas,
      isLoadingCurrencies: _cargandoDivisas,
      isLoading: _cargando,
      monedaOrigen: monedaOrigen,
      monedaDestino: monedaDestino,
      resultado: resultado,
      nombreMonedas: _nombreDivisas,
      textoBusqueda: _busqueda,
      // Callbacks para actualizar el estado
      actualizarCantidad: (valor) => setState(() => cantidad = double.tryParse(valor) ?? 0.0),
      actualizarMonedaOrigen: (valor) => setState(() => monedaOrigen = valor),
      actualizarMonedaDestino: (valor) => setState(() => monedaDestino = valor),
      actualizarBusqueda: _filtrarPorBusqueda,
      intercambiarMonedas: () => setState(() {
        // Intercambiar las monedas de origen y destino
        final temp = monedaOrigen;
        monedaOrigen = monedaDestino;
        monedaDestino = temp;
      }),
      convertirMoneda: convertirMoneda,
      monedaOriginal: _divisas,
    );
  }
}