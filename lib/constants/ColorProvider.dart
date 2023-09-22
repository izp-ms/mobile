import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorProvider {
  static Map<String, dynamic>? _colors;

  static Future<void> loadColors() async {
    final String jsonString = await rootBundle.loadString('assets/colors.json');
    _colors = json.decode(jsonString);
  }

  static Color getColor(String colorName,
      {String subkey = 'basic',
        BuildContext? context,
        String? theme}) {
    if (context != null && theme == null) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      theme = isDarkMode ? 'dark' : 'light';
    } else if (theme == null) {
      theme = 'static';
    } else if (theme != 'dark' && theme != 'light' && theme != 'static') {
      throw Exception('Invalid theme specified');
    }

    String? colorValue;

    if (theme == 'static') {
      colorValue = _colors?[theme]?[colorName];
    } else {
      colorValue = _colors?[theme]?[subkey]?[colorName];
    }

    if (colorValue != null) {
      return Color(int.parse(colorValue.substring(1, 7), radix: 16) + 0xFF000000); // Convert hex to Color
    } else {
      throw Exception('Color not found');
    }
  }
}

// How to use it?
//
// To fetch a color based on the current theme (light/dark):
// ColorProvider.getColor('primary', context: context);
//
// To specify a theme (light/dark) directly:
// ColorProvider.getColor('primary', theme: 'light');
//
// To fetch a color from a specific subkey:
// ColorProvider.getColor('primary', subkey: 'button', theme: 'light');
//
// For static colors (colors that don't depend on a theme):
// ColorProvider.getColor('primary');
