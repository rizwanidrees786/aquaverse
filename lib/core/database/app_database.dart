import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get displayName => text()();
  TextColumn get role => text().withDefault(const Constant('owner'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable().references(Users, #id, onDelete: KeyAction.setNull)();
  TextColumn get experienceLevel => text().withDefault(const Constant('beginner'))();
  TextColumn get localeCode => text().withDefault(const Constant('en'))();
  TextColumn get unitSystem => text().withDefault(const Constant('metric'))();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get accentColorKey => text().withDefault(const Constant('aqua_teal'))();
  RealColumn get textScaleFactor => real().withDefault(const Constant(1.0))();
  BoolColumn get reducedMotion => boolean().withDefault(const Constant(false))();
  BoolColumn get highContrast => boolean().withDefault(const Constant(false))();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Aquariums extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().nullable().references(Profiles, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant('community'))();
  TextColumn get waterType => text().withDefault(const Constant('freshwater'))();
  TextColumn get temperatureClass => text().withDefault(const Constant('tropical'))();
  RealColumn get lengthCm => real().withDefault(const Constant(60.0))();
  RealColumn get widthCm => real().withDefault(const Constant(30.0))();
  RealColumn get heightCm => real().withDefault(const Constant(36.0))();
  RealColumn get substrateDisplacementLiters => real().withDefault(const Constant(4.0))();
  RealColumn get hardscapeDisplacementLiters => real().withDefault(const Constant(2.0))();
  RealColumn get glassThicknessMm => real().withDefault(const Constant(6.0))();
  TextColumn get location => text().withDefault(const Constant('Living Room'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get setupDate => dateTime()();
  DateTimeColumn get commissionedDate => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AquariumMeasurements extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().references(Aquariums, #id, onDelete: KeyAction.cascade)();
  TextColumn get metricType => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Species extends Table {
  TextColumn get id => text()();
  TextColumn get commonName => text()();
  TextColumn get scientificName => text()();
  TextColumn get kingdomOrGroup => text().withDefault(const Constant('freshwater_fish'))();
  TextColumn get temperament => text().withDefault(const Constant('peaceful'))();
  RealColumn get minTankLiters => real().withDefault(const Constant(40.0))();
  RealColumn get tempMinC => real().nullable()();
  RealColumn get tempMaxC => real().nullable()();
  RealColumn get phMin => real().nullable()();
  RealColumn get phMax => real().nullable()();
  TextColumn get careSummary => text().withDefault(const Constant(''))();
  TextColumn get sourceReference => text().withDefault(const Constant(''))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Livestock extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().references(Aquariums, #id, onDelete: KeyAction.cascade)();
  TextColumn get speciesId => text().nullable().references(Species, #id, onDelete: KeyAction.setNull)();
  TextColumn get nameOrLabel => text()();
  TextColumn get speciesCommonName => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get healthStatus => text().withDefault(const Constant('healthy'))();
  TextColumn get quarantineStatus => text().withDefault(const Constant('none'))();
  RealColumn get sizeCm => real().nullable()();
  DateTimeColumn get acquiredAt => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WaterTests extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().references(Aquariums, #id, onDelete: KeyAction.cascade)();
  RealColumn get temperatureC => real().nullable()();
  RealColumn get ph => real().nullable()();
  RealColumn get ammoniaPpm => real().nullable()();
  RealColumn get nitritePpm => real().nullable()();
  RealColumn get nitratePpm => real().nullable()();
  RealColumn get ghDgh => real().nullable()();
  RealColumn get khDkh => real().nullable()();
  RealColumn get tdsPpm => real().nullable()();
  RealColumn get salinityPpt => real().nullable()();
  TextColumn get testKit => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get testedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MaintenanceTasks extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().references(Aquariums, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get category => text().withDefault(const Constant('water_change'))();
  TextColumn get frequency => text().withDefault(const Constant('weekly'))();
  IntColumn get intervalDays => integer().withDefault(const Constant(7))();
  DateTimeColumn get dueAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FeedingLogs extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().references(Aquariums, #id, onDelete: KeyAction.cascade)();
  TextColumn get foodName => text()();
  TextColumn get amountDescription => text()();
  DateTimeColumn get fedAt => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class EquipmentItems extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().references(Aquariums, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get manufacturer => text().withDefault(const Constant(''))();
  TextColumn get model => text().withDefault(const Constant(''))();
  RealColumn get wattage => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get installedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class InventoryItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  RealColumn get quantity => real().withDefault(const Constant(0.0))();
  TextColumn get unit => text().withDefault(const Constant('units'))();
  RealColumn get minStockLevel => real().withDefault(const Constant(1.0))();
  RealColumn get unitPrice => real().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().nullable().references(Aquariums, #id, onDelete: KeyAction.setNull)();
  TextColumn get category => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
  DateTimeColumn get incurredAt => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class NotificationsLog extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().nullable().references(Aquariums, #id, onDelete: KeyAction.setNull)();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get category => text().withDefault(const Constant('reminder'))();
  DateTimeColumn get scheduledFor => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiConversations extends Table {
  TextColumn get id => text()();
  TextColumn get aquariumId => text().nullable().references(Aquariums, #id, onDelete: KeyAction.setNull)();
  TextColumn get title => text()();
  TextColumn get providerMode => text().withDefault(const Constant('offline_rules'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get tier => text().withDefault(const Constant('free'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get provider => text().withDefault(const Constant('local'))();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Users,
    Profiles,
    Aquariums,
    AquariumMeasurements,
    Species,
    Livestock,
    WaterTests,
    MaintenanceTasks,
    FeedingLogs,
    EquipmentItems,
    InventoryItems,
    Expenses,
    NotificationsLog,
    AiConversations,
    Subscriptions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _createIndexes();
          await _seedInitialDefaults();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 1) {
            await m.createAll();
            await _createIndexes();
          }
        },
        beforeOpen: (OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_aquariums_archived ON aquariums(is_archived)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_livestock_aquarium ON livestock(aquarium_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_water_tests_aquarium_date ON water_tests(aquarium_id, tested_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tasks_due_completed ON maintenance_tasks(is_completed, due_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_expenses_incurred ON expenses(incurred_at)',
    );
  }

  Future<void> _seedInitialDefaults() async {
    final now = DateTime.now();
    await into(profiles).insertOnConflictUpdate(
      ProfilesCompanion.insert(
        id: 'default_profile',
        updatedAt: now,
      ),
    );
    await into(subscriptions).insertOnConflictUpdate(
      SubscriptionsCompanion.insert(
        id: 'default_subscription',
        tier: const Value('free'),
        status: const Value('active'),
        provider: const Value('local'),
        updatedAt: now,
      ),
    );
  }

  Stream<Profile?> watchActiveProfile() {
    return (select(profiles)..where((t) => t.id.equals('default_profile')))
        .watchSingleOrNull();
  }

  Future<void> updateProfilePreferences({
    String? localeCode,
    String? unitSystem,
    String? currencyCode,
    String? themeMode,
    String? accentColorKey,
    double? textScaleFactor,
    bool? reducedMotion,
    bool? highContrast,
    bool? onboardingCompleted,
    String? experienceLevel,
  }) async {
    final now = DateTime.now();
    final current = await (select(profiles)
          ..where((t) => t.id.equals('default_profile')))
        .getSingleOrNull();

    await into(profiles).insertOnConflictUpdate(
      ProfilesCompanion(
        id: const Value('default_profile'),
        userId: Value(current?.userId),
        experienceLevel: Value(experienceLevel ?? current?.experienceLevel ?? 'beginner'),
        localeCode: Value(localeCode ?? current?.localeCode ?? 'en'),
        unitSystem: Value(unitSystem ?? current?.unitSystem ?? 'metric'),
        currencyCode: Value(currencyCode ?? current?.currencyCode ?? 'USD'),
        themeMode: Value(themeMode ?? current?.themeMode ?? 'system'),
        accentColorKey: Value(accentColorKey ?? current?.accentColorKey ?? 'aqua_teal'),
        textScaleFactor: Value(textScaleFactor ?? current?.textScaleFactor ?? 1.0),
        reducedMotion: Value(reducedMotion ?? current?.reducedMotion ?? false),
        highContrast: Value(highContrast ?? current?.highContrast ?? false),
        onboardingCompleted: Value(onboardingCompleted ?? current?.onboardingCompleted ?? false),
        updatedAt: Value(now),
      ),
    );
  }

  Stream<List<Aquarium>> watchAquariums({bool includeArchived = false}) {
    final query = select(aquariums)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    return query.watch();
  }

  Stream<List<LivestockData>> watchLivestock() {
    return select(livestock).watch();
  }

  Stream<List<WaterTest>> watchWaterTests() {
    return (select(waterTests)..orderBy([(t) => OrderingTerm.desc(t.testedAt)]))
        .watch();
  }

  Stream<List<MaintenanceTask>> watchOpenTasks() {
    return (select(maintenanceTasks)
          ..where((t) => t.isCompleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]))
        .watch();
  }

  Stream<List<InventoryItem>> watchInventory() {
    return select(inventoryItems).watch();
  }

  Stream<List<Expense>> watchExpenses() {
    return (select(expenses)..orderBy([(t) => OrderingTerm.desc(t.incurredAt)]))
        .watch();
  }

  Stream<Subscription?> watchSubscription() {
    return (select(subscriptions)
          ..where((t) => t.id.equals('default_subscription')))
        .watchSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'aquaverse.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
