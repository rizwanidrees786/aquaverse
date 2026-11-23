import 'package:flutter/material.dart';

class BusinessHubScreen extends StatelessWidget {
  const BusinessHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business & Cloud Sync')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.storefront_outlined),
                title: Text('Breeder & Store Ledger'),
                subtitle: Text('Offline-first records ready for export & sync'),
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.cloud_done_outlined),
                title: Text('Local Snapshot Status'),
                subtitle: Text('All local logs preserved across builds'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
