# Contributing to AquaVerse

## Code & Architecture Standards
1. **Offline-First & Honest Data:** Never display fake analytics, hardcoded live sensor values, or decorative non-working buttons. All dashboard metrics must read from the database or show honest empty states.
2. **Feature-First Structure:** Place feature code under `lib/features/<feature_name>/` with `presentation/`, `application/`, `domain/`, and `data/` layers when applicable.
3. **Complete File Replacements:** When modifying an existing file, provide the complete updated file rather than partial snippets.
4. **No Committed Secrets:** Never commit `.keystore`, `.jks`, `key.properties`, API keys, or credentials to Git.

## Pre-Commit & Release Checklist
- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- Verify schema changes include a `MigrationStrategy` bump in `lib/core/database/app_database.dart` and update `docs/DATABASE_SCHEMA.md`.
