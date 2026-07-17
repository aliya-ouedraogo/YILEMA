import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../data/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// État d'authentification partagé dans toute l'app.
/// Consulté par exemple pour savoir si un utilisateur peut accéder
/// à un contenu premium ou doit être redirigé vers l'écran de connexion.
class AuthProvider extends ChangeNotifier {
  final _repository = AuthRepository();

  AuthStatus status = AuthStatus.unknown;
  UserModel? currentUser;
  String? errorMessage;
  bool isLoading = false;

  Future<bool> login(String email, String motDePasse) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _repository.login(email, motDePasse);
      status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      errorMessage = 'Email ou mot de passe incorrect';
      status = AuthStatus.unauthenticated;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String nom,
    required String email,
    required String motDePasse,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _repository.register(nom: nom, email: email, motDePasse: motDePasse);
      status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      errorMessage = 'Impossible de créer le compte. Vérifiez vos informations.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Contournement UNIQUEMENT disponible en mode debug (kDebugMode), pour
  /// que l'équipe frontend puisse tester la navigation post-connexion
  /// (barre de navigation, écrans protégés) tant que feature/auth-api
  /// n'est pas prête côté backend. Ne s'exécute jamais en release.
  Future<void> debugSkipLogin() async {
    if (!kDebugMode) return;
    currentUser = UserModel(id: 0, nom: 'Utilisateur Démo', email: 'demo@yilema.bf');
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.logout();
    currentUser = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
