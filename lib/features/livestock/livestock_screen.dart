import 'package:flutter/material.dart';

class LivestockScreen extends StatefulWidget {
  const LivestockScreen({super.key});

  @override
  State<LivestockScreen> createState() => _LivestockScreenState();
}

class _LivestockScreenState extends State<LivestockScreen> {
  final _stock = [
    {'name': 'Cardinal Tetra', 'count': 18, 'tank': 'Amazon Planted 120L'},
    {'name': 'Cherry Shrimp (Neocaridina)', 'count': 32, 'tank': 'Nano Shrimp & Moss 45L'},
    {'name': 'Rummynose Tetra', 'count': 12, 'tank': 'Amazon Planted 120L'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livestock & Inhabitants')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _stock.length,
        itemBuilder: (context, i) {
          final item = _stock[i];
          final count = item['count'] as int;
          return Card(
            child: ListTile(
              leading: const Icon(Icons.pets_outlined),
              title: Text(item['name'] as String),
              subtitle: Text('Tank: ${item['tank']} • Count: $count'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() {
                      if (count > 0) item['count'] = count - 1;
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => item['count'] = count + 1),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
