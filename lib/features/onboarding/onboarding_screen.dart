import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/router/app_router.dart';
import 'package:aquaverse/core/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _selectedLevel = 'beginner';
  String _selectedUnits = 'metric';
  String _selectedLocale = 'en';
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(activeProfileProvider).valueOrNull;
    final reducedMotion = profile?.reducedMotion ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to AquaVerse'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _completeOnboarding,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GlassCard(
              reducedMotion: reducedMotion,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.waves_rounded, color: theme.colorScheme.primary, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Complete Aquarium Management Ecosystem',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Offline-first aquarium profiles, water testing, livestock tracking, maintenance reminders, and business tools — tailored to how you keep aquatic life.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '1. Experience & Workflow Focus',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Beginner Aquarist'),
                  selected: _selectedLevel == 'beginner',
                  onSelected: (_) => setState(() => _selectedLevel = 'beginner'),
                ),
                ChoiceChip(
                  label: const Text('Planted & Aquascaping'),
                  selected: _selectedLevel == 'planted',
                  onSelected: (_) => setState(() => _selectedLevel = 'planted'),
                ),
                ChoiceChip(
                  label: const Text('Marine & Reef'),
                  selected: _selectedLevel == 'marine',
                  onSelected: (_) => setState(() => _selectedLevel = 'marine'),
                ),
                ChoiceChip(
                  label: const Text('Breeder / Business'),
                  selected: _selectedLevel == 'business',
                  onSelected: (_) => setState(() => _selectedLevel = 'business'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '2. Measurement Units',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'metric', label: Text('Metric (°C, L, cm)')),
                ButtonSegment(value: 'imperial', label: Text('Imperial (°F, gal, in)')),
              ],
              selected: {_selectedUnits},
              onSelectionChanged: (set) => setState(() => _selectedUnits = set.first),
            ),
            const SizedBox(height: 20),
            Text(
              '3. Language / زبان',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'en', label: Text('English')),
                ButtonSegment(value: 'ur', label: Text('اردو (Urdu)')),
              ],
              selected: {_selectedLocale},
              onSelectionChanged: (set) => setState(() => _selectedLocale = set.first),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _saving ? null : _completeOnboarding,
              icon: const Icon(Icons.check_circle_rounded),
              label: Text(_saving ? 'Saving...' : 'Enter AquaVerse'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    setState(() => _saving = true);
    try {
      await ref.read(appDatabaseProvider).updateProfilePreferences(
            experienceLevel: _selectedLevel,
            unitSystem: _selectedUnits,
            localeCode: _selectedLocale,
            onboardingCompleted: true,
          );
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
