import 'package:alcohol_unit_calculator/services/unit_calculator.dart';
import 'package:alcohol_unit_calculator/services/unit_country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UnitCalculator.unitsForDrink (UK)', () {
    final calc = UnitCalculator(country: UnitCountry.uk);
    final vodka = calc.unitsForDrink(volumeMl: 25, percentAbv: 40);
    expect(vodka, moreOrLessEquals(1.0), reason: '1 shot of vodka is 1 unit');

    final ramune = calc.unitsForDrink(volumeMl: 330, percentAbv: 6);
    expect(ramune, moreOrLessEquals(1.98));

    final dragonSoop = calc.unitsForDrink(volumeMl: 500, percentAbv: 8);
    expect(dragonSoop, moreOrLessEquals(4.0));

    final strongishBeer = calc.unitsForDrink(volumeMl: 440, percentAbv: 5.5);
    expect(strongishBeer, moreOrLessEquals(2.42));

    final wine = calc.unitsForDrink(volumeMl: 175, percentAbv: 12);
    expect(wine, moreOrLessEquals(2.1));

    final noAlcohol = calc.unitsForDrink(volumeMl: 500, percentAbv: 0);
    expect(noAlcohol, moreOrLessEquals(0.0));

    final noDrinkAtAll = calc.unitsForDrink(volumeMl: 0, percentAbv: 0);
    expect(noDrinkAtAll, moreOrLessEquals(0.0));
  });

  test('UnitCalculator.unitsForDrink (Ireland)', () {
    final calc = UnitCalculator(country: UnitCountry.ireland);
    final vodka = calc.unitsForDrink(volumeMl: 25, percentAbv: 40);
    expect(vodka, moreOrLessEquals(0.7874015748031497),
        reason: 'a unit contains more alcohol in Ireland');
  });

  test('UnitCalculator.unitsForDrink (error cases)', () {
    final calc = UnitCalculator(country: UnitCountry.uk);
    expect(() => calc.unitsForDrink(volumeMl: -1, percentAbv: 40),
        throwsAssertionError,
        reason: 'volume must be >= 0');
    expect(() => calc.unitsForDrink(volumeMl: 25, percentAbv: -1),
        throwsAssertionError,
        reason: 'percentAbv must be >= 0');
    expect(() => calc.unitsForDrink(volumeMl: 25, percentAbv: 101),
        throwsAssertionError,
        reason: 'percentAbv must be <= 100');
  });

  test('UnitCalculator default values', () {
    final calc = UnitCalculator();
    expect(calc.country, equals(UnitCountry.uk));
  });
}
