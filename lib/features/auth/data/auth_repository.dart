import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'user_model.dart';

/// Toute la logique d'appel API liée à l'authentification vit ici.
/// Le provider ne fait qu'appeler ces méthodes et gérer l'état résultant.
class AuthRepository {
  final _client = ApiClient();

  Future<UserModel> login(String email, String motDePasse) async {
    final response = await _client.dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': motDePasse},
    );

    await _client.saveTokens(
      access: response.data['access'],
      refresh: response.data['refresh'],
    );

    return UserModel.fromJson(response.data['user']);
  }

  Future<UserModel> register({
    required String nom,
    required String email,
    required String motDePasse,
  }) async {
    final response = await _client.dio.post(
      ApiConstants.register,
      data: {'nom': nom, 'email': email, 'password': motDePasse},
    );
    return UserModel.fromJson(response.data['user']);
  }

  Future<void> logout() async {
    await _client.clearTokens();
  }
}
