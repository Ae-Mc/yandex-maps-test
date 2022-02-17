import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
abstract class AppTextTheme {
  String get fontFamily;

  TextStyle get body1Regular;
}

class DefaultTextTheme implements AppTextTheme {
  @override
  String get fontFamily => 'Rubik';

  @override
  TextStyle get body1Regular => const TextStyle(fontSize: 16);
}
