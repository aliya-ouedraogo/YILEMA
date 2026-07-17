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

// TODO équipe design : seul le texte de la page 1 vient de la maquette.
// Les textes des pages 2 et 3 sont des propositions à valider avec l'équipe,
// et les images sont des placeholders (picsum) à remplacer par les vraies
// affiches Yilema une fois disponibles dans assets/images/.
final _pages = [
  const _OnboardingPageData(
    headline: 'LE MEILLEUR DU CINÉMA\nBURKINABÈ ET AFRICAIN,\nOÙ VOUS VOULEZ.',
    subtitle: 'Films, séries et documentaires exclusifs. Annulez à tout moment.',
    images: [
      'https://picsum.photos/seed/yilema1/300/450',
      'https://picsum.photos/seed/yilema2/300/450',
      'https://picsum.photos/seed/yilema3/300/450',
      'https://picsum.photos/seed/yilema4/300/450',
      'https://picsum.photos/seed/yilema5/300/450',
      'https://picsum.photos/seed/yilema6/300/450',
    ],
  ),
  const _OnboardingPageData(
    headline: 'DES HISTOIRES QUI\nVOUS RESSEMBLENT.',
    subtitle: 'Réalisées par des cinéastes burkinabè et africains, pour vous.',
    images: [
      'https://picsum.photos/seed/yilema7/300/450',
      'https://picsum.photos/seed/yilema8/300/450',
      'https://picsum.photos/seed/yilema9/300/450',
      'https://picsum.photos/seed/yilema10/300/450',
      'https://picsum.photos/seed/yilema11/300/450',
      'https://picsum.photos/seed/yilema12/300/450',
    ],
  ),
  const _OnboardingPageData(
    headline: 'REGARDEZ PARTOUT,\nMÊME HORS-LIGNE.',
    subtitle: 'Téléchargez vos films préférés et emportez-les avec vous.',
    images: [
      'https://picsum.photos/seed/yilema13/300/450',
      'https://picsum.photos/seed/yilema14/300/450',
      'https://picsum.photos/seed/yilema15/300/450',
      'https://picsum.photos/seed/yilema16/300/450',
      'https://picsum.photos/seed/yilema17/300/450',
      'https://picsum.photos/seed/yilema18/300/450',
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
