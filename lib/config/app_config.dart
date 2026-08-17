// lib/config/app_config.dart
//
// Un seul endroit pour l'URL du backend.
// Comme ça, si l'URL change (ex: ton collègue déploie sur un nouveau serveur),
// tu changes UNE seule ligne, pas dans tout le projet.

class AppConfig {
  // Pendant le développement, si le backend tourne sur ton PC (localhost) :
  // - Emulateur Android  -> "http://10.0.2.2:8000/api"
  // - Vrai téléphone / Simulateur iOS -> "http://IP_DE_TON_PC:8000/api"
  //   (demande l'IP à ton collègue backend, ou fais `ipconfig` sur Windows)
  //
  // Une fois que le backend est en ligne (Render, Railway, etc.),
  // tu remplaces par l'URL publique, ex: "https://faso-cine-api.onrender.com/api"

  static const String baseUrl = "http://10.0.2.2:8000/api";

  // Si le backend utilise un token d'authentification (JWT), on le stocke ici
  // après le login, pour l'envoyer avec chaque requête.
  static String? authToken;
}