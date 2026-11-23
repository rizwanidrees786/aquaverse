import 'package:aquaverse/core/localization/app_strings.dart';
import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/router/app_router.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AquaVerseApp()));
}

class AquaVerseApp extends ConsumerWidget {
  const AquaVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final strings = ref.watch(appStringsProvider);
    final profile = ref.watch(activeProfileProvider).valueOrNull;

    final themeMode = switch (profile?.themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: strings.appName,
      theme: AquaTheme.light(),
      darkTheme: AquaTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
