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
            height: 150, // Increased from 40 to 60 for a larger logo
            fit: BoxFit.contain,
          ),
        ),
        toolbarHeight: 80, // Increased toolbar height to accommodate larger logo
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Conversor de Monedas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Convierte de manera rápida y precisa',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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