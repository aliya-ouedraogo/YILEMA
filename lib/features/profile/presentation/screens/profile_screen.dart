import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

/// Écran "Profil" : infos utilisateur, "Continuer la lecture", et menu
/// (Ma Liste, Historique, Abonnement, Paramètres, Déconnexion).
/// Voir maquette : Profil — Faso Ciné (Branding Update).png
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().chargerProfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final utilisateur = provider.utilisateur;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FASO CINÉ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.accent)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(
                                  BorderSide(
                                      color: AppColors.success, width: 2),
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.surfaceElevated,
                                child: Icon(Icons.person,
                                    size: 40, color: AppColors.textSecondary),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_circle,
                                      size: 12, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text('PREMIUM',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              utilisateur?.nom.toUpperCase() ?? '...',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              utilisateur?.email ?? '',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (provider.enCoursDeLecture != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Continuer la lecture',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            TextButton(
                              onPressed: () => context.go('/history'),
                              child: const Text('Voir tout'),
                            ),
                          ],
                        ),
                        _CarteEnCours(item: provider.enCoursDeLecture!),
                        const SizedBox(height: 16),
                      ],
                      _LigneMenu(
                        icone: Icons.bookmark_border,
                        titre: 'Ma Liste',
                        onTap: () => context.go('/library'),
                      ),
                      _LigneMenu(
                        icone: Icons.history,
                        titre: 'Historique',
                        onTap: () => context.go('/history'),
                      ),
                      _LigneMenu(
                        icone: Icons.workspace_premium_outlined,
                        titre: 'Abonnement',
                        sousTitre: 'PLAN PREMIUM ACTIF',
                        sousTitreColor: AppColors.accent,
                        onTap: () => context.go('/subscription'),
                      ),
                      _LigneMenu(
                        icone: Icons.settings_outlined,
                        titre: 'Paramètres',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _LigneMenu(
                        icone: Icons.logout,
                        titre: 'Déconnexion',
                        couleur: AppColors.danger,
                        onTap: () async {
                          await context.read<AuthProvider>().logout();
                          if (context.mounted) context.go('/login');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/// Carte "Continuer la lecture" avec barre de progression.
class _CarteEnCours extends StatelessWidget {
  final dynamic item; // WatchHistoryItemModel

  const _CarteEnCours({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(color: AppColors.surface),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.dureeRestante,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.progressionPourcent / 100,
                    backgroundColor: AppColors.surfaceElevated,
                    color: AppColors.success,
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ligne de menu réutilisée pour Ma Liste / Historique / Abonnement / etc.
class _LigneMenu extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String? sousTitre;
  final Color? sousTitreColor;
  final Color? couleur;
  final VoidCallback onTap;

  const _LigneMenu({
    required this.icone,
    required this.titre,
    this.sousTitre,
    this.sousTitreColor,
    this.couleur,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icone, color: couleur ?? AppColors.textPrimary),
        title: Text(
          titre,
          style: TextStyle(
              color: couleur ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600),
        ),
        subtitle: sousTitre != null
            ? Text(sousTitre!,
                style: TextStyle(
                    color: sousTitreColor ?? AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold))
            : null,
        trailing: couleur == null
            ? const Icon(Icons.chevron_right, color: AppColors.textSecondary)
            : null,
      ),
    );
  }
}
