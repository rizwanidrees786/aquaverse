import 'package:aquaverse/core/database/app_database.dart';
import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:aquaverse/core/utils/unit_conversions.dart';
import 'package:aquaverse/core/widgets/empty_state_view.dart';
import 'package:aquaverse/core/widgets/glass_card.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:aquaverse/core/widgets/status_pill.dart';
import 'package:aquaverse/features/livestock/domain/species_catalog.dart';
import 'package:aquaverse/features/livestock/domain/stocking_intelligence.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class LivestockScreen extends ConsumerStatefulWidget {
  const LivestockScreen({super.key});

  @override
  ConsumerState<LivestockScreen> createState() => _LivestockScreenState();
}

class _LivestockScreenState extends ConsumerState<LivestockScreen> {
  String? _selectedAquariumId;
  String _speciesSearch = '';

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final reducedMotion =
        ref.watch(activeProfileProvider).valueOrNull?.reducedMotion ?? false;
    final aquariums = ref.watch(aquariumsStreamProvider).valueOrNull ?? const <Aquarium>[];
    final livestockList =
        ref.watch(livestockStreamProvider).valueOrNull ?? const <LivestockData>[];

    final effectiveTankId = _selectedAquariumId ??
        (aquariums.isNotEmpty ? aquariums.first.id : null);

    Aquarium? selectedTank;
    for (final t in aquariums) {
      if (t.id == effectiveTankId) {
        selectedTank = t;
        break;
      }
    }

    final tankLivestock = effectiveTankId == null
        ? livestockList
        : livestockList.where((l) => l.aquariumId == effectiveTankId).toList();

    final actualVolumeLiters = selectedTank == null
        ? 0.0
        : UnitConversions.actualWaterVolumeLiters(
            grossVolumeLiters: UnitConversions.rectangularGrossVolumeLiters(
              lengthCm: selectedTank.lengthCm,
              widthCm: selectedTank.widthCm,
              heightCm: selectedTank.heightCm,
            ),
            substrateDisplacementLiters: selectedTank.substrateDisplacementLiters,
            hardscapeDisplacementLiters: selectedTank.hardscapeDisplacementLiters,
          );

    final stockedForCalc = <(SpeciesProfile, int)>[];
    for (final entry in tankLivestock) {
      SpeciesProfile? match;
      for (final sp in BuiltInSpeciesCatalog.entries) {
        if (sp.id == entry.speciesId ||
            sp.commonName.toLowerCase() == entry.speciesCommonName.toLowerCase()) {
          match = sp;
          break;
        }
      }
      stockedForCalc.add((
        match ??
            SpeciesProfile(
              id: entry.id,
              commonName: entry.speciesCommonName,
              scientificName: 'Species entry',
              category: 'Custom',
              waterType: selectedTank?.waterType ?? 'freshwater',
              temperament: 'peaceful',
              minTankLiters: 20,
              recommendedTankLiters: 40,
              adultSizeCm: entry.sizeCm ?? 5.0,
              tempMinC: 20,
              tempMaxC: 28,
              phMin: 6.0,
              phMax: 7.8,
              minGroupSize: 1,
              bioloadScore: 1.2,
              careLevel: 'General',
              sourceReference: 'User livestock record',
              lastReviewed: '2026-11-23',
            ),
        entry.quantity,
      ));
    }

    final assessment = StockingIntelligenceEngine.evaluate(
      actualVolumeLiters: actualVolumeLiters,
      stockedItems: stockedForCalc,
    );

