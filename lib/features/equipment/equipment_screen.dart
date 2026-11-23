import 'package:flutter/material.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final List> _items = [
    {'name': 'Canister Filter FX-Pro', 'zone': 'Main Tank', 'active': true},
    {'name': 'CO2 Dual-Gauge Regulator', 'zone': 'Aquascape', 'active': true},
    {'name': 'LED Full-Spectrum Light', 'zone': 'Main Tank', 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 4 • Equipment & Aquascape')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final item = _items[i];
          return Card(
            child: SwitchListTile(
              title: Text(item['name'] as String),
              subtitle: Text('Zone: ${item['zone']}'),
              value: item['active'] as bool,
              onChanged: (v) => setState(() => item['active'] = v),
            ),
          );
        },
      ),
    );
  }
}
