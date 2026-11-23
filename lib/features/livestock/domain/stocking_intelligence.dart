import 'package:aquaverse/features/livestock/domain/species_catalog.dart';

class StockingAssessment {
  const StockingAssessment({
    required this.actualVolumeLiters,
    required this.totalBioloadPoints,
    required this.capacityPoints,
    required this.utilizationPercent,
    required this.statusLabel,
    required this.confidenceLevel,
    required this.warnings,
    required this.notes,
  });

  final double actualVolumeLiters;
  final double totalBioloadPoints;
  final double capacityPoints;
  final double utilizationPercent;
  final String statusLabel;
  final String confidenceLevel;
  final List<String> warnings;
  final List<String> notes;
}

class StockingIntelligenceEngine {
  /// Multi-factor stocking assessment (does NOT rely on the 1-inch-per-gallon rule).
  static StockingAssessment evaluate({
    required double actualVolumeLiters,
    required List<(SpeciesProfile species, int quantity)> stockedItems,
    double filtrationTurnoverMultiplier = 1.0,
    bool hasExtraAeration = false,
  }) {
    final safeVolume = actualVolumeLiters < 0 ? 0.0 : actualVolumeLiters;
    double rawBioload = 0;
    final warnings = <String>[];
    final notes = <String>[
      'Evaluated using net water volume, species bioload weights, schooling group minimums, and filtration factor (not the outdated 1-inch-per-gallon rule).',
    ];

    for (final (species, qty) in stockedItems) {
      if (qty <= 0) continue;
      rawBioload += species.bioloadScore * qty;

      if (safeVolume < species.minTankLiters) {
        warnings.add(
          '\${species.commonName} prefers at least \${species.minTankLiters.toStringAsFixed(0)} L (current net: \${safeVolume.toStringAsFixed(0)} L).',
        );
      }
      if (species.minGroupSize > 1 && qty < species.minGroupSize) {
        warnings.add(
          '\${species.commonName} is a schooling/group species; recommended minimum group is \${species.minGroupSize} (current: \$qty).',
        );
      }
      if (species.temperament != 'peaceful') {
        notes.add(
          '\${species.commonName} has \${species.temperament} temperament — monitor tankmates and territory space.',
        );
      }
    }

    final aerationBonus = hasExtraAeration ? 1.12 : 1.0;
    final capacityPoints = (safeVolume / 10.0) *
        filtrationTurnoverMultiplier.clamp(0.6, 1.8) *
        aerationBonus;

    final utilizationPercent = capacityPoints <= 0
        ? (rawBioload > 0 ? 999.0 : 0.0)
        : (rawBioload / capacityPoints) * 100.0;

    final String statusLabel;
    if (utilizationPercent == 0) {
      statusLabel = 'Unstocked';
    } else if (utilizationPercent <= 75) {
      statusLabel = 'Balanced Stocking';
    } else if (utilizationPercent <= 100) {
      statusLabel = 'Near Capacity';
    } else {
      statusLabel = 'Overstocked / High Bioload';
      warnings.add(
        'Estimated bioload (\${rawBioload.toStringAsFixed(1)} pts) exceeds estimated system capacity (\${capacityPoints.toStringAsFixed(1)} pts). Increase filtration, aeration, or water changes.',
      );
    }

    final confidenceLevel = stockedItems.isEmpty
        ? 'Low (No livestock logged)'
        : 'Moderate (Model estimate — verify with ammonia, nitrite & nitrate tests)';

    return StockingAssessment(
      actualVolumeLiters: safeVolume,
      totalBioloadPoints: rawBioload,
      capacityPoints: capacityPoints,
      utilizationPercent: utilizationPercent,
      statusLabel: statusLabel,
      confidenceLevel: confidenceLevel,
      warnings: warnings,
      notes: notes,
    );
  }
}
