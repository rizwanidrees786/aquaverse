import 'package:aquaverse/features/ai_assistant/ai_assistant_screen.dart';
import 'package:aquaverse/features/business_hub/business_hub_screen.dart';
import 'package:aquaverse/features/equipment/equipment_screen.dart';
import 'package:aquaverse/features/tasks/tasks_screen.dart';
import 'package:aquaverse/features/water_lab/water_lab_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AquaVerseMultiPhaseApp());
}

class AquaVerseMultiPhaseApp extends StatefulWidget {
  const AquaVerseMultiPhaseApp({super.key});

  @override
  State<AquaVerseMultiPhaseApp> createState() => _AquaVerseMultiPhaseAppState();
}

class _AquaVerseMultiPhaseAppState extends State<AquaVerseMultiPhaseApp> {
  int _index = 0;

  final List<Widget> _pages = const [
    EquipmentScreen(),
    WaterLabScreen(),
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
            NavigationDestination(icon: Icon(Icons.build_circle_outlined), label: 'Ph 4'),
            NavigationDestination(icon: Icon(Icons.water_drop_outlined), label: 'Ph 5'),
            NavigationDestination(icon: Icon(Icons.checklist_outlined), label: 'Ph 6'),
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'Ph 7'),
            NavigationDestination(icon: Icon(Icons.hub_outlined), label: 'Ph 8'),
          ],
        ),
      ),
    );
  }
}
