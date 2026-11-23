import 'package:aquaverse/core/localization/app_strings.dart';
import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/features/ai_assistant/ai_assistant_screen.dart';
import 'package:aquaverse/features/aquariums/aquariums_screen.dart';
import 'package:aquaverse/features/business/business_screen.dart';
import 'package:aquaverse/features/dashboard/dashboard_screen.dart';
import 'package:aquaverse/features/insights/insights_screen.dart';
import 'package:aquaverse/features/inventory/inventory_screen.dart';
import 'package:aquaverse/features/knowledge/knowledge_screen.dart';
import 'package:aquaverse/features/livestock/livestock_screen.dart';
import 'package:aquaverse/features/marketplace/marketplace_screen.dart';
import 'package:aquaverse/features/onboarding/onboarding_screen.dart';
import 'package:aquaverse/features/settings/settings_screen.dart';
import 'package:aquaverse/features/tasks/tasks_screen.dart';
import 'package:aquaverse/features/water_lab/water_lab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const home = '/home';
  static const aquariums = '/aquariums';
  static const livestock = '/livestock';
  static const waterLab = '/water-lab';
  static const tasks = '/tasks';
  static const insights = '/insights';
  static const aiAssistant = '/ai-assistant';
  static const knowledge = '/knowledge';
  static const inventory = '/inventory';
  static const marketplace = '/marketplace';
  static const business = '/business';
  static const settings = '/settings';
  static const onboarding = '/onboarding';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShellScaffold(
          location: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.aquariums,
            builder: (context, state) => const AquariumsScreen(),
          ),
          GoRoute(
            path: AppRoutes.livestock,
            builder: (context, state) => const LivestockScreen(),
          ),
          GoRoute(
            path: AppRoutes.waterLab,
            builder: (context, state) => const WaterLabScreen(),
          ),
          GoRoute(
            path: AppRoutes.tasks,
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: AppRoutes.insights,
            builder: (context, state) => const InsightsScreen(),
          ),
          GoRoute(
            path: AppRoutes.aiAssistant,
            builder: (context, state) => const AiAssistantScreen(),
          ),
          GoRoute(
            path: AppRoutes.knowledge,
            builder: (context, state) => const KnowledgeScreen(),
          ),
          GoRoute(
            path: AppRoutes.inventory,
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.marketplace,
            builder: (context, state) => const MarketplaceScreen(),
          ),
          GoRoute(
            path: AppRoutes.business,
            builder: (context, state) => const BusinessScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class _NavItem {
  const _NavItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class MainShellScaffold extends ConsumerWidget {
  const MainShellScaffold({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  List<_NavItem> _primaryItems(AppStrings strings) => [
        _NavItem(
          route: AppRoutes.home,
          label: strings.navHome,
          icon: Icons.water_drop_outlined,
          selectedIcon: Icons.water_drop_rounded,
        ),
        _NavItem(
          route: AppRoutes.aquariums,
          label: strings.navAquariums,
          icon: Icons.view_in_ar_outlined,
          selectedIcon: Icons.view_in_ar_rounded,
        ),
        _NavItem(
          route: AppRoutes.livestock,
          label: strings.navLivestock,
          icon: Icons.set_meal_outlined,
          selectedIcon: Icons.set_meal_rounded,
        ),
        _NavItem(
          route: AppRoutes.waterLab,
          label: strings.navWaterLab,
          icon: Icons.science_outlined,
          selectedIcon: Icons.science_rounded,
        ),
        _NavItem(
          route: AppRoutes.tasks,
          label: strings.navTasks,
          icon: Icons.checklist_outlined,
          selectedIcon: Icons.checklist_rounded,
        ),
      ];

  List<_NavItem> _secondaryItems(AppStrings strings) => [
        _NavItem(
          route: AppRoutes.insights,
          label: strings.navInsights,
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics_rounded,
        ),
        _NavItem(
          route: AppRoutes.aiAssistant,
          label: strings.navAi,
          icon: Icons.auto_awesome_outlined,
          selectedIcon: Icons.auto_awesome_rounded,
        ),
        _NavItem(
          route: AppRoutes.knowledge,
          label: strings.navKnowledge,
          icon: Icons.menu_book_outlined,
          selectedIcon: Icons.menu_book_rounded,
        ),
        _NavItem(
          route: AppRoutes.inventory,
          label: strings.navInventory,
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2_rounded,
        ),
        _NavItem(
          route: AppRoutes.marketplace,
          label: strings.navMarketplace,
          icon: Icons.storefront_outlined,
          selectedIcon: Icons.storefront_rounded,
        ),
        _NavItem(
          route: AppRoutes.business,
          label: strings.navBusiness,
          icon: Icons.business_center_outlined,
          selectedIcon: Icons.business_center_rounded,
        ),
        _NavItem(
          route: AppRoutes.settings,
          label: strings.navSettings,
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings_rounded,
        ),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final primary = _primaryItems(strings);
    final secondary = _secondaryItems(strings);
    final allItems = [...primary, ...secondary];

    final activeIndex = allItems.indexWhere((item) => item.route == location);
    final currentPrimaryIndex = primary.indexWhere((item) => item.route == location);
    final isWide = MediaQuery.sizeOf(context).width >= 840;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: activeIndex < 0 ? 0 : activeIndex,
              onDestinationSelected: (idx) => context.go(allItems[idx].route),
              labelType: NavigationRailLabelType.all,
              destinations: allItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPrimaryIndex < 0 ? 0 : currentPrimaryIndex,
        onDestinationSelected: (idx) {
          context.go(primary[idx].route);
        },
        destinations: [
          ...primary.map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        tooltip: strings.moreModules,
        onPressed: () => _openMoreModulesSheet(context, secondary, strings),
        child: const Icon(Icons.apps_rounded),
      ),
    );
  }

  void _openMoreModulesSheet(
    BuildContext context,
    List<_NavItem> secondary,
    AppStrings strings,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.moreModules,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: secondary.map((item) {
                    final isCurrent = item.route == location;
                    return ActionChip(
                      avatar: Icon(
                        isCurrent ? item.selectedIcon : item.icon,
                        size: 18,
                      ),
                      label: Text(item.label),
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        context.go(item.route);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
