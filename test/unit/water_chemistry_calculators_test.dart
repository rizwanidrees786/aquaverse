import 'package:aquaverse/features/water_lab/domain/water_chemistry_calculators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Water change and cycling readiness calculators work as expected', () {
    final plan = WaterChemistryCalculators.calculateWaterChange(
      actualVolumeLiters: 100,
      changePercent: 25,
      currentNitratePpm: 40,
    );
    expect(plan.removeVolumeLiters, closeTo(25.0, 1e-6));
    expect(plan.estimatedResultingNitratePpm, closeTo(30.0, 1e-6));

    final cycled = WaterChemistryCalculators.assessCycling(
      ammoniaPpm: 0,
      nitritePpm: 0,
      nitratePpm: 15,
    );
    expect(cycled.isEvidenceCycled, isTrue);

    final dayOnlyCheck = WaterChemistryCalculators.assessCycling(
      ammoniaPpm: null,
      nitritePpm: null,
      nitratePpm: null,
    );
    expect(dayOnlyCheck.isEvidenceCycled, isFalse);
  });
}
