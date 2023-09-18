import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme.light(
  primary: Color(0xFF8DCFDE),
  onPrimary: Colors.black,
  secondary: Color(0xFF30535B),
  onSecondary: Colors.black,
  primaryContainer: Colors.black,
  secondaryContainer: Color(0xFF8DCFDE),
  onSecondaryContainer: Color(0xFF1C1C1C),
  background: Color(0xFFE3E6E7),
  onBackground: Color(0xFFC4CDCD),
  surface: Color(0xFFDAE0E0),
  onSurface: Color(0xFF1C1C1C),
);

const darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF1C1C1C),
  onPrimary: Colors.white,
  secondary: Color(0xFF8DCFDE),
  onSecondary: Colors.white,
  primaryContainer: Color(0xFF8DCFDE),
  secondaryContainer: Color(0xFF8DCFDE),
  onSecondaryContainer: Color(0xFF1C1C1C),
  background: Color(0xFF282828),
  onBackground: Color(0xFF1C1C1C),
  surface: Color(0xFF464646),
  onSurface: Colors.white,
);

// Shared colors for both themes
class SharedColors {
  static const Color primary = Color(0xFF8DCFDE);
  static const Color error = Colors.red;
  static const Color valid = Colors.green;
  static const Color onError = Colors.white;
  static const Color black = Colors.black;
  static final Color inactiveOption = Colors.grey[500]!;
}

ThemeData buildThemeData(Brightness brightness) {
  if (brightness == Brightness.light) {
    return ThemeData.from(colorScheme: lightColorScheme);
  } else {
    return ThemeData.from(colorScheme: darkColorScheme);
  }
}