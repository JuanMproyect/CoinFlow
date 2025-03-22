import 'package:flutter/material.dart';

// Widget principal de la pantalla de conversión
class ConversorMonedaScreen extends StatelessWidget {
  final List<String> monedas;
  final List<String> monedaOriginal;
  final bool isLoadingCurrencies;
  final bool isLoading;
  final String? monedaOrigen;
  final String? monedaDestino;
  final double resultado;
  final Map<String, String> nombreMonedas;
  final String textoBusqueda;
  final Function(String) actualizarCantidad;
  final Function(String?) actualizarMonedaOrigen;
  final Function(String?) actualizarMonedaDestino;
  final Function(String) actualizarBusqueda;
  final VoidCallback intercambiarMonedas;
  final VoidCallback convertirMoneda;

  const ConversorMonedaScreen({
    Key? key,
    required this.monedas,
    required this.isLoadingCurrencies,
    required this.isLoading,
    required this.monedaOrigen,
    required this.monedaDestino,
    required this.resultado,
    required this.nombreMonedas,
    this.textoBusqueda = '',
    required this.actualizarCantidad,
    required this.actualizarMonedaOrigen,
    required this.actualizarMonedaDestino,
    required this.actualizarBusqueda,
    required this.intercambiarMonedas,
    required this.convertirMoneda,
    required this.monedaOriginal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset('assets/logo.png', height: 150, fit: BoxFit.contain),
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
        child: isLoadingCurrencies 
            ? const Center(child: CircularProgressIndicator())
            : _buildContenidoPrincipal(context),
      ),
    );
  }

  // Construye el contenido principal cuando las monedas están cargadas
  Widget _buildContenidoPrincipal(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ConversionBanner(),
            const SizedBox(height: 24),
            _buildTarjetaConversion(context),
          ],
        ),
      ),
    );
  }

  // Construye la tarjeta de conversión
  Widget _buildTarjetaConversion(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Campo de cantidad
            _buildCampoEntradaCantidad(context),
            const SizedBox(height: 20),
            
            // Selectores de moneda
            _buildSelectorMonedas(context),
            const SizedBox(height: 24),
            
            // Botón de conversión
            _buildBotonConversion(context),
            const SizedBox(height: 16),
            
            // Resultado
            if (resultado > 0) _buildResultadoConversion(context),
          ],
        ),
      ),
    );
  }

  // Campo de entrada de cantidad
  Widget _buildCampoEntradaCantidad(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _buildDecorationCampo(context),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Cantidad',
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
          prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        onChanged: actualizarCantidad,
      ),
    );
  }

  // Selectores de moneda con botón de intercambio
  Widget _buildSelectorMonedas(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectorMoneda(context, 'De', monedaOrigen, actualizarMonedaOrigen),
        ),
        IconButton(
          onPressed: intercambiarMonedas,
          icon: const Icon(Icons.swap_horiz, size: 32),
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: _buildSelectorMoneda(context, 'A', monedaDestino, actualizarMonedaDestino),
        ),
      ],
    );
  }

  // Selector individual de moneda con buscador
  Widget _buildSelectorMoneda(
    BuildContext context,
    String label,
    String? valorSeleccionado,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _buildDecorationCampo(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () => _mostrarSelectorMonedas(context, valorSeleccionado, onChanged),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (valorSeleccionado != null) ...[
                    Expanded(
                      child: _buildItemMoneda(valorSeleccionado),
                    ),
                  ] else
                    const Text('Selecciona'),
                  Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Muestra diálogo de selección de monedas con buscador en tiempo real
  Future<void> _mostrarSelectorMonedas(
    BuildContext context,
    String? valorSeleccionado,
    Function(String?) onChanged,
  ) async {
    final size = MediaQuery.of(context).size;
    
    // Controlador para el campo de búsqueda
    TextEditingController searchController = TextEditingController();
    // Variable local para guardar los resultados filtrados
    List<String> monedasFiltradasLocal = List.from(monedas);
    
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Función local para filtrar monedas en tiempo real
          void filtrarMonedasLocal(String query) {
            actualizarBusqueda(query); // Actualiza el estado principal
            
            // Actualiza el estado local del modal
            setModalState(() {
              if (query.isEmpty) {
                monedasFiltradasLocal = List.from(monedaOriginal);
              } else {
                monedasFiltradasLocal = monedaOriginal.where((moneda) {
                  final nombreCompleto = nombreMonedas[moneda] ?? '';
                  return moneda.toLowerCase().contains(query.toLowerCase()) ||
                         nombreCompleto.toLowerCase().contains(query.toLowerCase());
                }).toList();
              }
            });
          }
          
          return Container(
            height: size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Franja de arrastre
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                
                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Text(
                    'Selecciona una moneda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                
                // Barra de búsqueda 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Buscar moneda...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: searchController.text.isNotEmpty 
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  filtrarMonedasLocal('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: filtrarMonedasLocal,
                    ),
                  ),
                ),
                
                // Lista de monedas
                Expanded(
                  child: monedasFiltradasLocal.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 50,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron resultados para "${searchController.text}"',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: monedasFiltradasLocal.length,
                      itemBuilder: (context, index) {
                        final moneda = monedasFiltradasLocal[index];
                        final isSelected = moneda == valorSeleccionado;
                        
                        return Material(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : null,
                          child: InkWell(
                            onTap: () {
                              onChanged(moneda);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(child: _buildItemMoneda(moneda)),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  // Item de moneda con bandera y nombre
  Widget _buildItemMoneda(String moneda) {
    // Convertir código ISO a emojis de bandera
    String? bandera;
    if (moneda.length == 3) {
      final firstLetter = String.fromCharCode(moneda.codeUnitAt(0) + 127397);
      final secondLetter = String.fromCharCode(moneda.codeUnitAt(1) + 127397);
      bandera = '$firstLetter$secondLetter';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (bandera != null) 
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Text(bandera, style: const TextStyle(fontSize: 20)),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            moneda,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            nombreMonedas[moneda] ?? moneda,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  // Botón de conversión
  Widget _buildBotonConversion(BuildContext context) {
    return ElevatedButton(
      onPressed: (monedaOrigen == null || monedaDestino == null || isLoading)
          ? null
          : convertirMoneda,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Text('Convertir', style: TextStyle(fontSize: 16)),
    );
  }

  // Resultado de la conversión
  Widget _buildResultadoConversion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Resultado:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                '${resultado.toStringAsFixed(2)} $monedaDestino',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (monedaDestino != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                nombreMonedas[monedaDestino!] ?? monedaDestino!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Decoración común para los campos de entrada
  BoxDecoration _buildDecorationCampo(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.15),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

/// Widget para el banner informativo
class ConversionBanner extends StatelessWidget {
  const ConversionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            "Convierte tu dinero al instante 💱",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Elige la moneda que deseas convertir y obtén el cambio al instante",
            style: TextStyle(
              fontSize: 14, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey[300] 
                  : Colors.grey[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CurrencyChip(flagEmoji: '🇺🇸', currencyCode: 'USD'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.primary, size: 24),
              ),
              const CurrencyChip(flagEmoji: '🇪🇺', currencyCode: 'EUR'),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget para chip de moneda
class CurrencyChip extends StatelessWidget {
  final String flagEmoji;
  final String currencyCode;
  const CurrencyChip({super.key, required this.flagEmoji, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? Theme.of(context).colorScheme.surface 
          : Colors.white,
      shadowColor: Colors.black26,
      elevation: 2,
      avatar: Text(flagEmoji, style: const TextStyle(fontSize: 16)),
      label: Text(
        currencyCode,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white 
              : Colors.black, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}