import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Services/api_service.dart';
import '../Services/currency_data.dart';

// Modelo para representar una moneda
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
  String _sortOption = 'favorites'; 
  bool _isLoading = false;
  
  final List<String> _monedasMostrar = CurrencyData.monedasMostrar;
  final Map<String, String> _nombreMonedas = CurrencyData.nombreMonedas;
  final bool _filtrarMonedas = true;
  
  List<Currency> _currencies = [];
  Set<String> _favoriteCurrencies = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _loadCurrencies();
    _loadFavoriteCurrencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final CurrencyService _currencyService = CurrencyService();
      final monedasDisponibles = await _currencyService.getAvailableCurrencies('USD');
      
      List<String> currencyCodes = [];
      if (_filtrarMonedas) {
        currencyCodes = monedasDisponibles
            .where((moneda) => _monedasMostrar.contains(moneda))
            .toList();
        
        currencyCodes = CurrencyData.ordenarMonedas(currencyCodes);
      } else {
        currencyCodes = monedasDisponibles;
      }
      
      List<Currency> currencies = currencyCodes.map((code) {
        return Currency(
          symbol: code,
          name: _nombreMonedas[code] ?? code,
          isFavorite: _favoriteCurrencies.contains(code),
        );
      }).toList();
      
      setState(() {
        _currencies = currencies;
      });
    } catch (e) {
      print('Error al cargar las monedas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar monedas: $e'), backgroundColor: Colors.red)
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteCurrencies() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userId = 'user123';

      DocumentSnapshot snapshot = await firestore.collection('favorites').doc(userId).get();

      if (snapshot.exists) {
        List<dynamic> favoriteCurrencies = snapshot['favorite_currencies'];
        setState(() {
          _favoriteCurrencies = Set<String>.from(favoriteCurrencies);
          
          for (var currency in _currencies) {
            currency.isFavorite = _favoriteCurrencies.contains(currency.symbol);
          }
        });
      }
    } catch (e) {
      print('Error al cargar las monedas favoritas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar favoritas: $e'), backgroundColor: Colors.red)
      );
    }
  }

  Future<void> _saveFavoriteCurrencies() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userId = 'user123';

      await firestore.collection('favorites').doc(userId).set({
        'favorite_currencies': List.from(_favoriteCurrencies),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando favoritas: $e'), backgroundColor: Colors.red)
      );
    }
  }

  List<Currency> get _favoriteCurrenciesList {
    return _currencies.where((currency) => currency.isFavorite).toList();
  }

  List<Currency> _sortCurrencies(List<Currency> currencies) {
    switch (_sortOption) {
      case 'favorites':
        currencies.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return a.name.compareTo(b.name);
        });
        break;
      case 'name':
        currencies.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'symbol':
        currencies.sort((a, b) => a.symbol.compareTo(b.symbol));
        break;
    }
    return currencies;
  }

  List<Currency> get _filteredCurrencies {
    if (_filterQuery.isEmpty) {
      return _sortCurrencies(_currencies);
    }
    
    return _sortCurrencies(_currencies.where((currency) {
      return currency.name.toLowerCase().contains(_filterQuery.toLowerCase()) ||
             currency.symbol.toLowerCase().contains(_filterQuery.toLowerCase());
    }).toList());
  }

  // Añadir o eliminar de favoritos (mediante la estrella)
  Future<void> _toggleFavorite(Currency currency) async {
    setState(() {
      currency.isFavorite = !currency.isFavorite;
      if (currency.isFavorite) {
        _favoriteCurrencies.add(currency.symbol);
      } else {
        _favoriteCurrencies.remove(currency.symbol);
      }
    });

    await _saveFavoriteCurrencies();
    
    setState(() {
      _currencies = _sortCurrencies(_currencies);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          currency.isFavorite 
            ? 'Añadido a favoritos' : 'Eliminado de favoritos'
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Eliminar de favoritos (presionado largo)
  Future<void> _removeFromFavorite(Currency currency) async {
    if (currency.isFavorite) {
      setState(() {
        currency.isFavorite = false;
        _favoriteCurrencies.remove(currency.symbol);
      });

      await _saveFavoriteCurrencies();
      
      setState(() {
        _currencies = _sortCurrencies(_currencies);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eliminado de favoritos'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Método para mostrar detalles de la moneda (solo para la sección de favoritos)
  void _showCurrencyDetails(Currency currency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(currency.name),
        content: Text('Símbolo: ${currency.symbol}\nDetalles adicionales se mostrarían aquí.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
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
              onRefresh: () async {
                await _loadCurrencies();
                await _loadFavoriteCurrencies();
              },
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
  
  Widget _buildFavoritesSection() {
    final favoriteCurrencies = _favoriteCurrenciesList;
    
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
          favoriteCurrencies.isEmpty
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
                    itemCount: favoriteCurrencies.length,
                    itemBuilder: (context, index) {
                      return _buildFavoriteCurrencyCard(favoriteCurrencies[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }
  
  Widget _buildFavoriteCurrencyCard(Currency currency) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCurrencyDetails(currency),
        onLongPress: () => _removeFromFavorite(currency),
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
                    currency.symbol.substring(0, 1),
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
              const SizedBox(height: 4),
              Text(
                'Mantén para quitar',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildCurrencyListItem(Currency currency) {
    final bool isFavorite = currency.isFavorite;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: isFavorite ? Colors.blue.withOpacity(0.05) : null,
      child: ListTile(
        // Se eliminó el onTap para que no muestre información al hacer tap
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isFavorite 
              ? Theme.of(context).primaryColor.withOpacity(0.2) 
              : Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              currency.symbol.substring(0, 1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFavorite 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).primaryColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
        title: Text(
          currency.name,
          style: TextStyle(
            fontWeight: isFavorite ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        subtitle: Text(currency.symbol),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isFavorite)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Favorito',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.touch_app,
                      size: 12,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _toggleFavorite(currency),
            ),
          ],
        )
      ),
    );
  }

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
              _buildSortOption('Favoritos primero', 'favorites', Icons.star),
              _buildSortOption('Nombre', 'name', Icons.sort_by_alpha),
            ],
          ),
        );
      },
    );
  }

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
          _currencies = _sortCurrencies(_currencies);
        });
        Navigator.pop(context);
      },
    );
  }
}