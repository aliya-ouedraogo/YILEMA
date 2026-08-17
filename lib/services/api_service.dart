// lib/services/api_service.dart
//
// AVANT DE COMMENCER : ajoute le package http dans pubspec.yaml
//   dependencies:
//     http: ^1.2.0
// puis lance : flutter pub get

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/film_model.dart';

class ApiService {
  // En-têtes communs à toutes les requêtes (JSON + token si connecté)
  static Map<String, String> get _headers => {
        "Content-Type": "application/json",
        if (AppConfig.authToken != null)
          "Authorization": "Bearer ${AppConfig.authToken}",
      };

  /// Envoie un nouveau film au backend
  /// Correspond au bouton "PUBLIER LE FILM"
  static Future<bool> createFilm(Film film) async {
    final url = Uri.parse("${AppConfig.baseUrl}/films/");

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(film.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true; // succès
    } else {
      // Utile pour déboguer avec ton collègue backend :
      // affiche ce que Django a répondu comme erreur
      print("Erreur createFilm (${response.statusCode}): ${response.body}");
      return false;
    }
  }

  /// Récupère la liste des films (pour le Dashboard / Content Manager)
  static Future<List<dynamic>> getFilms() async {
    final url = Uri.parse("${AppConfig.baseUrl}/films/");
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Impossible de charger les films (${response.statusCode})");
    }
  }

  /// Récupère les stats du Tableau de Bord (Admin / Directeur)
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final url = Uri.parse("${AppConfig.baseUrl}/dashboard/stats/");
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Impossible de charger les stats (${response.statusCode})");
    }
  }

  /// Exemple pour l'inscription réalisateur (page Landing/Signup)
  static Future<bool> registerDirector({
    required String artistName,
    required String email,
    String? website,
    String? bio,
  }) async {
    final url = Uri.parse("${AppConfig.baseUrl}/directors/register/");

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        "artist_name": artistName,
        "email": email,
        "website": website,
        "bio": bio,
      }),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }
}