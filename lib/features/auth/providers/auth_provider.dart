import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../data/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

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

  Future<void> logout() async {
    await _repository.logout();
    currentUser = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}