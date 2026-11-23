import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/router/app_router.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:aquaverse/core/widgets/empty_state_view.dart';
import 'package:aquaverse/core/widgets/glass_card.dart';
import 'package:aquaverse/core/widgets/metric_tile.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:aquaverse/core/widgets/status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final profile = ref.watch(activeProfileProvider).valueOrNull;
    final reducedMotion = profile?.reducedMotion ?? false;
    final aquariums = ref.watch(aquariumsStreamProvider).valueOrNull ?? const [];
    final livestock = ref.watch(livestockStreamProvider).valueOrNull ?? const [];
    final waterTests = ref.watch(waterTestsStreamProvider).valueOrNull ?? const [];
    final openTasks = ref.watch(openTasksStreamProvider).valueOrNull ?? const [];
    final subscription = ref.watch(subscriptionStreamProvider).valueOrNull;

    final totalLivestockCount = livestock.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final overdueTasksCount = openTasks
        .where((t) => t.dueAt.isBefore(DateTime.now()))
        .length;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(aquariumsStreamProvider);
          ref.invalidate(livestockStreamProvider);
          ref.invalidate(waterTestsStreamProvider);
          ref.invalidate(openTasksStreamProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              reducedMotion: reducedMotion,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusPill(
                        label: 'OFFLINE READY • v0.1.0',
                        color: AquaColors.statusHealthy,
                        icon: Icons.verified_rounded,
                      ),
                      StatusPill(
                        label: 'PLAN: ${(subscription?.tier ?? 'free').toUpperCase()}',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.dashboardTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.dashboardSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (profile?.onboardingCompleted != true) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.onboarding),
                      icon: const Icon(Icons.tune_rounded),
                      label: const Text('Personalize Setup & Units'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionHeader(
              title: 'Database Summary',
              subtitle: 'Counts reflect records stored locally in SQLite',
              actionLabel: strings.navSettings,
              onAction: () => context.go(AppRoutes.settings),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 600 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    MetricTile(
                      label: strings.navAquariums,
                      value: '${aquariums.length}',
                      icon: Icons.view_in_ar_rounded,
                      reducedMotion: reducedMotion,
                      subtitle: aquariums.isEmpty ? 'No tanks yet' : 'Active profiles',
                      onTap: () => context.go(AppRoutes.aquariums),
                    ),
                    MetricTile(
                      label: 'Livestock Count',
                      value: '$totalLivestockCount',
                      icon: Icons.set_meal_rounded,
                      accentColor: AquaColors.statusHealthy,
                      reducedMotion: reducedMotion,
                      subtitle: '${livestock.length} entries',
                      onTap: () => context.go(AppRoutes.livestock),
                    ),
                    MetricTile(
                      label: 'Water Tests',
                      value: '${waterTests.length}',
                      icon: Icons.science_rounded,
                      accentColor: Theme.of(context).colorScheme.secondary,
                      reducedMotion: reducedMotion,
                      subtitle: waterTests.isEmpty ? 'No logs yet' : 'Recorded tests',
                      onTap: () => context.go(AppRoutes.waterLab),
                    ),
                    MetricTile(
                      label: 'Open Tasks',
                      value: '${openTasks.length}',
                      icon: Icons.checklist_rounded,
                      accentColor: overdueTasksCount > 0
                          ? AquaColors.statusWarning
                          : AquaColors.statusHealthy,
                      reducedMotion: reducedMotion,
                      subtitle: '$overdueTasksCount overdue',
                      onTap: () => context.go(AppRoutes.tasks),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (aquariums.isEmpty)
              EmptyStateView(
                icon: Icons.add_box_rounded,
                title: 'Your Aquarium Database Is Ready',
                message:
                    'Foundation v0.1.0 includes the offline SQLite database, theme system, and navigation across all 12 ecosystem modules. Full tank creation and livestock editors arrive in ZIP Delivery 02 (v0.2.0).',
                actionLabel: 'Explore All Modules',
                reducedMotion: reducedMotion,
                onAction: () => context.go(AppRoutes.settings),
              )
            else
              GlassCard(
                reducedMotion: reducedMotion,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registered Aquariums (${aquariums.length})',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ...aquariums.take(5).map(
                          (tank) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.water_drop_rounded),
                            title: Text(tank.name),
                            subtitle: Text('${tank.waterType} • ${tank.category}'),
                            onTap: () => context.go(AppRoutes.aquariums),
                          ),
                        ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
