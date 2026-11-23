import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/widgets/empty_state_view.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessScreen extends ConsumerWidget {
  const BusinessScreen({super.key});

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
            title: strings.navBusiness,
            subtitle: 'Foundation route active • Offline SQLite ready',
          ),
          const SizedBox(height: 16),
          EmptyStateView(
            icon: Icons.construction_rounded,
            title: '${strings.navBusiness} Module Foundation',
            message: 'Customer profiles, service bookings, maintenance contracts and multi-user roles will expand in ZIP Delivery 08 (v0.8.0).',
            reducedMotion: reducedMotion,
          ),
        ],
      ),
    );
  }
}
