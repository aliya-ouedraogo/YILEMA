/// Centralise toutes les URLs de l'API Django REST.
/// Un seul endroit à modifier quand on passe de dev à prod (Render/Railway).
class ApiConstants {
  ApiConstants._();

  // TODO: remplacer par l'URL de déploiement une fois le backend en ligne
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // 10.0.2.2 = localhost depuis l'émulateur Android

  // Authentification
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String refreshToken = '/auth/refresh/';
  static const String profile = '/auth/profile/';

  // Catalogue
  static const String contents = '/contenus/';
  static const String categories = '/categories/';

  static String contentDetail(int id) => '/contenus/$id/';
  static String episodes(int serieId) => '/series/$serieId/episodes/';

  // Abonnement & Paiement
  static const String subscriptions = '/abonnements/';
  static const String payments = '/paiements/';

  // Avis & Historique
  static const String reviews = '/avis/';
  static const String watchHistory = '/historique/';
}
