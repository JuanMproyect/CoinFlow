import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
  //sección nueva
  Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text( "Convierte tu dinero al instante 💱",
          style: TextStyle(
            fontSize: 22,
            fontWeight:FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text( "Elige la moneda que deseas convertir y obtén el cambio al instante",
          style:TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height:16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              backgroundColor: Colors.white,
              avatar: const Icon(Icons.attach_money, color: Colors.green),
              label: const Text(
                "USD",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            Chip(
              backgroundColor: Colors.white,
              avatar: const Icon(Icons.euro, color: Colors.blue),
              label: const Text(
                "EUR",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    ),
  ),

  const SizedBox(height: 24),      
  Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Cantidad',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Theme.of(context).colorScheme.primary,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {},
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
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
                Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'De',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'USD', child: Text('USD 🇺🇸')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR 🇪🇺')),
                        DropdownMenuItem(value: 'GBP', child: Text('GBP 🇬🇧')),
                        DropdownMenuItem(value: 'HNL', child: Text('HNL 🇭🇳')),
                      ],
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.swap_horiz),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'EUR', child: Text('EUR 🇪🇺')),
                    DropdownMenuItem(value: 'USD', child: Text('USD 🇺🇸')),
                    DropdownMenuItem(value: 'GBP', child: Text('GBP 🇬🇧')),
                    DropdownMenuItem(value: 'HNL', child: Text('HNL 🇭🇳')),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
  const SizedBox(height: 24),
  ElevatedButton.icon(
    onPressed: () {},
    icon: const Icon(Icons.currency_exchange),
    label: const Text('Convertir'),
  ),
  const SizedBox(height: 16),
  Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Resultado:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '€ 0.00',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
],
),
),
),
);
}
}