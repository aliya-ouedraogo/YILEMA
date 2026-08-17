// lib/screens/admin_dashboard_screen.dart
//
// Dashboard "ADMIN CONSOLE" (différent du Dashboard Réalisateur fait avant).
// Frontend pur avec données statiques - à connecter plus tard à
// ApiService.getDashboardStats() et à un service de "validation" (approuver/rejeter).

import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color bgColor = Color(0xFF0D0D0D);
  static const Color cardColor = Color(0xFF141414);
  static const Color yellow = Color(0xFFF5C518);
  static const Color green = Color(0xFF2E7D32);
  static const Color red = Color(0xFFB33A3A);
  static const Color greyText = Color(0xFF9A9A9A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildStatCards(),
              const SizedBox(height: 20),
              _buildSubscriberDonut(),
              const SizedBox(height: 20),
              _buildPendingValidation(),
              const SizedBox(height: 20),
              _buildSystemAlerts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("DASHBOARD OVERVIEW",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const Text("Bienvenue, voici les dernières performances de la plateforme.",
            style: TextStyle(color: greyText, fontSize: 13)),
        const SizedBox(height: 16),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24)),
              icon: const Icon(Icons.download, color: Colors.white, size: 16),
              label: const Text("Exporter Rapport", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: naviguer vers AddFilmFlowScreen
              },
              style: ElevatedButton.styleFrom(backgroundColor: yellow),
              icon: const Icon(Icons.add, color: Colors.black, size: 16),
              label: const Text("Nouveau Contenu", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    final stats = [
      {"label": "UTILISATEURS", "value": "42,850", "delta": "↗12%", "color": yellow},
      {"label": "ABONNÉS", "value": "12,104", "delta": "↗8.4%", "color": green},
      {"label": "FILMS EN LIGNE", "value": "843", "delta": "−0%", "color": green},
      {"label": "REVENU MENSUEL", "value": "€24,500", "delta": "↗15%", "color": yellow},
      {"label": "EN ATTENTE", "value": "18", "delta": "24h", "color": red},
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final s = stats[i];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border(left: BorderSide(color: s["color"] as Color, width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s["delta"] as String,
                    style: TextStyle(color: s["color"] as Color, fontSize: 11)),
                const Spacer(),
                Text(s["value"] as String,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(s["label"] as String,
                    style: const TextStyle(color: greyText, fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubscriberDonut() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Répartition Abonnés",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.7,
                      strokeWidth: 12,
                      backgroundColor: green,
                      valueColor: const AlwaysStoppedAnimation(yellow),
                    ),
                  ),
                  const Column(
                    children: [
                      Text("12.1k", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("Total", style: TextStyle(color: greyText, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendDot(yellow, "Premium", "70%"),
                  const SizedBox(height: 8),
                  _legendDot(green, "Gratuit", "30%"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label, String value) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text("$label  ", style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildPendingValidation() {
    final items = [
      {"title": "L'Ombre du Sahel", "producer": "S. Ouédraogo", "genre": "Drame | 1h45", "date": "12/05/2024"},
      {"title": "Marché de Cœur", "producer": "M. Traoré", "genre": "Romance | 1h32", "date": "13/05/2024"},
      {"title": "Nuits de Ouaga", "producer": "Studio Faso", "genre": "Docu | 52min", "date": "14/05/2024"},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Validation en attente",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("Tout voir", style: TextStyle(color: yellow))),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(width: 36, height: 48, color: Colors.white10),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f["title"] as String, style: const TextStyle(color: Colors.white)),
                          Text("${f["producer"]} · ${f["genre"]}",
                              style: const TextStyle(color: greyText, fontSize: 11)),
                        ],
                      ),
                    ),
                    Text(f["date"] as String, style: const TextStyle(color: greyText, fontSize: 11)),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: green, size: 20),
                      onPressed: () {
                        // TODO: appeler ApiService pour approuver le film
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: red, size: 20),
                      onPressed: () {
                        // TODO: appeler ApiService pour rejeter le film
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSystemAlerts() {
    final alerts = [
      {"icon": Icons.warning_amber, "color": red, "title": "Serveur Streaming Saturation", "desc": "Le serveur S2 atteint 92% de sa capacité."},
      {"icon": Icons.info_outline, "color": yellow, "title": "Mise à jour FESPACO", "desc": "Catégories Awards 2024 synchronisées."},
      {"icon": Icons.shield_outlined, "color": green, "title": "Nouvel Admin Connecté", "desc": "A. Konaté a rejoint la session console."},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Alertes Système",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...alerts.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(a["icon"] as IconData, color: a["color"] as Color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a["title"] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 13)),
                          Text(a["desc"] as String,
                              style: const TextStyle(color: greyText, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}