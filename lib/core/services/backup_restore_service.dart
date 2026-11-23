import 'dart:convert';
import 'dart:io';

import 'package:aquaverse/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BackupRestoreService {
  BackupRestoreService(this._db);

  final AppDatabase _db;

  Future<String> buildJsonBackupPayload() async {
    final aquariumsList = await _db.select(_db.aquariums).get();
    final livestockList = await _db.select(_db.livestock).get();
    final waterTestsList = await _db.select(_db.waterTests).get();
    final tasksList = await _db.select(_db.maintenanceTasks).get();
    final inventoryList = await _db.select(_db.inventoryItems).get();
    final expensesList = await _db.select(_db.expenses).get();

    final payload = <String, dynamic>{
      'app': 'AquaVerse',
      'schemaVersion': _db.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'counts': {
        'aquariums': aquariumsList.length,
        'livestock': livestockList.length,
        'waterTests': waterTestsList.length,
        'tasks': tasksList.length,
        'inventory': inventoryList.length,
        'expenses': expensesList.length,
      },
      'data': {
        'aquariums': aquariumsList
            .map((a) => {
                  'id': a.id,
                  'name': a.name,
                  'category': a.category,
                  'waterType': a.waterType,
                  'temperatureClass': a.temperatureClass,
                  'lengthCm': a.lengthCm,
                  'widthCm': a.widthCm,
                  'heightCm': a.heightCm,
                  'substrateDisplacementLiters': a.substrateDisplacementLiters,
                  'hardscapeDisplacementLiters': a.hardscapeDisplacementLiters,
                  'glassThicknessMm': a.glassThicknessMm,
                  'location': a.location,
                  'status': a.status,
                  'setupDate': a.setupDate.toIso8601String(),
                  'notes': a.notes,
                  'isArchived': a.isArchived,
                  'createdAt': a.createdAt.toIso8601String(),
                  'updatedAt': a.updatedAt.toIso8601String(),
                })
            .toList(),
        'inventory': inventoryList
            .map((i) => {
                  'id': i.id,
                  'name': i.name,
                  'category': i.category,
                  'quantity': i.quantity,
                  'unit': i.unit,
                  'minStockLevel': i.minStockLevel,
                  'unitPrice': i.unitPrice,
                  'expiryDate': i.expiryDate?.toIso8601String(),
                  'updatedAt': i.updatedAt.toIso8601String(),
                })
            .toList(),
        'expenses': expensesList
            .map((e) => {
                  'id': e.id,
                  'aquariumId': e.aquariumId,
                  'category': e.category,
                  'title': e.title,
                  'amount': e.amount,
                  'currencyCode': e.currencyCode,
                  'incurredAt': e.incurredAt.toIso8601String(),
                  'notes': e.notes,
                })
            .toList(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<File> exportJsonBackupFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(p.join(backupDir.path, 'aquaverse_backup_$timestamp.json'));
    final jsonText = await buildJsonBackupPayload();
    return file.writeAsString(jsonText, flush: true);
  }

  Future<int> restoreFromJsonString(String rawJson) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic> || decoded['app'] != 'AquaVerse') {
      throw const FormatException('Invalid AquaVerse backup JSON structure.');
    }
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Missing data section in backup file.');
    }

    int restoredCount = 0;
    await _db.transaction(() async {
      final rawAquariums = data['aquariums'];
      if (rawAquariums is List) {
        for (final item in rawAquariums) {
          if (item is Map<String, dynamic> && item['id'] is String && item['name'] is String) {
            final now = DateTime.now();
            await _db.into(_db.aquariums).insertOnConflictUpdate(
                  AquariumsCompanion.insert(
                    id: item['id'] as String,
                    name: item['name'] as String,
                    category: Value((item['category'] as String?) ?? 'community'),
                    waterType: Value((item['waterType'] as String?) ?? 'freshwater'),
                    temperatureClass: Value((item['temperatureClass'] as String?) ?? 'tropical'),
                    lengthCm: Value(((item['lengthCm'] as num?)?.toDouble()) ?? 60.0),
                    widthCm: Value(((item['widthCm'] as num?)?.toDouble()) ?? 30.0),
                    heightCm: Value(((item['heightCm'] as num?)?.toDouble()) ?? 36.0),
                    substrateDisplacementLiters: Value(
                        ((item['substrateDisplacementLiters'] as num?)?.toDouble()) ?? 4.0),
                    hardscapeDisplacementLiters: Value(
                        ((item['hardscapeDisplacementLiters'] as num?)?.toDouble()) ?? 2.0),
                    glassThicknessMm:
                        Value(((item['glassThicknessMm'] as num?)?.toDouble()) ?? 6.0),
                    location: Value((item['location'] as String?) ?? 'Living Room'),
                    status: Value((item['status'] as String?) ?? 'active'),
                    setupDate: DateTime.tryParse((item['setupDate'] as String?) ?? '') ?? now,
                    notes: Value((item['notes'] as String?) ?? ''),
                    isArchived: Value((item['isArchived'] as bool?) ?? false),
                    createdAt: DateTime.tryParse((item['createdAt'] as String?) ?? '') ?? now,
                    updatedAt: DateTime.tryParse((item['updatedAt'] as String?) ?? '') ?? now,
                  ),
                );
            restoredCount++;
          }
        }
      }
    });
    return restoredCount;
  }
}
