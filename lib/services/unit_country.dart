import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

enum UnitCountry {
  australia(12.7),
  canada(17.1),
  denmark(15.2),
  finland(13.9),
  france(15.2),
  hungary(21.5),
  iceland(12.0),
  ireland(12.7),
  italy(12.7),
  japan(25.0),
  netherlands(12.5, 'The Netherlands'),
  newZealand(12.7, 'New Zealand'),
  portugal(17.7),
  spain(12.7),
  uk(10, 'UK'),
  usa(17.7, 'USA');

  const UnitCountry(this.mlPerUnit, [this.displayName]);
  final double mlPerUnit;
  final String? displayName;

  String name() {
    return displayName ?? toBeginningOfSentenceCase(describeEnum(this))!;
  }
}
