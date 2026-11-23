import 'package:flutter/material.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const guides = [
      ('Nitrogen Cycle', 'Establish beneficial bacteria over 3–6 weeks before adding sensitive livestock.'),
      ('CO2 & Light Balance', 'Keep CO2 drop-checker green and match photoperiod to plant mass to prevent algae.'),
      ('Drip Acclimation', 'Equalize temperature and water chemistry slowly over 30–45 minutes.'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant & Knowledge Hub')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guides.length,
        itemBuilder: (context, i) {
          final (topic, tip) = guides[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: Text(topic, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(tip),
            ),
          );
        },
      ),
    );
  }
}
