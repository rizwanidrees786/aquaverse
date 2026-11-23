import 'package:aquaverse/core/database/app_database.dart';
import 'package:aquaverse/core/providers/app_providers.dart';
import 'package:aquaverse/core/theme/app_theme.dart';
import 'package:aquaverse/core/utils/unit_conversions.dart';
import 'package:aquaverse/core/widgets/empty_state_view.dart';
import 'package:aquaverse/core/widgets/glass_card.dart';
import 'package:aquaverse/core/widgets/section_header.dart';
import 'package:aquaverse/core/widgets/status_pill.dart';
import 'package:aquaverse/features/water_lab/domain/water_chemistry_calculators.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class WaterLabScreen extends ConsumerStatefulWidget {
  const WaterLabScreen({super.key});

  @override
  ConsumerState<WaterLabScreen> createState() => _WaterLabScreenState();
}

class _WaterLabScreenState extends ConsumerState<WaterLabScreen> {
  String? _selectedAquariumId;
  double _wcPercent = 25;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final profile = ref.watch(activeProfileProvider).valueOrNull;
    final reducedMotion = profile?.reducedMotion ?? false;
    final isImperial = profile?.unitSystem == 'imperial';
    final aquariums = ref.watch(aquariumsStreamProvider).valueOrNull ?? const <Aquarium>[];
    final allTests = ref.watch(waterTestsStreamProvider).valueOrNull ?? const <WaterTest>[];

    final effectiveTankId =
        _selectedAquariumId ?? (aquariums.isNotEmpty ? aquariums.first.id : null);

    Aquarium? selectedTank;
    for (final t in aquariums) {
      if (t.id == effectiveTankId) {
        selectedTank = t;
        break;
      }
    }

    final tankTests = effectiveTankId == null
        ? allTests
        : allTests.where((w) => w.aquariumId == effectiveTankId).toList();

    final latestTest = tankTests.isNotEmpty ? tankTests.first : null;

    final actualVolumeLiters = selectedTank == null
        ? 60.0
        : UnitConversions.actualWaterVolumeLiters(
            grossVolumeLiters: UnitConversions.rectangularGrossVolumeLiters(
              lengthCm: selectedTank.lengthCm,
              widthCm: selectedTank.widthCm,
              heightCm: selectedTank.heightCm,
            ),
            substrateDisplacementLiters: selectedTank.substrateDisplacementLiters,
            hardscapeDisplacementLiters: selectedTank.hardscapeDisplacementLiters,
          );

    final wcPlan = WaterChemistryCalculators.calculateWaterChange(
      actualVolumeLiters: actualVolumeLiters,
      changePercent: _wcPercent,
      currentNitratePpm: latestTest?.nitratePpm,
      isSaltwater: selectedTank?.waterType == 'saltwater',
    );

    final cycling = WaterChemistryCalculators.assessCycling(
      ammoniaPpm: latestTest?.ammoniaPpm,
      nitritePpm: latestTest?.nitritePpm,
      nitratePpm: latestTest?.nitratePpm,
    );

