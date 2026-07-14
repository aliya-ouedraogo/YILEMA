import 'package:flutter/material.dart';

/// Palette et thème centralisés. À ajuster une fois les maquettes Figma validées.
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFFD32F2F); // rouge cinéma
  static const Color background = Color(0xFF121212); // fond sombre type streaming
  static const Color surface = Color(0xFF1E1E1E);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
    );
  }
}
