import 'package:flutter/material.dart';

class AquariumsScreen extends StatefulWidget {
  const AquariumsScreen({super.key});

  @override
  State<AquariumsScreen> createState() => _AquariumsScreenState();
}

class _AquariumsScreenState extends State<AquariumsScreen> {
  final _tanks = [
    {'name': 'Amazon Planted 120L', 'type': 'Freshwater High-Tech', 'temp': '25.2 °C', 'ph': '6.7'},
    {'name': 'Nano Shrimp & Moss 45L', 'type': 'Aquascape', 'temp': '23.8 °C', 'ph': '6.5'},
    {'name': 'Community Cichlid 200L', 'type': 'Freshwater', 'temp': '26.1 °C', 'ph': '7.4'},
  ];

  void _addTank() {
    setState(() {
      final n = _tanks.length + 1;
      _tanks.add({'name': 'Custom Tank #$n', 'type': 'Freshwater', 'temp': '25.0 °C', 'ph': '7.0'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aquariums & Tanks')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTank,
        icon: const Icon(Icons.add),
        label: const Text('Add Tank'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tanks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = _tanks[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.water, color: Color(0xFF0288D1)),
              title: Text(t['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${t['type']} • Temp ${t['temp']} • pH ${t['ph']}'),
            ),
          );
        },
      ),
    );
  }
}
