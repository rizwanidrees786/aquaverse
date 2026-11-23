import 'package:aquaverse/features/ai_assistant/ai_assistant_screen.dart';
import 'package:aquaverse/features/aquariums/aquariums_screen.dart';
import 'package:aquaverse/features/business_hub/business_hub_screen.dart';
import 'package:aquaverse/features/equipment/equipment_screen.dart';
import 'package:aquaverse/features/livestock/livestock_screen.dart';
import 'package:aquaverse/features/tasks/tasks_screen.dart';
import 'package:aquaverse/features/water_lab/water_lab_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AquaVerseCompleteApp());
}

class AquaVerseCompleteApp extends StatefulWidget {
  const AquaVerseCompleteApp({super.key});

  @override
  State<AquaVerseCompleteApp> createState() => _AquaVerseCompleteAppState();
}

class _AquaVerseCompleteAppState extends State<AquaVerseCompleteApp> {
  int _index = 0;

  final List<Widget> _pages = const [
    AquariumsScreen(),
    LivestockScreen(),
    WaterLabScreen(),
    EquipmentScreen(),
    TasksScreen(),
    AiAssistantScreen(),
    BusinessHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaVerse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0288D1)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.water_outlined), label: 'Tanks'),
            NavigationDestination(icon: Icon(Icons.pets_outlined), label: 'Stock'),
            NavigationDestination(icon: Icon(Icons.science_outlined), label: 'Water'),
            NavigationDestination(icon: Icon(Icons.build_outlined), label: 'Gear'),
            NavigationDestination(icon: Icon(Icons.checklist_outlined), label: 'Tasks'),
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'AI Hub'),
            NavigationDestination(icon: Icon(Icons.hub_outlined), label: 'Sync'),
          ],
        ),
      ),
    );
  }
}
