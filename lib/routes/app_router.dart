import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';

import '../features/catalogue/screens/catalogue_screen.dart';

/// Point d'entrée unique des routes. Ajoutez une route par écran ici
/// au lieu de faire des Navigator.push dispersés dans le code.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
  path: '/home',
  builder: (context, state) => const CatalogueScreen(),
),//GoRoute
      // TODO: ajouter au fur et à mesure :
      // '/home'            -> catalogue (écran d'accueil)
      // '/content/:id'     -> fiche détail d'un contenu
      // '/player/:id'      -> lecteur vidéo
      // '/subscription'    -> écran d'abonnement / paiement
      // '/profile'         -> profil utilisateur + historique
    ],
  );
}
