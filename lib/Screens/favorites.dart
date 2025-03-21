import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Services/api_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _filterQuery = '';
  List<String> _currencies = [];
  Set<String> _favoriteCurrencies = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
    _loadFavoriteCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<String> currencies = await CurrencyService().getAvailableCurrencies('USD');
      setState(() {
        _currencies = currencies;
      });
    } catch (e) {
      print('Error al cargar las monedas: $e');
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
        });
      }
    } catch (e) {
      print('Error al cargar las monedas favoritas: $e');
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
        SnackBar(content: Text('Error guardando favoritas: $e')),
      );
    }
  }

  List<String> get _filteredCurrencies {
    if (_filterQuery.isEmpty) {
      return _currencies;
    }
    return _currencies.where((currency) => currency.toLowerCase().contains(_filterQuery.toLowerCase())).toList();
  }

  void _toggleFavorite(String currency) {
    setState(() {
      if (_favoriteCurrencies.contains(currency)) {
        _favoriteCurrencies.remove(currency);
      } else {
        _favoriteCurrencies.add(currency);
      }
    });

    _saveFavoriteCurrencies();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _filterQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return _favoriteCurrencies.isEmpty
        ? const SizedBox()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Monedas favoritas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _favoriteCurrencies.length,
          itemBuilder: (context, index) {
            String currency = _favoriteCurrencies.elementAt(index);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlue[100],
                child: Text(
                  currency.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                currency,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.star, color: Colors.amber),
                onPressed: () => _toggleFavorite(currency),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCurrenciesList() {
    return ListView.builder(
      itemCount: _filteredCurrencies.length,
      itemBuilder: (context, index) {
        String currency = _filteredCurrencies[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Text(
              currency.substring(0, 1),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            currency,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _favoriteCurrencies.contains(currency) ? Icons.star : Icons.star_border,
              color: _favoriteCurrencies.contains(currency) ? Colors.amber : Colors.grey,
            ),
            onPressed: () => _toggleFavorite(currency),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildFavoritesSection(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Todas las monedas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
          _buildSearchBar(),
          Expanded(child: _buildCurrenciesList()),
        ],
      ),
    );
  }
}