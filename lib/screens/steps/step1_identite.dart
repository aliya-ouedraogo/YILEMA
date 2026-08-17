// lib/screens/steps/step1_identite.dart
//
// Étape 1 : titre, genre, synopsis.
// "onChanged" est appelé à chaque saisie pour rafraîchir l'écran parent
// (utile plus tard si tu veux activer/désactiver le bouton Suivant).

import 'package:flutter/material.dart';
import '../../models/film_model.dart';

class Step1Identite extends StatefulWidget {
  final Film film;
  final VoidCallback onChanged;

  const Step1Identite({super.key, required this.film, required this.onChanged});

  @override
  State<Step1Identite> createState() => _Step1IdentiteState();
}

class _Step1IdentiteState extends State<Step1Identite> {
  static const Color fieldColor = Color(0xFF1A1A1A);
  static const Color yellow = Color(0xFFF5C518);
  static const Color greyText = Color(0xFF9A9A9A);

  late TextEditingController titleCtrl;
  late TextEditingController synopsisCtrl;

  final genres = ["Drame", "Action", "Documentaire", "Comédie"];

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.film.originalTitle);
    synopsisCtrl = TextEditingController(text: widget.film.synopsis);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("DÉTAILS DU FILM",
              style: TextStyle(
                  color: yellow, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          const Text("Titre Original",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          TextField(
            controller: titleCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Entrez le titre...",
              hintStyle: const TextStyle(color: greyText),
              filled: true,
              fillColor: fieldColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) {
              widget.film.originalTitle = v;
              widget.onChanged();
            },
          ),
          const SizedBox(height: 20),

          const Text("Genre Principal",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: genres.map((g) {
              final isSelected = widget.film.mainGenre == g;
              return GestureDetector(
                onTap: () {
                  setState(() => widget.film.mainGenre = g);
                  widget.onChanged();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? yellow : fieldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(g,
                      style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          const Text("Synopsis", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          TextField(
            controller: synopsisCtrl,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Décrivez l'âme de votre œuvre...",
              hintStyle: const TextStyle(color: greyText),
              filled: true,
              fillColor: fieldColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) {
              widget.film.synopsis = v;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}