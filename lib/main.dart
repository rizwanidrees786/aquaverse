import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/router/app_router.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    final profile = ref.watch(activeProfileProvider).valueOrNull;

    final themeModeStr = profile?.themeMode ?? 'system';
    final ThemeMode themeMode = switch (themeModeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final accent = AccentOption.fromKey(profile?.accentColorKey);
    final textScale = (profile?.textScaleFactor ?? 1.0).clamp(0.8, 1.5);
    final highContrast = profile?.highContrast ?? false;
    final localeCode = profile?.localeCode ?? 'en';
    final locale = Locale(localeCode == 'ur' ? 'ur' : 'en');

    final lightTheme = AppTheme.buildTheme(
      brightness: Brightness.light,
      accent: accent,
      textScaleFactor: textScale,
      highContrast: highContrast,
    );

    final darkTheme = AppTheme.buildTheme(
      brightness: Brightness.dark,
      accent: accent,
      textScaleFactor: textScale,
      highContrast: highContrast,
    );

    return MaterialApp.router(
      title: 'AquaVerse',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
