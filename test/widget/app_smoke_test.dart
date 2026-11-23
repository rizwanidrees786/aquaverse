import 'package:aquaverse/core/database/app_database.dart';
import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/main.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AquaVerse app renders dashboard and navigates to Settings',
      (WidgetTester tester) async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());
    addTearDown(inMemoryDb.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(inMemoryDb),
        ],
        child: const AquaVerseApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('AquaVerse Command Hub'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance & Theme'), findsOneWidget);
  });
}
