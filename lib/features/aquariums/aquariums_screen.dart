import 'package:aquaverse/core/database/app_database.dart';
import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:aquaverse/core/utils/unit_conversions.dart';
import 'package:aquaverse/core/widgets/empty_state_view.dart';
import 'package:aquaverse/core/widgets/glass_card.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:aquaverse/core/widgets/status_pill.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AquariumsScreen extends ConsumerStatefulWidget {
  const AquariumsScreen({super.key});

  @override
  ConsumerState<AquariumsScreen> createState() => _AquariumsScreenState();
}

class _AquariumsScreenState extends ConsumerState<AquariumsScreen> {
  String _waterFilter = 'all';
  String _searchQuery = '';
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final profile = ref.watch(activeProfileProvider).valueOrNull;
    final reducedMotion = profile?.reducedMotion ?? false;
    final isImperial = profile?.unitSystem == 'imperial';
    final db = ref.watch(appDatabaseProvider);

    return SafeArea(
      child: StreamBuilder<List<Aquarium>>(
        stream: db.watchAquariums(includeArchived: _showArchived),
        builder: (context, snapshot) {
          final allTanks = snapshot.data ?? const <Aquarium>[];
          final filtered = allTanks.where((tank) {
            final matchesWater =
                _waterFilter == 'all' || tank.waterType == _waterFilter;
            final q = _searchQuery.trim().toLowerCase();
            final matchesQuery = q.isEmpty ||
                tank.name.toLowerCase().contains(q) ||
                tank.location.toLowerCase().contains(q) ||
                tank.category.toLowerCase().contains(q);
            return matchesWater && matchesQuery;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionHeader(
                title: strings.navAquariums,
                subtitle:
                    'Multi-tank profiles, net water capacity & cloning (\${filtered.length})',
                actionLabel: '+ New Tank',
                onAction: () => _openAquariumForm(context, isImperial: isImperial),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by tank name, category, or room...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final entry in const [
                      ('all', 'All Water'),
                      ('freshwater', 'Freshwater'),
                      ('saltwater', 'Saltwater'),
                      ('brackish', 'Brackish'),
                    ]) ...[
                      ChoiceChip(
                        label: Text(entry.$2),
                        selected: _waterFilter == entry.$1,
                        onSelected: (_) => setState(() => _waterFilter = entry.$1),
                      ),
                      const SizedBox(width: 8),
                    ],
                    FilterChip(
                      label: const Text('Include Archived'),
                      selected: _showArchived,
                      onSelected: (v) => setState(() => _showArchived = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (filtered.isEmpty)
                EmptyStateView(
                  icon: Icons.view_in_ar_rounded,
                  title: 'No Aquariums Match Your Filter',
                  message:
                      'Create your first aquarium profile with dimensions, substrate/hardscape displacement, and category.',
                  actionLabel: 'Create Aquarium',
                  reducedMotion: reducedMotion,
                  onAction: () => _openAquariumForm(context, isImperial: isImperial),
                )
              else
                ...filtered.map((tank) {
                  final grossL = UnitConversions.rectangularGrossVolumeLiters(
                    lengthCm: tank.lengthCm,
                    widthCm: tank.widthCm,
                    heightCm: tank.heightCm,
                  );
                  final actualL = UnitConversions.actualWaterVolumeLiters(
                    grossVolumeLiters: grossL,
                    substrateDisplacementLiters: tank.substrateDisplacementLiters,
                    hardscapeDisplacementLiters: tank.hardscapeDisplacementLiters,
                  );

                  final volText = isImperial
                      ? '\${UnitConversions.fromLiters(actualL, VolumeUnit.usGallons).toStringAsFixed(1)} gal net (\${UnitConversions.fromLiters(grossL, VolumeUnit.usGallons).toStringAsFixed(1)} gal gross)'
                      : '\${actualL.toStringAsFixed(1)} L net (\${grossL.toStringAsFixed(1)} L gross)';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      reducedMotion: reducedMotion,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tank.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              StatusPill(
                                label: tank.isArchived
                                    ? 'ARCHIVED'
                                    : tank.waterType.toUpperCase(),
                                color: tank.isArchived
                                    ? AquaColors.statusWarning
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\${tank.category} • \${tank.temperatureClass} • \${tank.location}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Capacity: \$volText',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (tank.notes.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              tank.notes,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton.icon(
                                onPressed: () => _openAquariumForm(
                                  context,
                                  existing: tank,
                                  isImperial: isImperial,
                                ),
                                icon: const Icon(Icons.edit_rounded, size: 18),
                                label: const Text('Edit'),
                              ),
                              TextButton.icon(
                                onPressed: () => _cloneTank(tank),
                                icon: const Icon(Icons.copy_rounded, size: 18),
                                label: const Text('Clone'),
                              ),
                              TextButton.icon(
                                onPressed: () => _toggleArchive(tank),
                                icon: Icon(
                                  tank.isArchived
                                      ? Icons.unarchive_rounded
                                      : Icons.archive_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  tank.isArchived ? 'Restore' : 'Archive',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Future<void> _cloneTank(Aquarium tank) async {
    final now = DateTime.now();
    await ref.read(appDatabaseProvider).into(ref.read(appDatabaseProvider).aquariums).insert(
          AquariumsCompanion.insert(
            id: const Uuid().v4(),
            profileId: Value(tank.profileId),
            name: '\${tank.name} (Copy)',
            category: Value(tank.category),
            waterType: Value(tank.waterType),
            temperatureClass: Value(tank.temperatureClass),
            lengthCm: Value(tank.lengthCm),
            widthCm: Value(tank.widthCm),
            heightCm: Value(tank.heightCm),
            substrateDisplacementLiters: Value(tank.substrateDisplacementLiters),
            hardscapeDisplacementLiters: Value(tank.hardscapeDisplacementLiters),
            glassThicknessMm: Value(tank.glassThicknessMm),
            location: Value(tank.location),
            status: Value(tank.status),
            setupDate: now,
            notes: Value(tank.notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> _toggleArchive(Aquarium tank) async {
    final db = ref.read(appDatabaseProvider);
    await (db.update(db.aquariums)..where((t) => t.id.equals(tank.id))).write(
      AquariumsCompanion(
        isArchived: Value(!tank.isArchived),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _openAquariumForm(
    BuildContext context, {
    Aquarium? existing,
    required bool isImperial,
  }) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final locationCtrl = TextEditingController(text: existing?.location ?? 'Living Room');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');

    final initLength = existing == null
        ? (isImperial ? 24.0 : 60.0)
        : (isImperial
            ? UnitConversions.fromCentimeters(existing.lengthCm, LengthUnit.inches)
            : existing.lengthCm);
    final initWidth = existing == null
        ? (isImperial ? 12.0 : 30.0)
        : (isImperial
            ? UnitConversions.fromCentimeters(existing.widthCm, LengthUnit.inches)
            : existing.widthCm);
    final initHeight = existing == null
        ? (isImperial ? 14.0 : 36.0)
        : (isImperial
            ? UnitConversions.fromCentimeters(existing.heightCm, LengthUnit.inches)
            : existing.heightCm);

    final lengthCtrl = TextEditingController(text: initLength.toStringAsFixed(1));
    final widthCtrl = TextEditingController(text: initWidth.toStringAsFixed(1));
    final heightCtrl = TextEditingController(text: initHeight.toStringAsFixed(1));
    final subCtrl = TextEditingController(
      text: (existing?.substrateDisplacementLiters ?? 4.0).toStringAsFixed(1),
    );
    final hardCtrl = TextEditingController(
      text: (existing?.hardscapeDisplacementLiters ?? 2.0).toStringAsFixed(1),
    );

    String waterType = existing?.waterType ?? 'freshwater';
    String temperatureClass = existing?.temperatureClass ?? 'tropical';
    String category = existing?.category ?? 'community';
    final formKey = GlobalKey<FormState>();

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        existing == null ? 'New Aquarium Profile' : 'Edit Aquarium',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Aquarium Name *'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: waterType,
                        decoration: const InputDecoration(labelText: 'Water Type'),
                        items: const [
                          DropdownMenuItem(value: 'freshwater', child: Text('Freshwater')),
                          DropdownMenuItem(value: 'saltwater', child: Text('Saltwater / Reef')),
                          DropdownMenuItem(value: 'brackish', child: Text('Brackish')),
                        ],
                        onChanged: (v) {
                          if (v != null) setSheetState(() => waterType = v);
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: temperatureClass,
                        decoration: const InputDecoration(labelText: 'Temperature Class'),
                        items: const [
                          DropdownMenuItem(value: 'tropical', child: Text('Tropical')),
                          DropdownMenuItem(value: 'coldwater', child: Text('Coldwater')),
                          DropdownMenuItem(value: 'temperate', child: Text('Temperate')),
                        ],
                        onChanged: (v) {
                          if (v != null) setSheetState(() => temperatureClass = v);
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: category,
                        decoration: const InputDecoration(labelText: 'Aquarium Category'),
                        items: const [
                          DropdownMenuItem(value: 'community', child: Text('Community')),
                          DropdownMenuItem(value: 'planted', child: Text('Planted / Aquascape')),
                          DropdownMenuItem(value: 'reef', child: Text('Reef System')),
                          DropdownMenuItem(value: 'breeding', child: Text('Breeding Tank')),
                          DropdownMenuItem(value: 'quarantine', child: Text('Quarantine / Hospital')),
                          DropdownMenuItem(value: 'pond', child: Text('Pond / Outdoor')),
                        ],
                        onChanged: (v) {
                          if (v != null) setSheetState(() => category = v);
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: lengthCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: isImperial ? 'Length (in)' : 'Length (cm)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: widthCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: isImperial ? 'Width (in)' : 'Width (cm)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: heightCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: isImperial ? 'Height (in)' : 'Height (cm)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: subCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Substrate Displ. (L)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: hardCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Hardscape Displ. (L)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: locationCtrl,
                        decoration: const InputDecoration(labelText: 'Location / Room'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: notesCtrl,
                        decoration: const InputDecoration(labelText: 'Notes'),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            Navigator.of(sheetCtx).pop(true);
                          }
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save Aquarium'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true && mounted) {
      final rawL = double.tryParse(lengthCtrl.text) ?? (isImperial ? 24.0 : 60.0);
      final rawW = double.tryParse(widthCtrl.text) ?? (isImperial ? 12.0 : 30.0);
      final rawH = double.tryParse(heightCtrl.text) ?? (isImperial ? 14.0 : 36.0);

      final lengthCm = isImperial
          ? UnitConversions.toCentimeters(rawL, LengthUnit.inches)
          : rawL;
      final widthCm = isImperial
          ? UnitConversions.toCentimeters(rawW, LengthUnit.inches)
          : rawW;
      final heightCm = isImperial
          ? UnitConversions.toCentimeters(rawH, LengthUnit.inches)
          : rawH;

      final subL = double.tryParse(subCtrl.text) ?? 4.0;
      final hardL = double.tryParse(hardCtrl.text) ?? 2.0;
      final now = DateTime.now();
      final db = ref.read(appDatabaseProvider);

      if (existing == null) {
        await db.into(db.aquariums).insert(
              AquariumsCompanion.insert(
                id: const Uuid().v4(),
                profileId: const Value('default_profile'),
                name: nameCtrl.text.trim(),
                category: Value(category),
                waterType: Value(waterType),
                temperatureClass: Value(temperatureClass),
                lengthCm: Value(lengthCm),
                widthCm: Value(widthCm),
                heightCm: Value(heightCm),
                substrateDisplacementLiters: Value(subL),
                hardscapeDisplacementLiters: Value(hardL),
                location: Value(locationCtrl.text.trim().isEmpty
                    ? 'Living Room'
                    : locationCtrl.text.trim()),
                setupDate: now,
                notes: Value(notesCtrl.text.trim()),
                createdAt: now,
                updatedAt: now,
              ),
            );
      } else {
        await (db.update(db.aquariums)..where((t) => t.id.equals(existing.id))).write(
          AquariumsCompanion(
            name: Value(nameCtrl.text.trim()),
            category: Value(category),
            waterType: Value(waterType),
            temperatureClass: Value(temperatureClass),
            lengthCm: Value(lengthCm),
            widthCm: Value(widthCm),
            heightCm: Value(heightCm),
            substrateDisplacementLiters: Value(subL),
            hardscapeDisplacementLiters: Value(hardL),
            location: Value(locationCtrl.text.trim()),
            notes: Value(notesCtrl.text.trim()),
            updatedAt: Value(now),
          ),
        );
      }
    }

    nameCtrl.dispose();
    locationCtrl.dispose();
    notesCtrl.dispose();
    lengthCtrl.dispose();
    widthCtrl.dispose();
    heightCtrl.dispose();
    subCtrl.dispose();
    hardCtrl.dispose();
  }
}
