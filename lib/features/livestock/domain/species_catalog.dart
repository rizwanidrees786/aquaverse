class SpeciesProfile {
  const SpeciesProfile({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.category,
    required this.waterType,
    required this.temperament,
    required this.minTankLiters,
    required this.recommendedTankLiters,
    required this.adultSizeCm,
    required this.tempMinC,
    required this.tempMaxC,
    required this.phMin,
    required this.phMax,
    required this.minGroupSize,
    required this.bioloadScore,
    required this.careLevel,
    required this.sourceReference,
    required this.lastReviewed,
  });

  final String id;
  final String commonName;
  final String scientificName;
  final String category;
  final String waterType;
  final String temperament;
  final double minTankLiters;
  final double recommendedTankLiters;
  final double adultSizeCm;
  final double tempMinC;
  final double tempMaxC;
  final double phMin;
  final double phMax;
  final int minGroupSize;
  final double bioloadScore;
  final String careLevel;
  final String sourceReference;
  final String lastReviewed;
}

class BuiltInSpeciesCatalog {
  static const List<SpeciesProfile> entries = [
    SpeciesProfile(
      id: 'sp_neon_tetra',
      commonName: 'Neon Tetra',
      scientificName: 'Paracheirodon innesi',
      category: 'Schooling / Tetras',
      waterType: 'freshwater',
      temperament: 'peaceful',
      minTankLiters: 40,
      recommendedTankLiters: 60,
      adultSizeCm: 3.5,
      tempMinC: 21.0,
      tempMaxC: 26.0,
      phMin: 5.5,
      phMax: 7.5,
      minGroupSize: 6,
      bioloadScore: 1.0,
      careLevel: 'Beginner',
      sourceReference: 'Froese & Pauly (FishBase) — Paracheirodon innesi',
      lastReviewed: '2026-11-23',
    ),
    SpeciesProfile(
      id: 'sp_cory_panda',
      commonName: 'Panda Corydoras',
      scientificName: 'Corydoras panda',
      category: 'Bottom Dwellers / Catfish',
      waterType: 'freshwater',
      temperament: 'peaceful',
      minTankLiters: 45,
      recommendedTankLiters: 75,
      adultSizeCm: 5.0,
      tempMinC: 20.0,
      tempMaxC: 25.0,
      phMin: 6.0,
      phMax: 7.5,
      minGroupSize: 6,
      bioloadScore: 1.4,
      careLevel: 'Beginner',
      sourceReference: 'Froese & Pauly (FishBase) — Corydoras panda',
      lastReviewed: '2026-11-23',
    ),
    SpeciesProfile(
      id: 'sp_betta_splendens',
      commonName: 'Betta',
      scientificName: 'Betta splendens',
      category: 'Labyrinth Fish / Bettas',
      waterType: 'freshwater',
      temperament: 'semi-aggressive',
      minTankLiters: 20,
      recommendedTankLiters: 30,
      adultSizeCm: 6.5,
      tempMinC: 24.0,
      tempMaxC: 28.0,
      phMin: 6.0,
      phMax: 7.5,
      minGroupSize: 1,
      bioloadScore: 1.3,
      careLevel: 'Beginner',
      sourceReference: 'Froese & Pauly (FishBase) — Betta splendens',
      lastReviewed: '2026-11-23',
    ),
    SpeciesProfile(
      id: 'sp_cherry_shrimp',
      commonName: 'Cherry Shrimp',
      scientificName: 'Neocaridina davidi',
      category: 'Freshwater Shrimp',
      waterType: 'freshwater',
      temperament: 'peaceful',
      minTankLiters: 20,
      recommendedTankLiters: 35,
      adultSizeCm: 2.5,
      tempMinC: 18.0,
      tempMaxC: 25.0,
      phMin: 6.5,
      phMax: 8.0,
      minGroupSize: 8,
      bioloadScore: 0.3,
      careLevel: 'Beginner',
      sourceReference: 'WoRMS / Crustacea Invertebrate Reference',
      lastReviewed: '2026-11-23',
    ),
    SpeciesProfile(
      id: 'sp_clownfish_ocellaris',
      commonName: 'Ocellaris Clownfish',
      scientificName: 'Amphiprion ocellaris',
      category: 'Saltwater / Reef Fish',
      waterType: 'saltwater',
      temperament: 'semi-aggressive',
      minTankLiters: 75,
      recommendedTankLiters: 110,
      adultSizeCm: 9.0,
      tempMinC: 24.0,
      tempMaxC: 27.0,
      phMin: 8.0,
      phMax: 8.4,
      minGroupSize: 1,
      bioloadScore: 2.2,
      careLevel: 'Intermediate',
      sourceReference: 'Froese & Pauly (FishBase) — Amphiprion ocellaris',
      lastReviewed: '2026-11-23',
    ),
    SpeciesProfile(
      id: 'sp_electric_blue_ram',
      commonName: 'German Blue Ram',
      scientificName: 'Mikrogeophagus ramirezi',
      category: 'Cichlids',
      waterType: 'freshwater',
      temperament: 'peaceful',
      minTankLiters: 55,
      recommendedTankLiters: 80,
      adultSizeCm: 6.0,
      tempMinC: 25.0,
      tempMaxC: 29.0,
      phMin: 5.5,
      phMax: 7.0,
      minGroupSize: 1,
      bioloadScore: 1.5,
      careLevel: 'Intermediate',
      sourceReference: 'Froese & Pauly (FishBase) — Mikrogeophagus ramirezi',
      lastReviewed: '2026-11-23',
    ),
  ];
}
