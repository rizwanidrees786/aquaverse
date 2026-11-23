import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/widgets/empty_state_view.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiAssistantScreen extends ConsumerWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final reducedMotion =
        ref.watch(activeProfileProvider).valueOrNull?.reducedMotion ?? false;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: strings.navAi,
            subtitle: 'Foundation route active • Offline SQLite ready',
          ),
          const SizedBox(height: 16),
          EmptyStateView(
            icon: Icons.construction_rounded,
            title: '${strings.navAi} Module Foundation',
            message: 'Aqua Intelligence offline rules and optional cloud API assistant will expand in ZIP Delivery 07 (v0.7.0).',
            reducedMotion: reducedMotion,
          ),
        ],
      ),
    );
  }
}
