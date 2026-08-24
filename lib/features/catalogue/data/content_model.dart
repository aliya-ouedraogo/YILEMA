class ContentModel {
  final int id;
  final String titre;
  final String synopsis;
  final String type;
  final int anneeSortie;
  final int duree;
  final String? urlVideo;      // ← ajout du ?
  final String? affiche;

  ContentModel({
    required this.id,
    required this.titre,
    required this.synopsis,
    required this.type,
    required this.anneeSortie,
    required this.duree,
    this.urlVideo,              // ← plus "required"
    this.affiche,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      titre: json['titre'],
      synopsis: json['synopsis'],
      type: json['type'],
      anneeSortie: json['annee_sortie'],
      duree: json['duree'],
      urlVideo: json['url_video'],   // ← inchangé, accepte maintenant null
      affiche: json['affiche'],
    );
  }
}