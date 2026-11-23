# AquaVerse — Internal & External Service Interfaces

## Local Data Layer (`AppDatabase`)
- Reactive streams (`watchAquariums()`, `watchLivestock()`, `watchWaterTests()`, `watchOpenTasks()`, `watchInventory()`, `watchExpenses()`, `watchActiveProfile()`, `watchSubscription()`) power dashboards and lists offline.
- Transactional inserts/updates/deletes enforce foreign key cascades (`onDelete: KeyAction.cascade` on aquarium child entities).

## Backup & Restore Service (`BackupRestoreService`)
- Exports structured JSON snapshots including schema version, timestamp, profile, aquariums, livestock, water tests, tasks, inventory, and expenses.
- Imports and validates JSON snapshots with error reporting so malformed files fail safely without corrupting existing data.

## Secure Storage Service (`SecureStorageService`)
- Wraps `flutter_secure_storage` with in-memory fallback when platform keychain/keystore is unavailable during headless tests, keeping API keys and sensitive tokens out of plain preferences and Git.
