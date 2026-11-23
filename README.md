# AquaVerse — Ultimate Aquarium Management Ecosystem

**Version:** `0.1.0` (`AquaVerse_v0.1.0_Foundation`)  
**Framework:** Flutter + Dart (Android-first, ready for iOS & Web expansion)  
**Architecture:** Offline-first Clean Architecture + Feature-first Modules + Drift (SQLite) + Riverpod + GoRouter

---

## What Is Included in ZIP DELIVERY 01 — FOUNDATION (Phases 1–4)

- **Phase 1 — Project Architecture & Setup:** Complete VS Code workspace configuration, `.gitignore`, `.github/workflows/android-build.yml`, `pubspec.yaml`, environment configuration templates, and full project documentation (`docs/`).
- **Phase 2 — Design System & Premium UI Foundation:** Crystal/glass-inspired surface tokens, light/dark/system theme support, customizable accent colors, adaptive typography, text-scale & reduced-motion controls, and reusable UI components (`GlassCard`, `SectionHeader`, `MetricTile`, `EmptyStateView`, `StatusPill`).
- **Phase 3 — Navigation, Onboarding & Dashboard Foundation:** `GoRouter` navigation across all 12 top-level modules (`Home`, `My Aquariums`, `Fish & Livestock`, `Water Lab`, `Care & Tasks`, `Insights`, `AI Assistant`, `Knowledge Center`, `Inventory`, `Marketplace`, `Business`, `Settings`), interactive onboarding flow, and real-database-backed dashboard.
- **Phase 4 — Offline Database, Models & Application Settings:** Normalized versioned Drift SQLite schema (`AppDatabase`, schema v1) covering users, profiles, aquariums, aquarium measurements, species, livestock, water tests, tasks, feeding, equipment, inventory, expenses, notifications, settings, and subscriptions, plus unit conversions (`cm`/`in`/`ft`, `L`/`gal`, `°C`/`°F`), backup/restore JSON & DB utilities, and secure storage service.

---

## Quick Start in Visual Studio Code

1. Extract `AquaVerse_v0.1.0_Foundation.zip` so `AquaVerse_v0.1.0_Foundation` is your workspace folder.
2. Open the folder in **Visual Studio Code**.
3. Ensure the Flutter SDK is installed and on your `PATH`. Run in terminal:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze
   flutter test
   ```
4. Launch on an Android emulator or connected device:
   ```bash
   flutter run
   ```

> **Note on Environment Verification:** Because this sandbox does not have network access to `pub.dev` or a full Android SDK toolchain, `flutter pub get`, `build_runner`, `flutter analyze`, and APK/AAB builds were not executed inside this container. All Dart files, Drift schemas, tests, and workflows have been written cleanly and verified structurally.

---

## Permanent Project Documentation

All required project records are maintained in `docs/`:
- `docs/MASTER_SPECIFICATION.md`
- `docs/PROJECT_ROADMAP.md`
- `docs/IMPLEMENTATION_STATUS.md`
- `docs/FEATURE_REGISTRY.md`
- `docs/DATABASE_SCHEMA.md`
- `docs/ARCHITECTURE.md`
- `docs/API_DOCUMENTATION.md`
- `docs/TESTING_STRATEGY.md`
- `docs/CHANGELOG.md`
- `docs/KNOWN_ISSUES.md`
- `docs/BUILD_AND_RELEASE_GUIDE.md`
- `docs/AI_CONTEXT.md`
- `docs/DECISIONS.md`
