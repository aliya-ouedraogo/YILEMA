// lib/screens/steps/step3_diffusion.dart
//
// Étape 3 : modèle économique, droits territoriaux, date de sortie,
// acceptation des conditions. C'est la dernière étape avant publication
// (le bouton "PUBLIER LE FILM" est géré par l'écran parent add_film_flow_screen.dart).
 
import 'package:flutter/material.dart';
import '../../models/film_model.dart';
 
class Step3Diffusion extends StatefulWidget {
  final Film film;
  final VoidCallback onChanged;
 
  const Step3Diffusion({super.key, required this.film, required this.onChanged});
 
  @override
  State<Step3Diffusion> createState() => _Step3DiffusionState();
}
 
class _Step3DiffusionState extends State<Step3Diffusion> {
  static const Color fieldColor = Color(0xFF1A1A1A);
  static const Color yellow = Color(0xFFF5C518);
  static const Color green = Color(0xFF2E7D32);
  static const Color greyText = Color(0xFF9A9A9A);
 
  final allTerritories = ["Burkina Faso", "Afrique de l'Ouest", "Monde Entier"];
 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PARAMÈTRES DE DIFFUSION",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
              "Définissez comment et où votre œuvre sera disponible pour le public.",
              style: TextStyle(color: greyText, fontSize: 13)),
          const SizedBox(height: 24),
 
          const Text("Modèle Économique",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _economicOption(
            value: "free",
            icon: Icons.bolt,
            title: "Gratuit",
            subtitle: "Accessible à tous les utilisateurs avec publicité.",
          ),
          _economicOption(
            value: "ppv",
            icon: Icons.confirmation_number_outlined,
            title: "Location (PPV)",
            subtitle: "Paiement à l'acte pour une durée de 48h.",
          ),
          _economicOption(
            value: "premium",
            icon: Icons.star_border,
            title: "Exclusif Abonnés",
            subtitle: "Inclus dans l'abonnement Premium.",
          ),
          const SizedBox(height: 24),
 
          const Text("Droits Territoriaux",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: allTerritories.map((territory) {
                final isChecked = widget.film.territorialRights.contains(territory);
                return CheckboxListTile(
                  value: isChecked,
                  activeColor: green,
                  title: Text(territory, style: const TextStyle(color: Colors.white)),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        widget.film.territorialRights = [
                          ...widget.film.territorialRights,
                          territory
                        ];
                      } else {
                        widget.film.territorialRights = widget.film.territorialRights
                            .where((t) => t != territory)
                            .toList();
                      }
                    });
                    widget.onChanged();
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
 
          const Text("Date de Sortie Programmée",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() => widget.film.releaseDate = picked);
                widget.onChanged();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: greyText, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    widget.film.releaseDate == null
                        ? "mm/dd/yyyy"
                        : "${widget.film.releaseDate!.month.toString().padLeft(2, '0')}/"
                          "${widget.film.releaseDate!.day.toString().padLeft(2, '0')}/"
                          "${widget.film.releaseDate!.year}",
                    style: TextStyle(
                        color: widget.film.releaseDate == null
                            ? greyText
                            : Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
 
          CheckboxListTile(
            value: widget.film.acceptedTerms,
            activeColor: yellow,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (v) {
              setState(() => widget.film.acceptedTerms = v ?? false);
              widget.onChanged();
            },
            title: const Text(
              "J'accepte les conditions de distribution et confirme détenir les droits d'auteur nécessaires pour ce contenu.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _economicOption({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = widget.film.economicModel == value;
    return GestureDetector(
      onTap: () {
        setState(() => widget.film.economicModel = value);
        widget.onChanged();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? yellow : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? yellow : Colors.white70),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: const TextStyle(color: greyText, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: green, size: 22),
          ],
        ),
      ),
    );
  }
}
 