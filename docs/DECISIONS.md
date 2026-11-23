# AquaVerse — Architecture Decision Records (ADR)

- **ADR-001: Flutter + Riverpod + Drift + GoRouter Stack** — Selected for strong type safety, reactive SQLite streams, offline-first reliability, and clear separation of UI, state, and persistence layers.
- **ADR-002: All 12 Top-Level Sections Accessible Immediately** — Users can navigate across all 12 planned domains (`Home`, `My Aquariums`, `Fish & Livestock`, `Water Lab`, `Care & Tasks`, `Insights`, `AI Assistant`, `Knowledge Center`, `Inventory`, `Marketplace`, `Business`, `Settings`) from the foundation release so every route is wired and ready to expand phase by phase.
- **ADR-003: Honest Empty & Offline States** — Rather than fabricating sample live water readings or fake IoT metrics, dashboards read real Drift table counts and guide users to log real data or explore upcoming phase features.
