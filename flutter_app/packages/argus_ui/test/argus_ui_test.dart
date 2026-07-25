import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:argus_ui/argus_ui.dart';

void main() {
  test('ArgusTheme light and dark theme generation', () {
    final lightTheme = ArgusTheme.light;
    final darkTheme = ArgusTheme.dark;

    expect(lightTheme.brightness, Brightness.light);
    expect(darkTheme.brightness, Brightness.dark);

    final lightColors = lightTheme.extension<ArgusColors>();
    final darkColors = darkTheme.extension<ArgusColors>();

    expect(lightColors, isNotNull);
    expect(darkColors, isNotNull);
  });
}
