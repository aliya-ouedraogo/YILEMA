import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/catalogue/screens/catalogue_screen.dart';
import '../features/catalogue/screens/content_detail_screen.dart';
import '../features/catalogue/data/content_model.dart';

/// Point d'entree unique des routes. Ajoutez une route par ecran ici
/// au lieu de faire des Navigator.push disperses dans le code.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ), // GoRoute
      GoRoute(
        path: '/home',
        builder: (context, state) => const CatalogueScreen(),
      ), // GoRoute
      GoRoute(
        path: '/content/:id',
        builder: (context, state) {
          final content = state.extra as ContentModel;
          return ContentDetailScreen(content: content);
        },
      ), // GoRoute
      // TODO: ajouter au fur et a mesure :
      // '/player/:id'   -> lecteur video
      // '/subscription' -> ecran d'abonnement / paiement
      // '/profile'      -> profil utilisateur + historique
    ],
  );
}