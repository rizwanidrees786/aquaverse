import 'package:aquaverse/core/utils/unit_conversions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitConversions', () {
    test('converts length between cm, inches, and feet', () {
      const cm = 30.48;
      expect(
        UnitConversions.fromCentimeters(cm, LengthUnit.feet),
        closeTo(1.0, 1e-6),
      );
      expect(
        UnitConversions.fromCentimeters(2.54, LengthUnit.inches),
        closeTo(1.0, 1e-6),
      );
      expect(
        UnitConversions.toCentimeters(1.0, LengthUnit.feet),
        closeTo(30.48, 1e-6),
      );
    });

    test('converts volume between liters, US gallons, and UK gallons', () {
      const liters = 37.85411784;
      expect(
        UnitConversions.fromLiters(liters, VolumeUnit.usGallons),
        closeTo(10.0, 1e-5),
      );
      expect(
        UnitConversions.toLiters(10.0, VolumeUnit.usGallons),
        closeTo(liters, 1e-5),
      );
    });

    test('converts temperature between Celsius and Fahrenheit', () {
      expect(UnitConversions.celsiusToFahrenheit(25.0), closeTo(77.0, 1e-6));
      expect(UnitConversions.fahrenheitToCelsius(77.0), closeTo(25.0, 1e-6));
    });

    test('computes gross and actual tank water volume accurately', () {
      final gross = UnitConversions.rectangularGrossVolumeLiters(
        lengthCm: 60,
        widthCm: 30,
        heightCm: 36,
      );
      expect(gross, closeTo(64.8, 1e-6));

      final net = UnitConversions.actualWaterVolumeLiters(
        grossVolumeLiters: gross,
        substrateDisplacementLiters: 4.8,
        hardscapeDisplacementLiters: 2.0,
      );
      expect(net, closeTo(58.0, 1e-6));
    });
  });
}
