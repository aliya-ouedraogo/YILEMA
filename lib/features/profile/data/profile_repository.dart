import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../auth/data/user_model.dart';
import 'transaction_model.dart';
import 'watch_history_model.dart';

/// Toute la logique d'appel API liée au profil, à l'historique de
/// visionnage et aux transactions vit ici.
class ProfileRepository {
  final _client = ApiClient();

  /// Récupère les infos de l'utilisateur connecté (nom, email, plan actif...).
  Future<UserModel> fetchProfile() async {
    final response = await _client.dio.get(ApiConstants.profile);
    return UserModel.fromJson(response.data);
  }

  /// Récupère la liste des contenus regardés, du plus récent au plus ancien.
  Future<List<WatchHistoryItemModel>> fetchWatchHistory() async {
    final response = await _client.dio.get(ApiConstants.watchHistory);
    final List<dynamic> data = response.data;
    return data.map((json) => WatchHistoryItemModel.fromJson(json)).toList();
  }

  /// Récupère l'historique des paiements (abonnements + achats à l'unité).
  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await _client.dio.get(ApiConstants.payments);
    final List<dynamic> data = response.data;
    return data.map((json) => TransactionModel.fromJson(json)).toList();
  }

  /// Supprime tout l'historique de visionnage (bouton "TOUT EFFACER").
  Future<void> effacerHistorique() async {
    await _client.dio.delete(ApiConstants.watchHistory);
  }
}
