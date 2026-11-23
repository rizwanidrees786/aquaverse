import 'package:aquaverse/features/livestock/domain/species_catalog.dart';
import 'package:aquaverse/features/livestock/domain/stocking_intelligence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('StockingIntelligenceEngine flags under-sized schooling group', () {
    final neon = BuiltInSpeciesCatalog.entries.first;
    final result = StockingIntelligenceEngine.evaluate(
      actualVolumeLiters: 50,
      stockedItems: [(neon, 2)],
    );

    expect(result.totalBioloadPoints, closeTo(2.0, 1e-6));
    expect(result.warnings.any((w) => w.contains('minimum group')), isTrue);
  });
}
