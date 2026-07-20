/// Représente un plan d'abonnement proposé par l'API (Gratuit, Premium, Famille...).
class SubscriptionPlanModel {
  final int id;
  final String nom;
  final String badge; // ex: "GRATUIT", "PREMIUM", "FAMILLE"
  final double prixMensuel; // en FCFA
  final List<String> avantages;
  final bool estPopulaire;

  SubscriptionPlanModel({
    required this.id,
    required this.nom,
    required this.badge,
    required this.prixMensuel,
    required this.avantages,
    this.estPopulaire = false,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'],
      nom: json['nom'],
      badge: json['badge'],
      // le backend Django peut renvoyer le prix en String, donc on sécurise la conversion
      prixMensuel: double.parse(json['prix_mensuel'].toString()),
      avantages: List<String>.from(json['avantages']),
      estPopulaire: json['est_populaire'] ?? false,
    );
  }
}
