import 'package:go_router/go_router.dart';

import '../core/widgets/placeholder_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import 'app_shell.dart';

/// Point d'entrée unique des routes. Ajoutez une route par écran ici
/// au lieu de faire des Navigator.push dispersés dans le code.
///
/// Chaque écran principal (Home/Search/Library/FESPACO/Profile) est un
/// PlaceholderScreen en attendant que son propriétaire branche son vrai
/// écran -- remplacez juste le `builder:` correspondant, ne touchez pas
/// le reste de ce fichier sans concertation.
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
            // Onglet Home -- propriétaire : Sacko (feature/catalogue-player)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Accueil / Catalogue', owner: 'Sacko - feature/catalogue-player'),
              ),
            ]),
            // Onglet Search -- propriétaire : Sacko (feature/catalogue-player)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Recherche', owner: 'Sacko - feature/catalogue-player'),
              ),
            ]),
            // Onglet Library -- propriétaire : Fadila (feature/subscription-profile)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Ma Bibliothèque', owner: 'Fadila - feature/subscription-profile'),
              ),
            ]),
            // Onglet FESPACO -- propriétaire : Sacko (feature/catalogue-player)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/fespaco',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Collection FESPACO', owner: 'Sacko - feature/catalogue-player'),
              ),
            ]),
            // Onglet Profile -- propriétaire : Fadila (feature/subscription-profile)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Profil', owner: 'Fadila - feature/subscription-profile'),
              ),
            ]),
          ],
        ),

        // TODO: routes hors coquille (sans barre de nav), à ajouter au fur et à mesure :
        // '/content/:id'     -> fiche détail d'un contenu (Sacko)
        // '/player/:id'      -> lecteur vidéo (Sacko)
        // '/subscription'    -> écran d'abonnement / paiement (Fadila)
        // '/realisateur/...' -> espace réalisateur (Shahida)
      ],
    );
  }
}
