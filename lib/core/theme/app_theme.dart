import 'package:flutter/material.dart';

enum AccentOption {
  aquaTeal('aqua_teal', 'Aqua Teal', Color(0xFF00838F), Color(0xFF26C6DA)),
  deepLagoon('deep_lagoon', 'Deep Lagoon', Color(0xFF0277BD), Color(0xFF29B6F6)),
  reefCoral('reef_coral', 'Reef Coral', Color(0xFFD84315), Color(0xFFFF7043)),
  plantedEmerald('planted_emerald', 'Planted Emerald', Color(0xFF00695C), Color(0xFF26A69A));

  const AccentOption(this.key, this.label, this.lightSeed, this.darkSeed);

  final String key;
  final String label;
  final Color lightSeed;
  final Color darkSeed;

  static AccentOption fromKey(String? key) {
    for (final option in AccentOption.values) {
      if (option.key == key) return option;
    }
    return AccentOption.aquaTeal;
  }
}

class AquaColors {
  static const abyssDark = Color(0xFF07131A);
  static const abyssCardDark = Color(0xFF0F232E);
  static const frostLight = Color(0xFFF3F9FB);
  static const glassLight = Color(0xCCFFFFFF);
  static const glassDark = Color(0xB3122A37);
  static const borderLight = Color(0x3300838F);
  static const borderDark = Color(0x334DD0E1);
  static const statusHealthy = Color(0xFF1B8A5A);
  static const statusWarning = Color(0xFFC87A00);
  static const statusCritical = Color(0xFFC62828);
}

class AppTheme {
  static ThemeData buildTheme({
    required Brightness brightness,
    required AccentOption accent,
    required double textScaleFactor,
    required bool highContrast,
  }) {
    final isDark = brightness == Brightness.dark;
    final seed = isDark ? accent.darkSeed : accent.lightSeed;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      contrastLevel: highContrast ? 0.5 : 0.0,
    );

    final colorScheme = baseScheme.copyWith(
      surface: isDark ? AquaColors.abyssDark : AquaColors.frostLight,
      surfaceContainerLowest: isDark ? const Color(0xFF050E13) : Colors.white,
      surfaceContainerLow: isDark ? const Color(0xFF0B1A23) : const Color(0xFFEAF4F8),
      surfaceContainer: isDark ? AquaColors.abyssCardDark : const Color(0xFFE1EFF5),
      surfaceContainerHigh: isDark ? const Color(0xFF152E3C) : const Color(0xFFD6E9F2),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: isDark ? AquaColors.glassDark : AquaColors.glassLight,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 70,
        backgroundColor: isDark
            ? AquaColors.abyssCardDark.withValues(alpha: 0.94)
            : Colors.white.withValues(alpha: 0.94),
        indicatorColor: colorScheme.primaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AquaColors.borderDark : AquaColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AquaColors.borderDark : AquaColors.borderLight,
          ),
        ),
      ),
    );
  }
}
