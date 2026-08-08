import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Écran provisoire affiché tant qu'un onglet n'a pas encore d'écran réel.
/// Chaque propriétaire de branche remplace juste le builder correspondant
/// dans app_router.dart par son propre écran -- ne touchez pas le reste
/// du fichier sans concertation (fichier partagé).
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, required this.owner});

  final String title;
  final String owner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.construction, color: AppColors.textSecondary, size: 40),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text('Écran à construire par : $owner',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}