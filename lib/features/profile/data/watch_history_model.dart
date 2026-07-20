/// Représente un contenu regardé par l'utilisateur (onglet "Vus récemment").
/// Correspond à la classe UML `HistoriqueVisionnage`.
class WatchHistoryItemModel {
  final int contentId;
  final String titre;
  final String posterUrl;
  final DateTime dateVisionnage;
  final String dureeRestante; // ex: "1h 45m" -- déjà formaté par le backend
  final double progressionPourcent; // 0 à 100

  WatchHistoryItemModel({
    required this.contentId,
    required this.titre,
    required this.posterUrl,
    required this.dateVisionnage,
    required this.dureeRestante,
    required this.progressionPourcent,
  });

  factory WatchHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return WatchHistoryItemModel(
      contentId: json['content_id'],
      titre: json['titre'],
      posterUrl: json['affiche'] ?? '',
      dateVisionnage: DateTime.parse(json['date_visionnage']),
      dureeRestante: json['duree_restante'],
      progressionPourcent: double.parse(json['progression'].toString()),
    );
  }

  /// Clé de regroupement par mois, ex: "Février 2024" (voir maquette Historique).
  String get cleMois {
    const mois = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    return '${mois[dateVisionnage.month - 1]} ${dateVisionnage.year}';
  }
}
