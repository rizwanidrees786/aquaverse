# AquaVerse — Database Schema (`schemaVersion = 1`)

Engine: **Drift** (`drift` + `sqlite3_flutter_libs`)  
Location: `lib/core/database/app_database.dart`

## Tables in Schema v1
1. `users` — Local/cloud user records (`id`, `email`, `displayName`, `role`, `createdAt`, `updatedAt`).
2. `profiles` — User preferences, experience level, locale (`en`/`ur`), unit system (`metric`/`imperial`), currency, font scale, reduced motion, onboarding completion.
3. `aquariums` — Multi-tank profiles (`id`, `profileId`, `name`, `category`, `waterType`, `temperatureClass`, `lengthCm`, `widthCm`, `heightCm`, `substrateDisplacementLiters`, `hardscapeDisplacementLiters`, `glassThicknessMm`, `location`, `status`, `setupDate`, `commissionedDate`, `notes`, `isArchived`, `createdAt`, `updatedAt`).
4. `aquarium_measurements` — Physical/operational logs and health/cycling snapshots (`aquariumId` FK -> `aquariums.id` CASCADE).
5. `species` — Reference catalog of fish, plants, corals, and invertebrates with scientific & care fields and review metadata.
6. `livestock` — Individual or group livestock entries (`aquariumId` FK -> `aquariums.id` CASCADE, optional `speciesId` FK -> `species.id`).
7. `water_tests` — Water parameter test records (`aquariumId` FK -> `aquariums.id` CASCADE).
8. `maintenance_tasks` — Scheduled & recurring care tasks (`aquariumId` FK -> `aquariums.id` CASCADE).
9. `feeding_logs` — Feeding records and food inventory tracking (`aquariumId` FK -> `aquariums.id` CASCADE).
10. `equipment_items` — Filters, heaters, lights, CO2, dosing, controllers (`aquariumId` FK -> `aquariums.id` CASCADE).
11. `inventory_items` — Supplies, food, test kits, medications, media, stock & reorder thresholds.
12. `expenses` — Tank, livestock, equipment, and supply expenses (`aquariumId` optional FK -> `aquariums.id`).
13. `notifications_log` — Scheduled/triggered alert history (`aquariumId` optional FK -> `aquariums.id`).
14. `ai_conversations` — AI assistant session threads and context preferences (`aquariumId` optional FK -> `aquariums.id`).
15. `subscriptions` — Subscription tier (`free`, `pro`, `expert`, `business`), status, provider, and expiry metadata.

Future migrations will increment `schemaVersion` and add explicit `from <= ...` steps in `MigrationStrategy.onUpgrade`.
