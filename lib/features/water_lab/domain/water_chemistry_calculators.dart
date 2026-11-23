import 'dart:math' as math;

class WaterChangePlan {
  const WaterChangePlan({
    required this.actualVolumeLiters,
    required this.changePercent,
    required this.removeVolumeLiters,
    required this.replaceVolumeLiters,
    required this.estimatedResultingNitratePpm,
    required this.formulaExplanation,
    required this.safetyNotes,
  });

  final double actualVolumeLiters;
  final double changePercent;
  final double removeVolumeLiters;
  final double replaceVolumeLiters;
  final double? estimatedResultingNitratePpm;
  final String formulaExplanation;
  final List<String> safetyNotes;
}

class AmmoniaToxicityResult {
  const AmmoniaToxicityResult({
    required this.totalAmmoniaPpm,
    required this.estimatedUnIonizedNh3Ppm,
    required this.riskLevel,
    required this.guidance,
  });

  final double totalAmmoniaPpm;
  final double estimatedUnIonizedNh3Ppm;
  final String riskLevel;
  final String guidance;
}

class CyclingAssessment {
  const CyclingAssessment({
    required this.stageLabel,
    required this.isEvidenceCycled,
    required this.reasons,
    required this.nextSteps,
  });

  final String stageLabel;
  final bool isEvidenceCycled;
  final List<String> reasons;
  final List<String> nextSteps;
}

class WaterChemistryCalculators {
  /// Calculates water change volume and ideal single-step dilution of dissolved nitrate.
  static WaterChangePlan calculateWaterChange({
    required double actualVolumeLiters,
    required double changePercent,
    double? currentNitratePpm,
    bool isSaltwater = false,
  }) {
    final safeVol = actualVolumeLiters.clamp(0.0, 1000000.0);
    final pct = changePercent.clamp(0.0, 95.0);
    final removeL = safeVol * (pct / 100.0);
    final replaceL = removeL;

    double? dilutedNo3;
    if (currentNitratePpm != null && currentNitratePpm >= 0) {
      // Assumes replacement water has 0 ppm nitrate; multi-step dilution or RO/tap nitrate changes result.
      dilutedNo3 = currentNitratePpm * (1.0 - (pct / 100.0));
    }

    final safetyNotes = <String>[
      'Match replacement water temperature closely to the aquarium before adding.',
      'Treat dechlorinator/chloramine binder according to manufacturer instructions for replacement volume (and tank volume if dosing directly).',
      if (isSaltwater)
        'Marine/reef note: Premix and aerate saltwater to target salinity/specific gravity and temperature before adding.',
    ];

    return WaterChangePlan(
      actualVolumeLiters: safeVol,
      changePercent: pct,
      removeVolumeLiters: removeL,
      replaceVolumeLiters: replaceL,
      estimatedResultingNitratePpm: dilutedNo3,
      formulaExplanation:
          'Volume (L) = Actual Water Volume (L) x (Change % / 100). Ideal dilution NO3 = Current NO3 x (1 - Change % / 100), assuming 0 ppm replacement NO3.',
      safetyNotes: safetyNotes,
    );
  }

  /// Estimates un-ionized ammonia (NH3) fraction from total ammonia (NH3+NH4+), pH, and temperature (°C)
  /// using standard pKa approximation: pKa = 0.0901821 + 2729.92 / (T_kelvin).
  static AmmoniaToxicityResult estimateUnIonizedAmmonia({
    required double totalAmmoniaPpm,
    required double ph,
    required double temperatureC,
  }) {
    final safeTan = totalAmmoniaPpm < 0 ? 0.0 : totalAmmoniaPpm;
    final kelvin = temperatureC + 273.15;
    final pKa = 0.0901821 + (2729.92 / kelvin);
    final fractionNh3 = 1.0 / (1.0 + math.pow(10.0, pKa - ph));
    final nh3Ppm = safeTan * fractionNh3;

    final String riskLevel;
    final String guidance;
    if (nh3Ppm >= 0.05) {
      riskLevel = 'CRITICAL TOXICITY';
      guidance =
          'Elevated un-ionized NH3 estimate (>= 0.05 ppm). Test water immediately, perform water change with dechlorinated/temp-matched water, and verify biofiltration.';
    } else if (nh3Ppm >= 0.02) {
      riskLevel = 'ELEVATED / WARNING';
      guidance =
          'Un-ionized NH3 is above ideal zero target. Monitor closely, avoid overfeeding, and retest ammonia and nitrite.';
    } else {
      riskLevel = 'LOW / WITHIN SAFE TARGET';
      guidance =
          'Estimated NH3 is low under current pH/temperature inputs. Always verify test kit accuracy and water conditions.';
    }

    return AmmoniaToxicityResult(
      totalAmmoniaPpm: safeTan,
      estimatedUnIonizedNh3Ppm: nh3Ppm,
      riskLevel: riskLevel,
      guidance: guidance,
    );
  }

  /// Evaluates nitrogen cycle readiness strictly from measured parameters (never day count alone).
  static CyclingAssessment assessCycling({
    required double? ammoniaPpm,
    required double? nitritePpm,
    required double? nitratePpm,
  }) {
    if (ammoniaPpm == null || nitritePpm == null) {
      return const CyclingAssessment(
        stageLabel: 'Insufficient Evidence',
        isEvidenceCycled: false,
        reasons: [
          'Cycling readiness cannot be determined from elapsed days alone; both Ammonia and Nitrite test readings are required.',
        ],
        nextSteps: [
          'Record Ammonia (NH3/NH4) and Nitrite (NO2) test results in Water Lab.',
        ],
      );
    }

    final reasons = <String>[];
    final nextSteps = <String>[];

    final nh3Clear = ammoniaPpm <= 0.25;
    final no2Clear = nitritePpm <= 0.25;
    final hasNitrate = (nitratePpm ?? 0) > 0;

    if (nh3Clear && no2Clear && hasNitrate) {
      reasons.add('Measured ammonia and nitrite are near zero (<= 0.25 ppm) with detectable nitrate (> 0 ppm).');
      nextSteps.add(
        'Confirm nitrification capacity with a controlled ammonia/nitrite check before adding full livestock load.',
      );
      return CyclingAssessment(
        stageLabel: 'Evidence-Cycled (Verify Capacity)',
        isEvidenceCycled: true,
        reasons: reasons,
        nextSteps: nextSteps,
      );
    }

    if (ammoniaPpm > 0.25 && nitritePpm <= 0.25) {
      reasons.add('Ammonia is elevated (${ammoniaPpm.toStringAsFixed(2)} ppm) while nitrite remains low.');
      nextSteps.add('Ammonia-oxidizing bacteria are establishing; protect fish if fish-in cycling and test regularly.');
      return CyclingAssessment(
        stageLabel: 'Stage 1: Ammonia Oxidation',
        isEvidenceCycled: false,
        reasons: reasons,
        nextSteps: nextSteps,
      );
    }

    reasons.add(
      'Active nitrification in progress (Ammonia: ${ammoniaPpm.toStringAsFixed(2)} ppm, Nitrite: ${nitritePpm.toStringAsFixed(2)} ppm).',
    );
    nextSteps.add('Nitrite-oxidizing bacteria need time to convert NO2- into NO3-; keep monitoring parameters.');
    return CyclingAssessment(
      stageLabel: 'Stage 2: Nitrite Conversion',
      isEvidenceCycled: false,
      reasons: reasons,
      nextSteps: nextSteps,
    );
  }
}
