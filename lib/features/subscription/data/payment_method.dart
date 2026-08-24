/// Les moyens de paiement Mobile Money supportés (voir maquette Abonnement).
enum PaymentMethod {
  orangeMoney,
  moovMoney;

  /// Nom affiché dans l'interface.
  String get libelle {
    switch (this) {
      case PaymentMethod.orangeMoney:
        return 'Orange Money';
      case PaymentMethod.moovMoney:
        return 'Moov Money';
    }
  }

  /// Valeur envoyée à l'API Django (doit correspondre à ce que le backend attend).
  String get valeurApi {
    switch (this) {
      case PaymentMethod.orangeMoney:
        return 'orange_money';
      case PaymentMethod.moovMoney:
        return 'moov_money';
    }
  }
}
