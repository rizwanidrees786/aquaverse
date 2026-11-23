import 'package:flutter/material.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = [
      'Algae control: Balance photoperiod (6–8 hrs) with CO2 and nutrients.',
      'Acclimation: Drip-acclimate sensitive shrimp and tetras for 30–45 mins.',
      'Bio-media: Rinse biological media only in tank water, never tap water.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 7 • AI Assistant & Hub')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: Text(tips[i]),
          ),
        ),
      ),
    );
  }
}
