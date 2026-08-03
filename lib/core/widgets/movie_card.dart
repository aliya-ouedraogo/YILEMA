import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Petit badge affiché en haut de l'affiche (FESPACO, NOUVEAU, GRATUIT...).
class MovieBadge {
  const MovieBadge(this.label, this.color, {this.textColor = Colors.white, this.icon});

  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  // Raccourcis pratiques pour les badges qu'on voit le plus dans les maquettes.
  static const fespaco = MovieBadge('FESPACO', AppColors.danger, icon: Icons.emoji_events);
  static const nouveau = MovieBadge('NOUVEAU', AppColors.success);
  static const gratuit = MovieBadge('GRATUIT', AppColors.accent, textColor: Colors.black);
}

/// Carte film utilisée dans le catalogue, la collection FESPACO, la recherche...
/// Composant partagé : ne pas dupliquer dans features/catalogue, importez-la
/// depuis core/widgets.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.posterUrl,
    this.rating,
    this.badges = const [],
    this.onTap,
  });

  final String title;
  final String subtitle; // ex: "Bénin • 2024"
  final String posterUrl;
  final double? rating;
  final List<MovieBadge> badges;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: posterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.surface),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.movie_outlined, color: AppColors.textSecondary),
                    ),
                  ),
                  // Dégradé bas pour garder la note lisible peu importe l'image
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                  if (badges.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: badges
                            .map((b) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: _Badge(badge: b),
                                ))
                            .toList(),
                      ),
                    ),
                  if (rating != null)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.accent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            rating!.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badge});
  final MovieBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: badge.color, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge.icon != null) ...[
            Icon(badge.icon, size: 10, color: badge.textColor),
            const SizedBox(width: 3),
          ],
          Text(
            badge.label,
            style: TextStyle(
                color: badge.textColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }
}