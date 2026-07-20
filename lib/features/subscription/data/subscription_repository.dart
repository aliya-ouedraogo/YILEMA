import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'payment_method.dart';
import 'subscription_plan_model.dart';

/// Toute la logique d'appel API liée à l'abonnement et au paiement vit ici.
/// Le provider ne fait qu'appeler ces méthodes et gérer l'état résultant.
class SubscriptionRepository {
  final _client = ApiClient();

  /// Récupère la liste des plans disponibles (Gratuit, Premium, Famille).
  Future<List<SubscriptionPlanModel>> fetchPlans() async {
    final response = await _client.dio.get(ApiConstants.subscriptions);

    final List<dynamic> data = response.data;
    return data.map((json) => SubscriptionPlanModel.fromJson(json)).toList();
  }

  /// Souscrit à un plan et déclenche le paiement Mobile Money.
  /// Retourne true si le paiement a été accepté par le backend.
  Future<bool> subscribe({
    required int planId,
    required PaymentMethod methode,
    required String numeroTelephone,
  }) async {
    final response = await _client.dio.post(
      ApiConstants.payments,
      data: {
        'plan_id': planId,
        'methode_paiement': methode.valeurApi,
        'numero_telephone': numeroTelephone,
      },
    );

    return response.data['statut'] == 'succes';
  }
}
