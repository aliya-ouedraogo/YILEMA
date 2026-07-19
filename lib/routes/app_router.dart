import 'package:go_router/go_router.dart';

import '../core/widgets/placeholder_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/catalogue/screens/catalogue_screen.dart';
import '../features/catalogue/screens/content_detail_screen.dart';
import '../features/catalogue/screens/video_player_screen.dart';
import '../features/catalogue/data/content_model.dart';
import 'app_shell.dart';
import '../features/catalogue/screens/search_screen.dart';
import '../features/catalogue/screens/fespaco_screen.dart';

class AppRouter {
  AppRouter._();

  static const _publicPaths = ['/onboarding', '/login', '/register'];

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/onboarding',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final loggedIn = authProvider.status == AuthStatus.authenticated;
        final isPublic = _publicPaths.contains(state.matchedLocation);

        if (!loggedIn && !isPublic) return '/login';
        if (loggedIn && isPublic) return '/home';
        return null;
      },
      routes: [
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
          branches: [
            // Onglet Home -- proprietaire : Sacko (feature/catalogue-player)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const CatalogueScreen(),
              ),
            ]),
            // Onglet Search -- proprietaire : Sacko (feature/catalogue-player)
            StatefulShellBranch(routes: [
  GoRoute(
    path: '/search',
    builder: (context, state) => const SearchScreen(),
  ),
]),
            // Onglet Library -- proprietaire : Fadila (feature/subscription-profile)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const PlaceholderScreen(
                    title: 'Ma Bibliotheque', owner: 'Fadila - feature/subscription-profile'),
              ),
            ]),
            // Onglet FESPACO -- proprietaire : Sacko (feature/catalogue-player)
           StatefulShellBranch(routes: [
  GoRoute(
    path: '/fespaco',
    builder: (context, state) => const FespacoScreen(),
  ),
]),
            // Onglet Profile -- proprietaire : Fadila (feature/subscription-profile)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const PlaceholderScreen(
                    title: 'Profil', owner: 'Fadila - feature/subscription-profile'),
              ),
            ]),
          ],
        ),

        // Routes hors coquille (sans barre de navigation)
        GoRoute(
          path: '/content/:id',
          builder: (context, state) {
            final content = state.extra as ContentModel;
            return ContentDetailScreen(content: content);
          },
        ),
        GoRoute(
          path: '/player/:id',
          builder: (context, state) {
            final content = state.extra as ContentModel;
            return VideoPlayerScreen(content: content);
          },
        ),
        // TODO: routes restantes a ajouter au fur et a mesure :
        // '/subscription'    -> ecran d'abonnement / paiement (Fadila)
        // '/realisateur/...' -> espace realisateur (Shahida)
      ],
    );
  }
}