import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<(String, bool)> _tasks = [
    ('30% Weekly Water Change', false),
    ('Clean Filter Pre-sponge', true),
    ('Dose Liquid Fertilizer', false),
    ('Test KH & GH Parameters', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks & Inventory')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, i) {
          final (title, done) = _tasks[i];
          return CheckboxListTile(
            title: Text(title),
            value: done,
            onChanged: (v) => setState(() => _tasks[i] = (title, v ?? false)),
          );
        },
      ),
    );
  }
}
