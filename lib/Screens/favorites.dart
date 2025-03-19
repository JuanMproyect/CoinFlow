import 'package:flutter/material.dart';

//Modelo para representar una moneda
class Currency {
  final String symbol;
  final String name;
  bool isFavorite;

  Currency({
    required this.symbol,
    required this.name,
    this.isFavorite = false,
  });
}
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _filterQuery = '';
  String _sortOption = 'name'; 
  bool _isLoading = false;
  
  //Lista de monedas integradas con API
  List<Currency> _currencies = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    //cargar los datos desde la API
    _loadCurrencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //método para cargar monedas desde API
  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Reemplazar con llamada API 
      // final response = await apiService.getCurrencies();
      // final List<Currency> currencies = response.map((data) => Currency.fromJson(data)).toList();
      
      //Datos de ejemplo
      await Future.delayed(const Duration(milliseconds: 500));
      final List<Currency> mockCurrencies = [
        Currency(symbol: 'L', name: 'Lempira Hondureño', isFavorite: true),
        Currency(symbol: 'USD', name: 'Dólar Estadounidense', isFavorite: false),
        Currency(symbol: 'EUR', name: 'Euro', isFavorite: false),
        Currency(symbol: 'GBP', name: 'Libra Esterlina', isFavorite: false),
        Currency(symbol: 'GTQ', name: 'Quetzal Guatemalteco', isFavorite: false),
        Currency(symbol: 'MXN', name: 'Peso Mexicano', isFavorite: true),
      ];
      setState(() {
        _currencies = mockCurrencies;
      });
    } catch (e) {
      //Manejo de errores
      debugPrint('Error cargando monedas: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
 }

  //Obtener monedas favoritas
  List<Currency> get _favoriteCurrencies {
    return _currencies.where((currency) => currency.isFavorite).toList();
  }

  //Ordenar favoritos según criterio
  List<Currency> _sortCurrencies(List<Currency> currencies) {
    switch (_sortOption) {
      case 'name':
        currencies.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    return currencies;
  }

  //Filtrar monedas por búsqueda
  List<Currency> get _filteredCurrencies {
    if (_filterQuery.isEmpty) {
      return _sortCurrencies(_currencies);
    }
    
    return _sortCurrencies(_currencies.where((currency) {
      return currency.name.toLowerCase().contains(_filterQuery.toLowerCase()) ||
             currency.symbol.toLowerCase().contains(_filterQuery.toLowerCase());
    }).toList());
  }

  // Cambiar estado de favorito
  Future<void> _toggleFavorite(Currency currency) async {
    //Integrar con API

    setState(() {
      currency.isFavorite = !currency.isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          currency.isFavorite 
            ? 'Añadido a favoritos' : 'Eliminado de favoritos'
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCurrencies,
              child: Column(
                children: [
                  _buildFavoritesSection(),
                  Divider(thickness: 1, height: 1, color: Colors.grey[300]),
                  _buildSearchBar(),
                  Expanded(
                    child: _buildCurrenciesList(),
                  ),
                ],
              ),
            ),
    );
  }
  
  // Sección de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Todas las monedas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _filterQuery = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Sección de monedas favoritas
  Widget _buildFavoritesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis favoritos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          _favoriteCurrencies.isEmpty
              ? Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: Text(
                    'No tienes monedas favoritas',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600]
                    ),
                  ),
                )
              : SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _favoriteCurrencies.length,
                    itemBuilder: (context, index) {
                      return _buildFavoriteCurrencyCard(_favoriteCurrencies[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }
  
  //tarjeta para moneda favorita (sección superior)
  Widget _buildFavoriteCurrencyCard(Currency currency) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    currency.symbol,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                currency.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Lista principal de todas las monedas
  Widget _buildCurrenciesList() {
    final filteredCurrencies = _filteredCurrencies;
  
    return filteredCurrencies.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 60,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[500]
                      : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron monedas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: filteredCurrencies.length,
            itemBuilder: (context, index) {
              return _buildCurrencyListItem(filteredCurrencies[index]);
            },
          );
  }

  //Item de lista para cada moneda
  Widget _buildCurrencyListItem(Currency currency) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              currency.symbol,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        title: Text(
          currency.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(currency.symbol),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                currency.isFavorite ? Icons.star : Icons.star_border,
                color: currency.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _toggleFavorite(currency),
            ),
          ],
        )
      ),
    );
  }

  //instrucciones para opciones de ordenamiento
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ordenar por',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSortOption('Nombre', 'name', Icons.sort_by_alpha),
            ],
          ),
        );
      },
    );
  }

  //Opción individual de ordenamiento
  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _sortOption == value;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: isSelected ? Icon(
        Icons.check,
        color: Theme.of(context).primaryColor,
      ) : null,
      onTap: () {
        setState(() {
          _sortOption = value;
        });
        Navigator.pop(context);
      },
    );
  }
}