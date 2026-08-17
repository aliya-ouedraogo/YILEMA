// lib/screens/steps/step2_medias.dart
//
// Étape 2 : affiche principale (obligatoire), bande-annonce (lien), galerie photo.
// La sélection réelle de fichier utilise file_picker ou image_picker
// (ajoute le package plus tard : je laisse un TODO clair).

import 'package:flutter/material.dart';
import '../../models/film_model.dart';

class Step2Medias extends StatefulWidget {
  final Film film;
  final VoidCallback onChanged;

  const Step2Medias({super.key, required this.film, required this.onChanged});

  @override
  State<Step2Medias> createState() => _Step2MediasState();
}

class _Step2MediasState extends State<Step2Medias> {
  static const Color fieldColor = Color(0xFF1A1A1A);
  static const Color yellow = Color(0xFFF5C518);
  static const Color greyText = Color(0xFF9A9A9A);

  late TextEditingController trailerCtrl;

  @override
  void initState() {
    super.initState();
    trailerCtrl = TextEditingController(text: widget.film.trailerLink ?? '');
  }

  Future<void> _pickPoster() async {
    // TODO: remplacer par un vrai file_picker / image_picker
    // pubspec.yaml -> dependencies: image_picker: ^1.1.2
    //
    // final picker = ImagePicker();
    // final img = await picker.pickImage(source: ImageSource.gallery);
    // if (img != null) { setState(() => widget.film.posterPath = img.path); widget.onChanged(); }
    setState(() => widget.film.posterPath = "affiche_choisie.jpg");
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("MÉDIAS DU FILM",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Row(
            children: const [
              Text("Affiche Principale",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              Text(" *", style: TextStyle(color: Colors.red)),
            ],
          ),
          const Text("Ratio recommandé 2:3 (ex: 800×1200px), format JPG ou PNG, max 5Mo.",
              style: TextStyle(color: greyText, fontSize: 12)),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickPoster,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        color: widget.film.posterPath != null ? yellow : greyText,
                        size: 32),
                    const SizedBox(height: 10),
                    Text(
                      widget.film.posterPath ??
                          "Cliquer pour télécharger\nou glisser-déposer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.film.posterPath != null
                              ? Colors.white
                              : greyText,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text("Bande-annonce (Lien vidéo)",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: trailerCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.link, color: greyText),
              hintText: "Lien YouTube ou Vimeo",
              hintStyle: const TextStyle(color: greyText),
              filled: true,
              fillColor: fieldColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) {
              widget.film.trailerLink = v;
              widget.onChanged();
            },
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Galerie Photo (Optionnel)",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              Text("${widget.film.galleryPaths.length} / 5",
                  style: const TextStyle(color: greyText, fontSize: 12)),
            ],
          ),
          const Text("Photos de tournage ou extraits (Max 5 images).",
              style: TextStyle(color: greyText, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // TODO: ajouter une photo à widget.film.galleryPaths
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add_photo_alternate_outlined,
                      color: greyText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}