    final filteredSpecies = BuiltInSpeciesCatalog.entries.where((sp) {
      final q = _speciesSearch.trim().toLowerCase();
      if (q.isEmpty) return true;
      return sp.commonName.toLowerCase().contains(q) ||
          sp.scientificName.toLowerCase().contains(q) ||
          sp.category.toLowerCase().contains(q);
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: strings.navLivestock,
            subtitle: 'Livestock logs, species reference & stocking intelligence',
            actionLabel: aquariums.isEmpty ? null : '+ Add Livestock',
            onAction: aquariums.isEmpty
                ? null
                : () => _openAddLivestockSheet(
                      context,
                      aquariums: aquariums,
                      defaultAquariumId: effectiveTankId ?? aquariums.first.id,
                    ),
          ),
          const SizedBox(height: 12),
          if (aquariums.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              value: effectiveTankId,
              decoration: const InputDecoration(labelText: 'Select Aquarium'),
              items: aquariums
                  .map(
                    (t) => DropdownMenuItem(value: t.id, child: Text(t.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedAquariumId = v),
            ),
            const SizedBox(height: 12),
            GlassCard(
              reducedMotion: reducedMotion,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stocking Intelligence',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      StatusPill(
                        label: assessment.statusLabel,
                        color: assessment.utilizationPercent > 100
                            ? AquaColors.statusCritical
                            : AquaColors.statusHealthy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bioload: \${assessment.totalBioloadPoints.toStringAsFixed(1)} pts / \${assessment.capacityPoints.toStringAsFixed(1)} pts (\${assessment.utilizationPercent.toStringAsFixed(0)}%)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Confidence: \${assessment.confidenceLevel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  for (final w in assessment.warnings) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Warning: \$w',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AquaColors.statusCritical,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                  for (final n in assessment.notes) ...[
                    const SizedBox(height: 4),
                    Text(
                      n,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (tankLivestock.isEmpty)
            EmptyStateView(
              icon: Icons.set_meal_rounded,
              title: aquariums.isEmpty
                  ? 'Create an Aquarium First'
                  : 'No Livestock Logged Yet',
              message: aquariums.isEmpty
                  ? 'Add an aquarium in My Aquariums before logging fish, shrimp, or invertebrates.'
                  : 'Tap "+ Add Livestock" or choose a species from the catalog below to log stock.',
              reducedMotion: reducedMotion,
            )
          else ...[
            Text(
              'Logged Livestock (\${tankLivestock.length})',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...tankLivestock.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  reducedMotion: reducedMotion,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\${item.nameOrLabel} (\${item.speciesCommonName})',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Qty: \${item.quantity} • Health: \${item.healthStatus} • Quarantine: \${item.quarantineStatus}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete entry',
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () async {
                          final db = ref.read(appDatabaseProvider);
                          await (db.delete(db.livestock)
                                ..where((t) => t.id.equals(item.id)))
                              .go();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Reference Species Catalog',
            subtitle: 'Structured care ranges with cited references',
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search common name, scientific name, or group...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (v) => setState(() => _speciesSearch = v),
          ),
          const SizedBox(height: 10),
          ...filteredSpecies.map(
            (sp) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                reducedMotion: reducedMotion,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sp.commonName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        StatusPill(
                          label: sp.waterType.toUpperCase(),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    Text(
                      sp.scientificName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Min Tank: \${sp.minTankLiters.toStringAsFixed(0)} L • Temp: \${sp.tempMinC}–\${sp.tempMaxC}°C • pH: \${sp.phMin}–\${sp.phMax} • Min Group: \${sp.minGroupSize}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Source: \${sp.sourceReference} (Reviewed \${sp.lastReviewed})',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddLivestockSheet(
    BuildContext context, {
    required List<Aquarium> aquariums,
    required String defaultAquariumId,
  }) async {
    String selectedTankId = defaultAquariumId;
    String selectedSpeciesId = BuiltInSpeciesCatalog.entries.first.id;
    final labelCtrl = TextEditingController(text: 'Group');
    final qtyCtrl = TextEditingController(text: '6');
    String healthStatus = 'healthy';
    String quarantineStatus = 'none';
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Log Livestock',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedTankId,
                      decoration: const InputDecoration(labelText: 'Aquarium'),
                      items: aquariums
                          .map((t) =>
                              DropdownMenuItem(value: t.id, child: Text(t.name)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setSheetState(() => selectedTankId = v);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedSpeciesId,
                      decoration: const InputDecoration(labelText: 'Species'),
                      items: BuiltInSpeciesCatalog.entries
                          .map((sp) => DropdownMenuItem(
                                value: sp.id,
                                child: Text(sp.commonName),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setSheetState(() => selectedSpeciesId = v);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: labelCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nickname / Group Label *',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter a label' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity *'),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n <= 0) return 'Enter quantity >= 1';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: healthStatus,
                            decoration: const InputDecoration(labelText: 'Health'),
                            items: const [
                              DropdownMenuItem(value: 'healthy', child: Text('Healthy')),
                              DropdownMenuItem(value: 'monitoring', child: Text('Monitoring')),
                              DropdownMenuItem(value: 'ill', child: Text('Ill / Treating')),
                            ],
                            onChanged: (v) {
                              if (v != null) setSheetState(() => healthStatus = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: quarantineStatus,
                            decoration: const InputDecoration(labelText: 'Quarantine'),
                            items: const [
                              DropdownMenuItem(value: 'none', child: Text('Main Tank')),
                              DropdownMenuItem(value: 'quarantine', child: Text('Quarantine')),
                              DropdownMenuItem(value: 'hospital', child: Text('Hospital')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setSheetState(() => quarantineStatus = v);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        if (formKey.currentState?.validate() == true) {
                          Navigator.of(sheetCtx).pop(true);
                        }
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save Livestock'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true && mounted) {
      final sp = BuiltInSpeciesCatalog.entries.firstWhere(
        (item) => item.id == selectedSpeciesId,
        orElse: () => BuiltInSpeciesCatalog.entries.first,
      );
      final qty = int.tryParse(qtyCtrl.text) ?? 1;
      final db = ref.read(appDatabaseProvider);
      await db.into(db.livestock).insert(
            LivestockCompanion.insert(
              id: const Uuid().v4(),
              aquariumId: selectedTankId,
              speciesId: Value(sp.id),
              nameOrLabel: labelCtrl.text.trim(),
              speciesCommonName: sp.commonName,
              quantity: Value(qty),
              healthStatus: Value(healthStatus),
              quarantineStatus: Value(quarantineStatus),
              sizeCm: Value(sp.adultSizeCm),
              acquiredAt: DateTime.now(),
            ),
          );
    }

    labelCtrl.dispose();
    qtyCtrl.dispose();
  }
}
