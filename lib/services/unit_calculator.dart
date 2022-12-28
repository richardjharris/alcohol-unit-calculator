import 'package:alcohol_unit_calculator/services/unit_country.dart';

class UnitCalculator {
  UnitCountry country;

  UnitCalculator({this.country = UnitCountry.uk});

  /// Calculate the number of alcoholic units in a drink.
  double unitsForDrink({required double volumeMl, required double percentAbv}) {
    assert(volumeMl >= 0);
    assert(percentAbv >= 0 && percentAbv <= 100);

    final alcoholMl = volumeMl * (percentAbv / 100.0);
    return alcoholMl / country.mlPerUnit;
  }
}
