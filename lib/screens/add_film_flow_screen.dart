// lib/screens/add_film_flow_screen.dart
//
// C'est l'écran "conteneur" : il affiche les 3 étapes l'une après l'autre.
// - On avance avec PageView (comme un carrousel bloqué, contrôlé par le bouton "Suivant")
// - Les données saisies restent dans "film" (un seul objet Film partagé entre les 3 étapes)
// - À la toute dernière étape, "Publier le film" envoie tout au backend

import 'package:flutter/material.dart';
import '../models/film_model.dart';
import '../services/api_service.dart';
import 'steps/step1_identite.dart';
import 'steps/step2_medias.dart';
import 'steps/step3_diffusion.dart';

class AddFilmFlowScreen extends StatefulWidget {
  const AddFilmFlowScreen({super.key});

  @override
  State<AddFilmFlowScreen> createState() => _AddFilmFlowScreenState();
}

class _AddFilmFlowScreenState extends State<AddFilmFlowScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0; // 0 = étape 1, 1 = étape 2, 2 = étape 3
  final Film film = Film(); // Les 3 étapes remplissent le même objet
  bool isPublishing = false;

  static const Color bgColor = Color(0xFF0D0D0D);
  static const Color yellow = Color(0xFFF5C518);

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => currentStep = step);
  }

  void _nextStep() {
    // Petite validation avant de passer à l'étape suivante
    if (currentStep == 0 && film.originalTitle.trim().isEmpty) {
      _showError("Le titre original est obligatoire.");
      return;
    }
    if (currentStep == 1 && film.posterPath == null) {
      _showError("L'affiche principale est obligatoire.");
      return;
    }
    if (currentStep < 2) {
      _goToStep(currentStep + 1);
    }
  }

  void _previousStep() {
    if (currentStep > 0) _goToStep(currentStep - 1);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Future<void> _publish() async {
    if (!film.acceptedTerms) {
      _showError("Tu dois accepter les conditions de distribution.");
      return;
    }

    setState(() => isPublishing = true);
    final success = await ApiService.createFilm(film);
    setState(() => isPublishing = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "Film publié avec succès !"
            : "Erreur lors de la publication. Réessaie."),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: yellow),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: const Text("YILEMA",
            style: TextStyle(color: yellow, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // on avance QUE via les boutons
              onPageChanged: (i) => setState(() => currentStep = i),
              children: [
                Step1Identite(film: film, onChanged: () => setState(() {})),
                Step2Medias(film: film, onChanged: () => setState(() {})),
                Step3Diffusion(film: film, onChanged: () => setState(() {})),
              ],
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final labels = ["Identité", "Médias", "Diffusion"];
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final isDone = i < currentStep;
          final isActive = i == currentStep;
          return Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isDone || isActive
                        ? yellow
                        : const Color(0xFF2A2A2A),
                    child: isDone
                        ? const Icon(Icons.check, color: Colors.black, size: 16)
                        : Text("${i + 1}",
                            style: TextStyle(
                                color: isActive ? Colors.black : Colors.white54,
                                fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(labels[i],
                      style: TextStyle(
                          fontSize: 11,
                          color: isActive ? yellow : Colors.white54)),
                ],
              ),
              if (i < 2)
                Container(
                  width: 40,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: isDone ? yellow : const Color(0xFF2A2A2A),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Précédent",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isPublishing
                  ? null
                  : (currentStep == 2 ? _publish : _nextStep),
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isPublishing
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      currentStep == 2 ? "PUBLIER LE FILM" : "Suivant  →",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}