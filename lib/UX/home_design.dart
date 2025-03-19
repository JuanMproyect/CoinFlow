import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

// ===== WIDGETS DE FUNCIONALIDAD =====
/// Widget principal para la tarjeta de conversión de monedas
//Lógica y UI para la selección de monedas y conversión
class ConversionCard extends StatefulWidget {
  const ConversionCard({super.key});

  @override
  State<ConversionCard> createState() => _ConversionCardState();
}

class _ConversionCardState extends State<ConversionCard> with SingleTickerProviderStateMixin {
  // Lista de monedas disponibles para la conversión
  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'Dólar estadounidense', 'flag': '🇺🇸'},
    {'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
    {'code': 'GBP', 'name': 'Libra esterlina', 'flag': '🇬🇧'},
    {'code': 'CAD', 'name': 'Dólar canadiense', 'flag': '🇨🇦'},
    {'code': 'AUD', 'name': 'Dólar australiano', 'flag': '🇦🇺'},
    {'code': 'HNL', 'name': 'Lempira hondureño', 'flag': '🇭🇳'},
    {'code': 'MXN', 'name': 'Peso mexicano', 'flag': '🇲🇽'},
  ];
  
  //Estado inicial de las monedas seleccionadas
  Map<String, String> fromCurrency = {'code': 'USD', 'name': 'Dólar estadounidense', 'flag': '🇺🇸'};
  Map<String, String> toCurrency = {'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'};
  final TextEditingController amountController = TextEditingController(); // Control para la cantidad a convertir
  late AnimationController _animationController; //Control para la animación de intercambio

  @override
  void initState() {
    super.initState();
    //Inicializa el controlador de animación para el botón de intercambio
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    //Libera recursos al destruir el widget
    amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  //Intercambia las monedas de origen y destino con animación
  void swapCurrencies() {
    setState(() {
      final temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
    //Anima el botón de intercambio
    _animationController.forward(from: 0);
  }

  ///Muestra un diálogo cuando se intenta convertir sin cantidad
  /// o realiza la conversión si hay una cantidad válida
  void convertCurrency() {
    if (amountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              const Text('Atención'),
            ],
          ),
          content: const Text('Por favor, ingresa una cantidad'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Entendido', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //campo de entrada de cantidad a convertir
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Cantidad',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
                suffixText: fromCurrency['code'], // Muestra el código de la moneda seleccionada
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    amountController.clear();
                    HapticFeedback.lightImpact();
                  },
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
              ),
              keyboardType: TextInputType.number, //Teclado numérico
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], //Solo permite números
            ),
            
            const SizedBox(height: 20),
            
            //Selector de monedas con botón de intercambio
            _buildCurrencySelector(),
            
            const SizedBox(height: 24),
            
            // Botón de conversión
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: convertCurrency,
                icon: const Icon(Icons.currency_exchange),
                label: const Text(
                  'Convertir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            //Área de resultado de la conversión
            _buildResultContainer(),
          ],
        ),
      ),
    );
  }

  //Crea el selector de monedas con botón de intercambio
  Widget _buildCurrencySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.2) 
              : Colors.grey[300]!
        ),
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
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
            //Selector de moneda de origen
            Expanded(
              child: _buildCurrencyOption('De', fromCurrency, true),
            ),
            
            //Botón de intercambio animado
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: RotationTransition(
                // Animación de rotación elástica
                turns: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: IconButton(
                  onPressed: swapCurrencies,
                  icon: const Icon(Icons.swap_horiz),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            // Selector de moneda de destino
            Expanded(
              child: _buildCurrencyOption('A', toCurrency, false),
            ),
          ],
        ),
      ),
    );
  }

  /// Crea una opción de moneda seleccionable
  /// label Etiqueta para la opción (De/A)
  ///currency Datos de la moneda seleccionada
  ///isFrom Si es la moneda de origen (true) o destino (false)
  Widget _buildCurrencyOption(String label, Map<String, String> currency, bool isFrom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Etiqueta (De/A)
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        //Área presionable para seleccionar moneda
        InkWell(
          onTap: () => _showCurrencySelector(isFrom),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Bandera de la moneda
                Text(currency['flag']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                //Código de la moneda
                Text(
                  currency['code']!,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                // Indicador de desplegable
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Crea el contenedor para mostrar el resultado de la conversión
  Widget _buildResultContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      // Decoración para destacar el resultado
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          //Etiqueta de resultado
          const Text(
            'Resultado:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          //Resultado de la conversión (pendiente de implementar)****
          Text(
            'Función Incompleta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          //Timestamp de la última actualización
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded, 
                size: 14, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[400] 
                    : Colors.grey[600]
              ),
              const SizedBox(width: 4),
              Text(
                'Actualizado: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: TextStyle(
                  fontSize: 12, 
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[400] 
                      : Colors.grey[600]
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Muestra el modal para seleccionar una moneda
  ///  isFromCurrency Si es true, se selecciona la moneda de origen, si es false, la de destino
  void _showCurrencySelector(bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, //Permite que el modal se expanda
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _CurrencySelectorModal(
          currencies: _currencies,
          selectedCurrency: isFromCurrency ? fromCurrency : toCurrency,
          onSelect: (currency) {
            setState(() {
              if (isFromCurrency) {
                fromCurrency = currency;
              } else {
                toCurrency = currency;
              }
            });
            Navigator.pop(context);
          },
          title: isFromCurrency ? 'Seleccionar moneda de origen' : 'Seleccionar moneda de destino',
        );
      },
    );
  }
}

/// Modal para seleccionar una moneda con buscador y lista filtrable
class _CurrencySelectorModal extends StatefulWidget {
  final List<Map<String, String>> currencies; //Lista completa de monedas
  final Map<String, String> selectedCurrency; // Moneda actualmente seleccionada
  final Function(Map<String, String>) onSelect; //Función callback al seleccionar
  final String title; // Título del modal

  const _CurrencySelectorModal({
    required this.currencies,
    required this.selectedCurrency,
    required this.onSelect,
    required this.title,
  });

  @override
  State<_CurrencySelectorModal> createState() => _CurrencySelectorModalState();
}

class _CurrencySelectorModalState extends State<_CurrencySelectorModal> {
  late TextEditingController searchController; //Controlador para el campo de búsqueda
  late List<Map<String, String>> filteredCurrencies; // Lista filtrada de monedas

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de búsqueda y la lista filtrada
    searchController = TextEditingController();
    filteredCurrencies = List.from(widget.currencies);
    //Configura un listener para actualizar la lista cuando cambia el texto
    searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    // Libera recursos al destruir el widget
    searchController.dispose();
    super.dispose();
  }

  ///Filtra las monedas según el texto introducido en el buscador
  void _filterCurrencies() {
    final query = searchController.text.toLowerCase();
    setState(() {
      // Si el query está vacío, muestra todas las monedas
      // Si no, filtra por código o nombre que contenga el query
      filteredCurrencies = query.isEmpty
          ? List.from(widget.currencies)
          : widget.currencies
              .where((currency) =>
                  currency['code']!.toLowerCase().contains(query) ||
                  currency['name']!.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      //Altura fija para el modal (60% de la pantalla)
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          //Campo de búsqueda de monedas
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Buscar moneda',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark 
                  ? Theme.of(context).colorScheme.surfaceVariant 
                  : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Text('Todas las monedas', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          
          // Lista filtrable de monedas
          Expanded(
            child: ListView.builder(
              itemCount: filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = filteredCurrencies[index];
                final isSelected = widget.selectedCurrency['code'] == currency['code'];
                
                //Aplica animación para destacar la moneda seleccionada
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Text(currency['flag']!, style: const TextStyle(fontSize: 24)),
                    title: Text(
                      currency['code']!, 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(currency['name']!),
                    //Muestra un check si la moneda está seleccionada
                    trailing: isSelected 
                        ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        : Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7) 
                                : Colors.grey[600],
                          ),
                    onTap: () => widget.onSelect(currency),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}