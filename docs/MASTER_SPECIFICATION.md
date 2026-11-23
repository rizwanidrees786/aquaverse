# AquaVerse — Master Specification

**Codename:** AquaVerse  
**Version:** `0.1.0`  
**Target:** Android-first (APK & signed AAB), architecture ready for iOS and Web expansion  
**Stack:** Flutter + Dart, Drift (SQLite), Riverpod, GoRouter, `flutter_secure_storage`, `flutter_local_notifications`

## Core Principles
1. **Offline-First Operation:** Core aquarium management, water testing, livestock logs, tasks, and calculators run locally via SQLite (`Drift`) without requiring network connectivity.
2. **Scientific Responsibility:** Never claim a tank is cycled solely on elapsed days; never invent medication dosages or diagnose conditions from photos with certainty; distinguish educational guidance from veterinary advice; avoid the outdated 1-inch-per-gallon rule as a scientific standard.
3. **Honest Data & Complete Actions:** Every button, form, filter, export, and chart connects to real functionality or database records. No fake live sensor streams or hardcoded sample measurements masquerading as live aquarium data.
4. **Accessibility & Localization:** English and Urdu (`ur`) support with RTL layout awareness, metric/imperial unit conversions, currency configuration, adjustable font scale, high-contrast options, and reduced motion preferences.

## 12 Top-Level Navigation Destinations
1. **Home** (`/home`) — Live summary of aquariums, livestock, water tests, due tasks, and quick actions.
2. **My Aquariums** (`/aquariums`) — Multi-tank profiles, volume/displacement calculators, setup checklists, cycling & lifecycle tracking.
3. **Fish & Livestock** (`/livestock`) — Species catalog, individual/group livestock records, health/relocation/mortality logs, compatibility & stocking intelligence.
4. **Water Lab** (`/water-lab`) — Parameter logs, trend charts, stability scoring, water-change & chemistry calculators, nitrogen cycle tracker.
5. **Care & Tasks** (`/tasks`) — Recurring schedules, feeding/maintenance reminders, completion/postponement history, notifications.
6. **Insights** (`/insights`) — Analytics dashboards, trends, and CSV/JSON/printable report exports.
7. **AI Assistant** (`/ai-assistant`) — Aqua Intelligence context-aware guidance (offline rule engine + optional user-configured cloud API with privacy controls).
8. **Knowledge Center** (`/knowledge`) — Guides, cycling/aquascaping/disease references, and optional community architecture.
9. **Inventory** (`/inventory`) — Supplies, food, test kits, medications, media, stock levels, and low-stock tracking.
10. **Marketplace** (`/marketplace`) — Catalog, comparisons, favorites, and authorized commerce integration architecture.
11. **Business** (`/business`) — Multi-user/role model, customer profiles, service bookings, maintenance contracts, invoices, and P&L foundation.
12. **Settings** (`/settings`) — Theme (light/dark/system), accent color, language (`en`/`ur`), units, font scale, reduced motion, backup/restore, subscription status, and security.
