/// Représente un plan d'abonnement renvoyé par l'API Django.
/// Le backend ne fournit que id/name/plan_type/price_fcfa/duration_days/is_active :
/// le badge, les avantages affichés et le flag "populaire" sont déduits ici,
/// côté Flutter, à partir du nom du plan (voir [_deduireAffichage]).
class SubscriptionPlanModel {
  final int id;
  final String nom;
  final String planType; // 'monthly' | 'per_film' | 'freemium'
  final double prixMensuel; // en FCFA
  final int dureeJours;
  final String badge;
  final List<String> avantages;
  final bool estPopulaire;

  SubscriptionPlanModel({
    required this.id,
    required this.nom,
    required this.planType,
    required this.prixMensuel,
    required this.dureeJours,
    required this.badge,
    required this.avantages,
    required this.estPopulaire,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    final nom = json['name'] as String;
    final affichage = _deduireAffichage(nom);

    return SubscriptionPlanModel(
      id: json['id'],
      nom: nom,
      planType: json['plan_type'],
      prixMensuel: double.parse(json['price_fcfa'].toString()),
      dureeJours: json['duration_days'],
      badge: affichage.badge,
      avantages: affichage.avantages,
      estPopulaire: affichage.estPopulaire,
    );
  }

  /// Le backend ne connaît pas encore les "avantages" à afficher par plan.
  /// En attendant qu'il les fournisse, on les déduit ici du nom du plan
  /// (ex: "Premium" -> avantages Premium). À supprimer si le backend
  /// ajoute un jour ces champs directement.
  static ({String badge, List<String> avantages, bool estPopulaire})
      _deduireAffichage(String nom) {
    final nomMinuscule = nom.toLowerCase();

    if (nomMinuscule.contains('premium') ||
        nomMinuscule.contains('cinéphile')) {
      return (
        badge: 'PREMIUM',
        avantages: const [
          'Accès Illimité HD',
          'Exclusivités FESPACO',
          'Sans Publicité'
        ],
        estPopulaire: true,
      );
    }

    if (nomMinuscule.contains('famille') || nomMinuscule.contains('cour')) {
      return (
        badge: 'FAMILLE',
        avantages: const [
          '5 Écrans Simultanés',
          'Contrôle Parental',
          'Mode Hors-ligne'
        ],
        estPopulaire: false,
      );
    }

    return (
      badge: 'GRATUIT',
      avantages: const ['Accès limité au catalogue', 'Publicités incluses'],
      estPopulaire: false,
    );
  }
}
