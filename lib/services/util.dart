/// Render a number to a string, removing any trailing zeros from the end.
String toStringWithoutTrailingZeros(double v, [int maxDecimalPlaces = 1]) {
  var s = v.toStringAsFixed(maxDecimalPlaces);
  // Remove trailing zeros
  while (s.endsWith('0')) {
    s = s.substring(0, s.length - 1);
  }
  // Remove trailing decimal point if no decimal part left
  if (s.endsWith('.')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}