    AmmoniaToxicityResult? nh3Toxicity;
    if (latestTest?.ammoniaPpm != null &&
        latestTest?.ph != null &&
        latestTest?.temperatureC != null) {
      nh3Toxicity = WaterChemistryCalculators.estimateUnIonizedAmmonia(
        totalAmmoniaPpm: latestTest!.ammoniaPpm!,
        ph: latestTest.ph!,
        temperatureC: latestTest.temperatureC!,
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: strings.navWaterLab,
            subtitle: 'Water test logs, nitrogen cycle evidence & chemistry calculators',
            actionLabel: aquariums.isEmpty ? null : '+ Log Test',
            onAction: aquariums.isEmpty
                ? null
                : () => _openWaterTestSheet(
                      context,
                      aquariums: aquariums,
                      defaultAquariumId: effectiveTankId ?? aquariums.first.id,
                      isImperial: isImperial,
                    ),
          ),
          const SizedBox(height: 12),
          if (aquariums.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              value: effectiveTankId,
              decoration: const InputDecoration(labelText: 'Aquarium'),
              items: aquariums
                  .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedAquariumId = v),
            ),
            const SizedBox(height: 12),
          ],
          GlassCard(
            reducedMotion: reducedMotion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nitrogen Cycle Status',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    StatusPill(
                      label: cycling.isEvidenceCycled ? 'CYCLED' : 'MONITOR',
                      color: cycling.isEvidenceCycled
                          ? AquaColors.statusHealthy
                          : AquaColors.statusWarning,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  cycling.stageLabel,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                for (final r in cycling.reasons) ...[
                  const SizedBox(height: 4),
                  Text(r, style: Theme.of(context).textTheme.bodySmall),
                ],
                for (final s in cycling.nextSteps) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Next: $s',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
                if (nh3Toxicity != null) ...[
                  const Divider(height: 18),
                  Text(
                    'Un-ionized NH3 Estimate: ${nh3Toxicity.estimatedUnIonizedNh3Ppm.toStringAsFixed(4)} ppm (${nh3Toxicity.riskLevel})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: nh3Toxicity.riskLevel.startsWith('CRITICAL')
                              ? AquaColors.statusCritical
                              : AquaColors.statusWarning,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nh3Toxicity.guidance,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
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
                  'Water-Change Calculator',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text('Target Water Change: ${_wcPercent.toStringAsFixed(0)}%'),
                Slider(
                  value: _wcPercent,
                  min: 5,
                  max: 75,
                  divisions: 14,
                  onChanged: (v) => setState(() => _wcPercent = v),
                ),
                Text(
                  'Remove & Replace: ${wcPlan.removeVolumeLiters.toStringAsFixed(1)} L'
                  '${isImperial ? ' (${UnitConversions.fromLiters(wcPlan.removeVolumeLiters, VolumeUnit.usGallons).toStringAsFixed(1)} gal)' : ''}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (wcPlan.estimatedResultingNitratePpm != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Estimated Post-Change Nitrate (0 ppm replacement): ${wcPlan.estimatedResultingNitratePpm!.toStringAsFixed(1)} ppm',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  wcPlan.formulaExplanation,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                for (final note in wcPlan.safetyNotes) ...[
                  const SizedBox(height: 4),
                  Text('• $note', style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Recorded Water Tests (${tankTests.length})',
            subtitle: 'Actual logged readings from local SQLite',
          ),
          const SizedBox(height: 8),
          if (tankTests.isEmpty)
            EmptyStateView(
              icon: Icons.science_rounded,
              title: 'No Water Tests Recorded Yet',
              message: aquariums.isEmpty
                  ? 'Add an aquarium first, then record your manual test kit readings.'
                  : 'Tap "+ Log Test" to record temperature, pH, ammonia, nitrite, and nitrate.',
              reducedMotion: reducedMotion,
            )
          else
            ...tankTests.map((t) {
              final tempDisplay = t.temperatureC == null
                  ? '--'
                  : (isImperial
                      ? '${UnitConversions.celsiusToFahrenheit(t.temperatureC!).toStringAsFixed(1)}°F'
                      : '${t.temperatureC!.toStringAsFixed(1)}°C');
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  reducedMotion: reducedMotion,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temp: $tempDisplay • pH: ${t.ph?.toStringAsFixed(1) ?? '--'}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NH3: ${t.ammoniaPpm?.toStringAsFixed(2) ?? '--'} ppm • NO2: ${t.nitritePpm?.toStringAsFixed(2) ?? '--'} ppm • NO3: ${t.nitratePpm?.toStringAsFixed(1) ?? '--'} ppm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (t.notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(t.notes, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _openWaterTestSheet(
    BuildContext context, {
    required List<Aquarium> aquariums,
    required String defaultAquariumId,
    required bool isImperial,
  }) async {
    String tankId = defaultAquariumId;
    final tempCtrl = TextEditingController(text: isImperial ? '77.0' : '25.0');
    final phCtrl = TextEditingController(text: '7.0');
    final nh3Ctrl = TextEditingController(text: '0');
    final no2Ctrl = TextEditingController(text: '0');
    final no3Ctrl = TextEditingController(text: '10');
    final notesCtrl = TextEditingController();

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Record Water Test',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: tankId,
                      decoration: const InputDecoration(labelText: 'Aquarium'),
                      items: aquariums
                          .map((t) =>
                              DropdownMenuItem(value: t.id, child: Text(t.name)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setSheetState(() => tankId = v);
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tempCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: isImperial ? 'Temp (°F)' : 'Temp (°C)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: phCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'pH'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nh3Ctrl,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Ammonia (ppm)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: no2Ctrl,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Nitrite (ppm)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: no3Ctrl,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Nitrate (ppm)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(sheetCtx).pop(true),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save Test'),
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
      final rawTemp = double.tryParse(tempCtrl.text);
      final tempC = rawTemp == null
          ? null
          : (isImperial ? UnitConversions.fahrenheitToCelsius(rawTemp) : rawTemp);
      final db = ref.read(appDatabaseProvider);
      await db.into(db.waterTests).insert(
            WaterTestsCompanion.insert(
              id: const Uuid().v4(),
              aquariumId: tankId,
              temperatureC: Value(tempC),
              ph: Value(double.tryParse(phCtrl.text)),
              ammoniaPpm: Value(double.tryParse(nh3Ctrl.text)),
              nitritePpm: Value(double.tryParse(no2Ctrl.text)),
              nitratePpm: Value(double.tryParse(no3Ctrl.text)),
              notes: Value(notesCtrl.text.trim()),
              testedAt: DateTime.now(),
            ),
          );
    }

    tempCtrl.dispose();
    phCtrl.dispose();
    nh3Ctrl.dispose();
    no2Ctrl.dispose();
    no3Ctrl.dispose();
    notesCtrl.dispose();
  }
}
