import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';

/// Coquille commune à tous les onglets principaux (barre de navigation
/// en bas), conforme à la maquette catalogue. Chaque membre frontend
/// branche son écran dans app_router.dart -- ce fichier n'est modifié
/// que pour ajouter un nouvel onglet, en concertation avec l'équipe.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.search, activeIcon: Icons.search, label: 'Search'),
    (icon: Icons.video_library_outlined, activeIcon: Icons.video_library, label: 'Library'),
    (icon: Icons.stars_outlined, activeIcon: Icons.stars, label: 'FESPACO'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceElevated, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isActive = navigationShell.currentIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isActive ? item.activeIcon : item.icon,
                            color: isActive ? AppColors.accent : AppColors.textSecondary, size: 22),
                        const SizedBox(height: 4),
                        Text(item.label,
                            style: TextStyle(
                                color: isActive ? AppColors.accent : AppColors.textSecondary,
                                fontSize: 10)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}