
class CurrencyData {
  // Lista de monedas a mostrar / mas comunes
  static final List<String> monedasMostrar = [
    'USD', 'EUR', 'HNL', 'GTQ', 'CRC', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 
    'MXN', 'BRL', 'ARS', 'COP', 'PEN', 'CLP', 'UYU', 'ZAR', 'BOB', 'VES', 'DOP', 
    'PAB', 'NIO', 'PYG', 'BZD', 'JMD', 'TTD', 'BBD', 'BSD', 'KYD', 'ANG', 'XCD',
    'INR', 'RUB', 'KRW', 'SGD', 'HKD', 'NZD', 'SEK', 'NOK', 'DKK', 'PLN', 'TRY', 
    'ILS',
  ];

  // Mapa que relaciona siglas de monedas con sus nombres completos
  static final Map<String, String> nombreMonedas = {
    'USD': 'Dólar estadounidense',
    'EUR': 'Euro',
    'GBP': 'Libra esterlina',
    'JPY': 'Yen japonés',
    'CAD': 'Dólar canadiense',
    'AUD': 'Dólar australiano',
    'CHF': 'Franco suizo',
    'CNY': 'Yuan chino',
    'MXN': 'Peso mexicano',
    'BRL': 'Real brasileño',
    'ARS': 'Peso argentino',
    'COP': 'Peso colombiano',
    'PEN': 'Sol peruano',
    'CLP': 'Peso chileno',
    'UYU': 'Peso uruguayo',
    'BOB': 'Boliviano',
    'VES': 'Bolívar venezolano',
    'DOP': 'Peso dominicano',
    'PAB': 'Balboa panameño',
    'NIO': 'Córdoba nicaragüense',
    'PYG': 'Guaraní paraguayo',
    'BZD': 'Dólar beliceño',
    'JMD': 'Dólar jamaicano',
    'TTD': 'Dólar de Trinidad y Tobago',
    'BBD': 'Dólar de Barbados',
    'BSD': 'Dólar de las Bahamas',
    'KYD': 'Dólar de las Islas Caimán',
    'ANG': 'Florín de las Antillas Neerlandesas',
    'XCD': 'Dólar del Caribe Oriental',
    'INR': 'Rupia india',
    'RUB': 'Rublo ruso',
    'KRW': 'Won surcoreano',
    'SGD': 'Dólar de Singapur',
    'HKD': 'Dólar de Hong Kong',
    'NZD': 'Dólar neozelandés',
    'SEK': 'Corona sueca',
    'NOK': 'Corona noruega',
    'DKK': 'Corona danesa',
    'PLN': 'Złoty polaco',
    'TRY': 'Lira turca',
    'ZAR': 'Rand sudafricano',
    'ILS': 'Nuevo séquel israelí',
    'HNL': 'Lempira Hondureño',
    'GTQ': 'Quetzal Guatemalteco',
    'CRC': 'Colón Costarricense'
  };

  //Función para ordenar monedas
  static List<String> ordenarMonedas(List<String> monedas) {
    monedas.sort((a, b) {
      if (a == 'USD') return -1;
      if (b == 'USD') return 1;
      if (a == 'EUR') return -1;
      if (b == 'EUR') return 1;
      if (a == 'HNL') return -1;
      if (b == 'HNL') return 1;
      return a.compareTo(b);
    });
    return monedas;
  }
}