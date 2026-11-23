# AquaVerse — System Architecture

## Architectural Style
AquaVerse follows **Clean Architecture** combined with **Feature-First Modularity**:
- `lib/core/`: Design tokens, theme builder, router (`GoRouter`), Drift SQLite database, unit conversions, secure storage, backup/restore service, localization (`en`/`ur`), and shared UI widgets.
- `lib/features/<module>/`: Vertical slices for `dashboard`, `aquariums`, `livestock`, `water_lab`, `tasks`, `insights`, `ai_assistant`, `knowledge`, `inventory`, `marketplace`, `business`, and `settings`.
- `lib/shared/`: Cross-feature models, widgets, and formatting helpers.

## State Management & Reactive Data Flow
- **Riverpod (`flutter_riverpod`)** provides reactive streams and state notifiers backed directly by Drift SQLite queries.
- Views subscribe to real database state rather than hardcoded placeholder arrays.
- Destructive or sensitive actions (like data import/restore or account/data reset) require explicit confirmation dialogs.
