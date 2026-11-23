enum MeasurementSystem {
  metric,
  imperial,
}

enum LengthUnit {
  cm,
  inches,
  feet,
}

enum VolumeUnit {
  liters,
  usGallons,
  ukGallons,
}

enum TemperatureUnit {
  celsius,
  fahrenheit,
}

class UnitConversions {
  static const double cmPerInch = 2.54;
  static const double cmPerFoot = 30.48;
  static const double litersPerUsGallon = 3.785411784;
  static const double litersPerUkGallon = 4.54609;

  static double toCentimeters(double value, LengthUnit unit) {
    switch (unit) {
      case LengthUnit.cm:
        return value;
      case LengthUnit.inches:
        return value * cmPerInch;
      case LengthUnit.feet:
        return value * cmPerFoot;
    }
  }

  static double fromCentimeters(double cm, LengthUnit unit) {
    switch (unit) {
      case LengthUnit.cm:
        return cm;
      case LengthUnit.inches:
        return cm / cmPerInch;
      case LengthUnit.feet:
        return cm / cmPerFoot;
    }
  }

  static double toLiters(double value, VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.liters:
        return value;
      case VolumeUnit.usGallons:
        return value * litersPerUsGallon;
      case VolumeUnit.ukGallons:
        return value * litersPerUkGallon;
    }
  }

  static double fromLiters(double liters, VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.liters:
        return liters;
      case VolumeUnit.usGallons:
        return liters / litersPerUsGallon;
      case VolumeUnit.ukGallons:
        return liters / litersPerUkGallon;
    }
  }

  static double celsiusToFahrenheit(double c) => (c * 9.0 / 5.0) + 32.0;

  static double fahrenheitToCelsius(double f) => (f - 32.0) * 5.0 / 9.0;

  /// Computes gross rectangular tank volume in liters from dimensions in cm.
  static double rectangularGrossVolumeLiters({
    required double lengthCm,
    required double widthCm,
    required double heightCm,
  }) {
    if (lengthCm <= 0 || widthCm <= 0 || heightCm <= 0) {
      return 0;
    }
    return (lengthCm * widthCm * heightCm) / 1000.0;
  }

  /// Estimates net water capacity after subtracting substrate and hardscape displacement.
  static double actualWaterVolumeLiters({
    required double grossVolumeLiters,
    double substrateDisplacementLiters = 0,
    double hardscapeDisplacementLiters = 0,
  }) {
    final net = grossVolumeLiters -
        substrateDisplacementLiters.clamp(0, grossVolumeLiters) -
        hardscapeDisplacementLiters.clamp(0, grossVolumeLiters);
    return net < 0 ? 0 : net;
  }
}
