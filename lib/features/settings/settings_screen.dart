import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:aquaverse/core/widgets/glass_card.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeProfileProvider).valueOrNull;
    final strings = ref.watch(appStringsProvider);
    final reducedMotion = profile?.reducedMotion ?? false;
    final themeMode = profile?.themeMode ?? 'system';
    final accent = AccentOption.fromKey(profile?.accentColorKey);
    final localeCode = profile?.localeCode ?? 'en';
    final unitSystem = profile?.unitSystem ?? 'metric';
    final textScale = profile?.textScaleFactor ?? 1.0;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: strings.navSettings,
            subtitle: 'Appearance, accessibility, localization & offline backup',
          ),
          const SizedBox(height: 12),
          if (_statusMessage != null) ...[
            GlassCard(
              reducedMotion: reducedMotion,
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_statusMessage!)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          GlassCard(
            reducedMotion: reducedMotion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance & Theme',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'system', label: Text('System')),
                    ButtonSegment(value: 'light', label: Text('Light')),
                    ButtonSegment(value: 'dark', label: Text('Dark')),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (set) => ref
                      .read(appDatabaseProvider)
                      .updateProfilePreferences(themeMode: set.first),
                ),
                const SizedBox(height: 14),
                Text(
                  'Accent Palette',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AccentOption.values.map((opt) {
                    return ChoiceChip(
                      label: Text(opt.label),
                      selected: accent == opt,
                      onSelected: (_) => ref
                          .read(appDatabaseProvider)
                          .updateProfilePreferences(accentColorKey: opt.key),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            reducedMotion: reducedMotion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language, Units & Accessibility',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'en', label: Text('English')),
                    ButtonSegment(value: 'ur', label: Text('اردو (RTL)')),
                  ],
                  selected: {localeCode},
                  onSelectionChanged: (set) => ref
                      .read(appDatabaseProvider)
                      .updateProfilePreferences(localeCode: set.first),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'metric', label: Text('Metric')),
                    ButtonSegment(value: 'imperial', label: Text('Imperial')),
                  ],
                  selected: {unitSystem},
                  onSelectionChanged: (set) => ref
                      .read(appDatabaseProvider)
                      .updateProfilePreferences(unitSystem: set.first),
                ),
                const SizedBox(height: 12),
                Text('Text Scale: ${textScale.toStringAsFixed(2)}x'),
                Slider(
                  value: textScale.clamp(0.85, 1.35),
                  min: 0.85,
                  max: 1.35,
                  divisions: 10,
                  onChanged: (val) => ref
                      .read(appDatabaseProvider)
                      .updateProfilePreferences(textScaleFactor: val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Reduced Motion (Performance Mode)'),
                  subtitle: const Text('Disables backdrop blur & extra motion'),
                  value: reducedMotion,
                  onChanged: (val) => ref
                      .read(appDatabaseProvider)
                      .updateProfilePreferences(reducedMotion: val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            reducedMotion: reducedMotion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Backup & Restore',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Export a local JSON snapshot of your database records or restore from a JSON backup.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: _busy ? null : _exportBackup,
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Export JSON Backup'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _showRestoreDialog,
                      icon: const Icon(Icons.upload_file_rounded),
                      label: const Text('Restore from JSON'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportBackup() async {
    setState(() {
      _busy = true;
      _statusMessage = null;
    });
    try {
      final file =
          await ref.read(backupRestoreServiceProvider).exportJsonBackupFile();
      setState(() {
        _statusMessage = 'Backup saved to: ${file.path}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Backup error: $e';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showRestoreDialog() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore JSON Backup'),
        content: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Paste AquaVerse JSON backup payload here...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _busy = true;
        _statusMessage = null;
      });
      try {
        final count = await ref
            .read(backupRestoreServiceProvider)
            .restoreFromJsonString(controller.text);
        setState(() {
          _statusMessage = 'Restored $count aquarium record(s) from JSON.';
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'Restore failed: $e';
        });
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    }
    controller.dispose();
  }
}
