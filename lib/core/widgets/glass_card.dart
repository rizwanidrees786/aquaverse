import 'dart:ui';

import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.reducedMotion = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool reducedMotion;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);
    final borderColor = isDark ? AquaColors.borderDark : AquaColors.borderLight;
    final surfaceTint = isDark
        ? AquaColors.glassDark
        : AquaColors.glassLight;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  surfaceTint.withValues(alpha: 0.92),
                  theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.85),
                ]
              : [
                  Colors.white.withValues(alpha: 0.90),
                  theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.78),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (!reducedMotion) {
      content = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
