import 'package:flutter/material.dart';

class WaterLabScreen extends StatelessWidget {
  const WaterLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      ('Temperature', '25.4 °C', 'Optimal'),
      ('pH Level', '6.8', 'Balanced'),
      ('Ammonia (NH3)', '0.0 ppm', 'Safe'),
      ('Nitrate (NO3)', '10 ppm', 'Normal'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 5 • Water Intelligence')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: metrics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (label, val, status) = metrics[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.science_outlined),
              title: Text(label),
              subtitle: Text('Status: $status'),
              trailing: Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
