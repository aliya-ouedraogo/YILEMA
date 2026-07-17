import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/primary_button.dart';

class _OnboardingPageData {
  const _OnboardingPageData({required this.headline, required this.subtitle, required this.images});
  final String headline;
  final String subtitle;
  final List<String> images;
}

// TODO: remplace ces URLs par tes propres images (celles de vos maquettes,
// ou vos vraies affiches une fois prêtes). 6 images par page, dans l'ordre
// des colonnes de la grille (gauche-haut, milieu-haut, droite-haut,
// gauche-bas, milieu-bas, droite-bas).
final _pages = [
  const _OnboardingPageData(
    headline: 'LE MEILLEUR DU CINÉMA\nBURKINABÈ ET AFRICAIN,\nOÙ VOUS VOULEZ.',
    subtitle: 'Films, séries et documentaires exclusifs. Annulez à tout moment.',
    images: [
      'https://i.pinimg.com/736x/2b/1b/94/2b1b94b22a5236791acdf912bbbc12f0.jpg',
      'https://i.pinimg.com/736x/54/62/32/54623244cb072ea233f63d6d6f143a73.jpg',
      'https://i.pinimg.com/736x/21/72/4a/21724a7a15da9e466845f60d596031bb.jpg',
      'https://i.pinimg.com/1200x/ba/e1/51/bae15171cafd1fe54115b9af7c963cda.jpg',
      'https://i.pinimg.com/736x/82/89/b2/8289b2f43017d24938a77fafef2551a1.jpg',
      'https://i.pinimg.com/736x/38/91/d6/3891d64bc01c94a35b504c1f8f7c490b.jpg',
    ],
  ),
  const _OnboardingPageData(
    headline: 'DES HISTOIRES QUI\nVOUS RESSEMBLENT.',
    subtitle: 'Réalisées par des cinéastes burkinabè et africains, pour vous.',
    images: [
      'https://i.pinimg.com/736x/f3/9b/60/f39b604af5778bd927c4fda30a744467.jpg',
      'https://i.pinimg.com/736x/90/57/71/9057714a89ad57c4032ea6b1eff3591a.jpg',
      'https://i.pinimg.com/736x/85/e1/7d/85e17d2fc4b8524430c8b3b0a55b6fef.jpg',
      'https://i.pinimg.com/736x/3d/a2/1c/3da21c309c081c5aae9247610b76ca33.jpg',
      'https://i.pinimg.com/736x/6c/53/6a/6c536ac6b8bde7ad9ed7696c84f093fa.jpg',
      'https://i.pinimg.com/736x/a3/fd/95/a3fd953dc27a7d87392598c4ad428619.jpg',
    ],
  ),
  const _OnboardingPageData(
    headline: 'REGARDEZ PARTOUT,\nMÊME HORS-LIGNE.',
    subtitle: 'Téléchargez vos films préférés et emportez-les avec vous.',
    images: [
      'https://i.pinimg.com/736x/fe/53/89/fe53896a0d450d4987dc89cf4c55f0c2.jpg',
      'https://i.pinimg.com/736x/fc/66/e8/fc66e876b5f351e95ee4c867b6d8c94f.jpg',
      'https://i.pinimg.com/736x/eb/07/17/eb07179ff8e4285d9112343d75bf17c8.jpg',
      'https://i.pinimg.com/736x/09/52/2a/09522a0ebab73905d985819bde413ca4.jpg',
      'https://i.pinimg.com/736x/e9/59/58/e9595836aece1d8f44895f297b7dfee2.jpg',
      'https://i.pinimg.com/736x/03/1d/d3/031dd3906da1094fdb462e3f7c2f8c8b.jpg',
    ],
  ),
];

/// Écran affiché au tout premier lancement de l'app (3 pages type carousel).
/// TODO: mémoriser avec shared_preferences que l'utilisateur l'a déjà vu,
/// pour ne l'afficher qu'une seule fois.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) => _OnboardingPageView(page: _pages[index]),
          ),

          // En-tête fixe au-dessus du carousel : logo + lien "S'identifier"
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppLogo(fontSize: 16, iconSize: 20),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text("S'IDENTIFIER",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Pied fixe : pagination + bouton Commencer
          Positioned(
            left: 24,
            right: 24,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _currentPage ? AppColors.accent : AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Commencer',
                      onPressed: () => context.go('/register'),
                      trailingIcon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page});
  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PosterCollage(images: page.images),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.background],
                    stops: [0.55, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 130),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  page.headline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                      height: 1.25),
                ),
                const SizedBox(height: 16),
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Grille de 3 colonnes d'affiches, colonne du milieu décalée vers le bas
/// pour recréer l'effet de quinconce visible sur la maquette.
class _PosterCollage extends StatelessWidget {
  const _PosterCollage({required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _PosterColumn(images: [images[0], images[3]])),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: _PosterColumn(images: [images[1], images[4]]),
          ),
        ),
        Expanded(child: _PosterColumn(images: [images[2], images[5]])),
      ],
    );
  }
}

class _PosterColumn extends StatelessWidget {
  const _PosterColumn({required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: images
          .map((url) => Padding(
                padding: const EdgeInsets.all(3),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url, fit: BoxFit.cover),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
