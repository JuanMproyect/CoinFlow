import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Services/api_service.dart';
import '../Services/currency_data.dart';

/// Modelo para representar una moneda
class Moneda {
  final String simbolo;
  final String nombre;
  bool esFavorita;

  Moneda({
    required this.simbolo,
    required this.nombre,
    this.esFavorita = false,
  });
}

/// Pantalla que muestra y gestiona las monedas favoritas del usuario
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controlador;
  String _consulta = ''; // Término de búsqueda
  String _opcionOrdenamiento = 'favoritas'; // Criterio de ordenamiento
  bool _cargando = false;
  
  // Listas predefinidas de monedas a mostrar
  final List<String> _monedasMostrar = CurrencyData.monedasMostrar;
  final Map<String, String> _nombreMonedas = CurrencyData.nombreMonedas;
  final bool _filtrarMonedas = true;
  
  List<Moneda> _monedas = []; // Lista de todas las monedas
  Set<String> _monedasFavoritas = {}; // Conjunto de símbolos de monedas favoritas

  @override
  void initState() {
    super.initState();
    // Inicializar el controlador de animación
    _controlador = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Cargar datos al iniciar
    _cargarMonedas();
    _cargarMonedasFavoritas();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  /// Carga la lista de monedas disponibles desde el servicio API
  Future<void> _cargarMonedas() async {
    setState(() {
      _cargando = true;
    });

    try {
      // Crear instancia del servicio y obtener monedas
      final CurrencyService _servicio = CurrencyService();
      final monedasDisponibles = await _servicio.getAvailableCurrencies('USD');
      
      List<String> codigosMonedas = [];
      if (_filtrarMonedas) {
        // Filtrar monedas según la lista predefinida
        codigosMonedas = monedasDisponibles
            .where((moneda) => _monedasMostrar.contains(moneda))
            .toList();
        
        // Ordenar las monedas según el orden predefinido
        codigosMonedas = CurrencyData.ordenarMonedas(codigosMonedas);
      } else {
        codigosMonedas = monedasDisponibles;
      }
      
      // Crear lista de objetos Moneda
      List<Moneda> monedas = codigosMonedas.map((codigo) {
        return Moneda(
          simbolo: codigo,
          nombre: _nombreMonedas[codigo] ?? codigo,
          esFavorita: _monedasFavoritas.contains(codigo),
        );
      }).toList();
      
      setState(() {
        _monedas = monedas;
      });
    } catch (e) {
      print('Error al cargar las monedas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar monedas: $e'), backgroundColor: Colors.red)
      );
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  /// Carga las monedas favoritas del usuario desde Firestore
  Future<void> _cargarMonedasFavoritas() async {
    try {
      FirebaseFirestore baseDatos = FirebaseFirestore.instance;
      String idUsuario = 'user123'; // ID de usuario hardcodeado (se debería obtener del sistema de autenticación)

      DocumentSnapshot snapshot = await baseDatos.collection('favorites').doc(idUsuario).get();

      if (snapshot.exists) {
        // Extraer la lista de monedas favoritas del documento
        List<dynamic> monedasFavoritasList = snapshot['favorite_currencies'];
        setState(() {
          _monedasFavoritas = Set<String>.from(monedasFavoritasList);
          
          // Actualizar el estado de favorito en cada moneda
          for (var moneda in _monedas) {
            moneda.esFavorita = _monedasFavoritas.contains(moneda.simbolo);
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

  /// Guarda las monedas favoritas del usuario en Firestore
  Future<void> _guardarMonedasFavoritas() async {
    try {
      FirebaseFirestore baseDatos = FirebaseFirestore.instance;
      String idUsuario = 'user123'; // ID de usuario hardcodeado

      await baseDatos.collection('favorites').doc(idUsuario).set({
        'favorite_currencies': List.from(_monedasFavoritas),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando favoritas: $e'), backgroundColor: Colors.red)
      );
    }
  }

  /// Obtiene la lista de monedas favoritas
  List<Moneda> get _listaMonedasFavoritas {
    return _monedas.where((moneda) => moneda.esFavorita).toList();
  }

  /// Ordena la lista de monedas según el criterio seleccionado
  List<Moneda> _ordenarMonedas(List<Moneda> monedas) {
    switch (_opcionOrdenamiento) {
      case 'favoritas':
        // Primero las favoritas, luego por nombre
        monedas.sort((a, b) {
          if (a.esFavorita && !b.esFavorita) return -1;
          if (!a.esFavorita && b.esFavorita) return 1;
          return a.nombre.compareTo(b.nombre);
        });
        break;
      case 'nombre':
        // Ordenar alfabéticamente por nombre
        monedas.sort((a, b) => a.nombre.compareTo(b.nombre));
        break;
      case 'simbolo':
        // Ordenar alfabéticamente por símbolo
        monedas.sort((a, b) => a.simbolo.compareTo(b.simbolo));
        break;
    }
    return monedas;
  }

  /// Filtra las monedas según el texto de búsqueda y aplica ordenamiento
  List<Moneda> get _monedasFiltradas {
    if (_consulta.isEmpty) {
      return _ordenarMonedas(_monedas);
    }
    
    // Filtrar por nombre o símbolo que contenga el texto de búsqueda
    return _ordenarMonedas(_monedas.where((moneda) {
      return moneda.nombre.toLowerCase().contains(_consulta.toLowerCase()) ||
             moneda.simbolo.toLowerCase().contains(_consulta.toLowerCase());
    }).toList());
  }

  /// Cambia el estado de favorito de una moneda
  Future<void> _alternarFavorito(Moneda moneda) async {
    setState(() {
      moneda.esFavorita = !moneda.esFavorita;
      if (moneda.esFavorita) {
        _monedasFavoritas.add(moneda.simbolo);
      } else {
        _monedasFavoritas.remove(moneda.simbolo);
      }
    });

    // Guardar cambios en Firestore
    await _guardarMonedasFavoritas();
    
    // Reordenar la lista de monedas
    setState(() {
      _monedas = _ordenarMonedas(_monedas);
    });
    
    // Mostrar notificación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          moneda.esFavorita 
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

  /// Elimina una moneda de favoritos (mediante pulsación larga)
  Future<void> _quitarDeFavoritos(Moneda moneda) async {
    if (moneda.esFavorita) {
      setState(() {
        moneda.esFavorita = false;
        _monedasFavoritas.remove(moneda.simbolo);
      });

      // Guardar cambios en Firestore
      await _guardarMonedasFavoritas();
      
      // Reordenar la lista de monedas
      setState(() {
        _monedas = _ordenarMonedas(_monedas);
      });
      
      // Mostrar notificación
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

  /// Muestra los detalles de una moneda
  void _mostrarDetallesMoneda(Moneda moneda) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(moneda.nombre),
        content: Text('Símbolo: ${moneda.simbolo}\nDetalles adicionales se mostrarían aquí.'),
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
            onPressed: _mostrarOpcionesOrdenamiento,
          ),
        ],
      ),
      body: _cargando 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // Actualizar datos al hacer pull-to-refresh
                await _cargarMonedas();
                await _cargarMonedasFavoritas();
              },
              child: Column(
                children: [
                  _construirSeccionFavoritos(),
                  Divider(thickness: 1, height: 1, color: Colors.grey[300]),
                  _construirBarraBusqueda(),
                  Expanded(
                    child: _construirListaMonedas(),
                  ),
                ],
              ),
            ),
    );
  }
  
  /// Construye la barra de búsqueda para filtrar monedas
  Widget _construirBarraBusqueda() {
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
              onChanged: (valor) {
                setState(() {
                  _consulta = valor;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construye la sección de monedas favoritas en la parte superior
  Widget _construirSeccionFavoritos() {
    final monedasFavoritas = _listaMonedasFavoritas;
    
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
          monedasFavoritas.isEmpty
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
                    itemCount: monedasFavoritas.length,
                    itemBuilder: (context, index) {
                      return _construirTarjetaMonedaFavorita(monedasFavoritas[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }
  
  /// Construye una tarjeta para cada moneda favorita
  Widget _construirTarjetaMonedaFavorita(Moneda moneda) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _mostrarDetallesMoneda(moneda),
        onLongPress: () => _quitarDeFavoritos(moneda),
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).primaryColor.withOpacity(0.3)
                      : Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    moneda.simbolo.substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                moneda.nombre,
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

  /// Construye la lista de todas las monedas
  Widget _construirListaMonedas() {
    final monedasFiltradas = _monedasFiltradas;
  
    return monedasFiltradas.isEmpty
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
            itemCount: monedasFiltradas.length,
            itemBuilder: (context, index) {
              return _construirElementoListaMonedas(monedasFiltradas[index]);
            },
          );
  }

  /// Construye un elemento de la lista de monedas
  Widget _construirElementoListaMonedas(Moneda moneda) {
    final bool esFavorita = moneda.esFavorita;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: esFavorita ? 
        (Theme.of(context).brightness == Brightness.dark 
          ? Colors.blue.withOpacity(0.15) 
          : Colors.blue.withOpacity(0.05)) 
        : null,
      child: ListTile(
        // Sin onTap para evitar mostrar información al hacer tap
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
              ? (esFavorita 
                ? Theme.of(context).primaryColor.withOpacity(0.4) 
                : Colors.white.withOpacity(0.15))
              : (esFavorita 
                ? Theme.of(context).primaryColor.withOpacity(0.2) 
                : Theme.of(context).primaryColor.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              moneda.simbolo.substring(0, 1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : (esFavorita 
                    ? Theme.of(context).primaryColor 
                    : Theme.of(context).primaryColor.withOpacity(0.8)),
              ),
            ),
          ),
        ),
        title: Text(
          moneda.nombre,
          style: TextStyle(
            fontWeight: esFavorita ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        subtitle: Text(moneda.simbolo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (esFavorita)
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
                esFavorita ? Icons.star : Icons.star_border,
                color: esFavorita ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _alternarFavorito(moneda),
            ),
          ],
        )
      ),
    );
  }

  /// Muestra el modal de opciones de ordenamiento
  void _mostrarOpcionesOrdenamiento() {
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
              _construirOpcionOrdenamiento('Favoritos primero', 'favoritas', Icons.star),
              _construirOpcionOrdenamiento('Nombre', 'nombre', Icons.sort_by_alpha),
            ],
          ),
        );
      },
    );
  }

  /// Construye una opción en el menú de ordenamiento
  Widget _construirOpcionOrdenamiento(String etiqueta, String valor, IconData icono) {
    final estaSeleccionada = _opcionOrdenamiento == valor;
    
    return ListTile(
      leading: Icon(
        icono,
        color: estaSeleccionada 
          ? Theme.of(context).primaryColor 
          : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
      ),
      title: Text(
        etiqueta,
        style: TextStyle(
          fontWeight: estaSeleccionada ? FontWeight.bold : FontWeight.normal,
          color: estaSeleccionada ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: estaSeleccionada ? Icon(
        Icons.check,
        color: Theme.of(context).primaryColor,
      ) : null,
      onTap: () {
        setState(() {
          _opcionOrdenamiento = valor;
          _monedas = _ordenarMonedas(_monedas);
        });
        Navigator.pop(context);
      },
    );
  }
}