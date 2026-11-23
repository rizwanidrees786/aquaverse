import 'package:flutter/material.dart';

class WaterLabScreen extends StatefulWidget {
  const WaterLabScreen({super.key});

  @override
  State<WaterLabScreen> createState() => _WaterLabScreenState();
}

class _WaterLabScreenState extends State<WaterLabScreen> {
  double _ph = 6.8;
  double _temp = 25.4;
  double _nitrate = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Intelligence Lab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('pH Level: ${_ph.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    min: 5.0,
                    max: 8.5,
                    divisions: 35,
                    value: _ph,
                    onChanged: (v) => setState(() => _ph = v),
                  ),
                  Text('Temperature: ${_temp.toStringAsFixed(1)} °C', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    min: 18.0,
                    max: 32.0,
                    divisions: 28,
                    value: _temp,
                    onChanged: (v) => setState(() => _temp = v),
                  ),
                  Text('Nitrate (NO3): ${_nitrate.toStringAsFixed(0)} ppm', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    min: 0.0,
                    max: 80.0,
                    divisions: 16,
                    value: _nitrate,
                    onChanged: (v) => setState(() => _nitrate = v),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
