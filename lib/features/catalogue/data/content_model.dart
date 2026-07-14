/// Modèle correspondant à la classe abstraite `Contenu` du diagramme UML.
/// `type` distingue film / serie / documentaire (héritage côté backend).
class ContentModel {
  final int id;
  final String titre;
  final String synopsis;
  final String type; // 'film' | 'serie' | 'documentaire'
  final int anneeSortie;
  final int duree;
  final String urlVideo;
  final String? affiche;

  ContentModel({
    required this.id,
    required this.titre,
    required this.synopsis,
    required this.type,
    required this.anneeSortie,
    required this.duree,
    required this.urlVideo,
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
      urlVideo: json['url_video'],
      affiche: json['affiche'],
    );
  }
}
