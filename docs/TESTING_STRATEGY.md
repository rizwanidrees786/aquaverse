# AquaVerse — Testing & Quality Assurance Strategy

## Test Pyramid
1. **Unit Tests (`test/unit/`)**: Pure Dart logic — temperature, length, and volume conversions; water chemistry & volume helpers; validation rules.
2. **Widget Tests (`test/widget/`)**: UI rendering, navigation, theme switching, and accessible controls (`test/widget/app_smoke_test.dart`).
3. **Integration Tests (`integration_test/`)**: End-to-end offline database persistence, aquarium/test/task workflows, and backup/restore round-trips (expanded in later milestones).

## Release Gates
Every release candidate must pass:
1. `dart format --output=none --set-exit-if-changed .`
2. `flutter analyze`
3. `flutter test`
4. Signed APK (`app-release.apk`) and signed AAB (`app-release.aab`) builds via GitHub Actions or local release pipeline.
