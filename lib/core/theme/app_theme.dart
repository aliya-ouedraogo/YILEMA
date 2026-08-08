import 'package:flutter/material.dart';

/// Palette tirée des maquettes Figma Yilema.
/// Fond sombre type streaming + accent ambre pour les actions principales.
class AppColors {
  AppColors._();

  // Fond
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceElevated = Color(0xFF262626);

  // Accent principal (logo, CTA : "S'abonner maintenant", filtres actifs)
  static const Color accent = Color(0xFFF2A623);
  static const Color accentDark = Color(0xFFBA7517);

  // Vert (bouton "Regarder", barre de progression, badge gratuit)
  static const Color success = Color(0xFF4CAF50);

  // Rouge (badge FESPACO, déconnexion, erreurs)
  static const Color danger = Color(0xFFD32F2F);

  // Texte
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA0A0A0);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.success,
        error: AppColors.danger,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
        titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.textPrimary, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}