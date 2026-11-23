import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AquaVerseStartupApp());
}

class AquaVerseStartupApp extends StatelessWidget {
  const AquaVerseStartupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaVerse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0288D1)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop_rounded, size: 64, color: Color(0xFF0288D1)),
              SizedBox(height: 12),
              Text(
                'AquaVerse v0.3.0',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text('Startup active — app launch verified.'),
            ],
          ),
        ),
      ),
    );
  }
}
