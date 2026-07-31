import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// Logo Yilema (icône + wordmark), utilisé en en-tête des écrans
/// d'authentification et d'onboarding. Toujours cliquable -> renvoie vers
/// l'onboarding, comme sur les maquettes.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.fontSize = 18, this.iconSize = 20});

  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/onboarding'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_movies, color: AppColors.accent, size: iconSize),
          const SizedBox(width: 8),
          Text('YILEMA',
              style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  letterSpacing: 0.5)),
        ], 
      ),
    );
  }
}