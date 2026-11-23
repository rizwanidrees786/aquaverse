import 'package:aquaverse/core/database/app_database.dart';
import 'package:aquaverse/core/localization/app_strings.dart';
import 'package:aquaverse/core/security/secure_storage_service.dart';
import 'package:aquaverse/core/services/backup_restore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final backupRestoreServiceProvider = Provider<BackupRestoreService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BackupRestoreService(db);
});

final activeProfileProvider = StreamProvider<Profile?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchActiveProfile();
});

final appStringsProvider = Provider<AppStrings>((ref) {
  final profile = ref.watch(activeProfileProvider).valueOrNull;
  return AppStrings(profile?.localeCode ?? 'en');
});

final aquariumsStreamProvider = StreamProvider<List<Aquarium>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAquariums();
});

final livestockStreamProvider = StreamProvider<List<LivestockData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchLivestock();
});

final waterTestsStreamProvider = StreamProvider<List<WaterTest>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchWaterTests();
});

final openTasksStreamProvider = StreamProvider<List<MaintenanceTask>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchOpenTasks();
});

final inventoryStreamProvider = StreamProvider<List<InventoryItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchInventory();
});

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchExpenses();
});

final subscriptionStreamProvider = StreamProvider<Subscription?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchSubscription();
});
