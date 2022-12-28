import 'package:alcohol_unit_calculator/services/util.dart';
import 'package:test/test.dart';

void main() {
  test('util/toStringWithoutTrailingZeros', () {
    expect(toStringWithoutTrailingZeros(1), '1');
    expect(toStringWithoutTrailingZeros(1.1), '1.1');
    expect(toStringWithoutTrailingZeros(1.101), '1.1',
        reason: 'only 1 decimal place by default');
    expect(toStringWithoutTrailingZeros(1.999), '2');
    expect(toStringWithoutTrailingZeros(1.101, 3), '1.101');
    expect(toStringWithoutTrailingZeros(1.101, 4), '1.101');
    expect(toStringWithoutTrailingZeros(-56), '-56');
  });
}
