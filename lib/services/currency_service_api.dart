import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = '6471971caa9171a4ffdd5b5f';  // Reemplaza con tu clave de API
  final String baseUrl = 'https://v6.exchangerate-api.com/v6';  // URL base de la API

  // Función para obtener tasas de cambio
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$baseUrl/$apiKey/latest/$baseCurrency'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener tasas de cambio: ${response.statusCode}');
    }
  }

  // Función para obtener la lista de monedas disponibles
  Future<List<String>> getAvailableCurrencies(String baseCurrency) async {
    try {
      final rates = await getExchangeRates(baseCurrency);
      return rates['conversion_rates'].keys.toList();
    } catch (e) {
      throw Exception('Error al obtener monedas disponibles: $e');
    }
  }

  // Función para realizar una conversión
  Future<double> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    try {
      final rates = await getExchangeRates(fromCurrency);
      final exchangeRate = rates['conversion_rates'][toCurrency];
      if (exchangeRate == null) {
        throw Exception('Tasa de cambio no disponible para $toCurrency');
      }
      return amount * exchangeRate;
    } catch (e) {
      throw Exception('Error al convertir moneda: $e');
    }
  }
}