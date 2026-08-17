// lib/models/film_model.dart

class Film {
  // Étape 1 - Identité
  String originalTitle;
  String mainGenre;
  String synopsis;

  // Étape 2 - Médias
  String? posterPath;
  String? trailerLink;
  List<String> galleryPaths;

  // Étape 3 - Diffusion
  String economicModel; // "free" | "ppv" | "premium"
  List<String> territorialRights; // ex: ["Burkina Faso", "Afrique de l'Ouest"]
  DateTime? releaseDate;
  bool acceptedTerms;

  Film({
    this.originalTitle = '',
    this.mainGenre = '',
    this.synopsis = '',
    this.posterPath,
    this.trailerLink,
    this.galleryPaths = const [],
    this.economicModel = 'free',
    this.territorialRights = const [],
    this.releaseDate,
    this.acceptedTerms = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "original_title": originalTitle,
      "main_genre": mainGenre,
      "synopsis": synopsis,
      "trailer_link": trailerLink,
      "economic_model": economicModel,
      "territorial_rights": territorialRights,
      "release_date": releaseDate?.toIso8601String(),
      "accepted_terms": acceptedTerms,
      // poster + galerie partent en multipart (fichiers), pas en JSON
    };
  }
}