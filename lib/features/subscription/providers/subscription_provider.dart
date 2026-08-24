import 'package:flutter/foundation.dart';

import '../data/payment_method.dart';
import '../data/subscription_plan_model.dart';
import '../data/subscription_repository.dart';

/// État de l'écran Abonnement : liste des plans, plan choisi, moyen de
/// paiement choisi, et statut de la souscription en cours.
class SubscriptionProvider extends ChangeNotifier {
  final _repository = SubscriptionRepository();

  List<SubscriptionPlanModel> plans = [];
  SubscriptionPlanModel? planChoisi;
  PaymentMethod methodeChoisie = PaymentMethod.orangeMoney;

  bool isLoading = false;
  bool isPaiementEnCours = false;
  String? errorMessage;

  /// Charge les plans depuis l'API au moment où l'écran s'ouvre.
  Future<void> chargerPlans() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      plans = await _repository.fetchPlans();
      // Par défaut, on sélectionne le plan marqué "populaire" dans la maquette (Premium).
      if (plans.isNotEmpty) {
        planChoisi = plans.firstWhere(
          (plan) => plan.estPopulaire,
          orElse: () => plans.first,
        );
      }
    } catch (e) {
      errorMessage = "Impossible de charger les plans d'abonnement";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void choisirPlan(SubscriptionPlanModel plan) {
    planChoisi = plan;
    notifyListeners();
  }

  void choisirMethodePaiement(PaymentMethod methode) {
    methodeChoisie = methode;
    notifyListeners();
  }

  /// Lance le paiement pour le plan sélectionné.
  /// Retourne true si l'abonnement a bien été activé.
  Future<bool> confirmerAbonnement(String numeroTelephone) async {
    if (planChoisi == null) {
      errorMessage = 'Veuillez choisir un plan';
      notifyListeners();
      return false;
    }

    isPaiementEnCours = true;
    errorMessage = null;
    notifyListeners();

    try {
      final succes = await _repository.subscribe(
        planId: planChoisi!.id,
        methode: methodeChoisie,
        numeroTelephone: numeroTelephone,
      );

      if (!succes) {
        errorMessage = 'Le paiement a été refusé, veuillez réessayer';
      }
      return succes;
    } catch (e) {
      errorMessage = 'Erreur lors du paiement, veuillez réessayer';
      return false;
    } finally {
      isPaiementEnCours = false;
      notifyListeners();
    }
  }
}
