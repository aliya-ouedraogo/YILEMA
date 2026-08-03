import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/payment_method.dart';
import '../../data/subscription_plan_model.dart';
import '../../providers/subscription_provider.dart';

/// Écran "Abonnement" : choix du plan (Gratuit / Premium / Famille),
/// comparatif des services, choix du moyen de paiement Mobile Money,
/// et récapitulatif avant paiement.
/// Voir maquette : Abonnement — Faso Ciné (Branding Update).png
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().chargerPlans();
    });
  }

  Future<void> _ouvrirDialogueConfirmation() async {
    final controllerTelephone = TextEditingController();
    final provider = context.read<SubscriptionProvider>();

    final numero = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Confirmer le paiement'),
          content: TextField(
            controller: controllerTelephone,
            keyboardType: TextInputType.phone,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Numéro Mobile Money',
              hintText: 'Ex: 70 00 00 00',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, controllerTelephone.text.trim()),
              child: const Text('PAYER'),
            ),
          ],
        );
      },
    );

    if (numero == null || numero.isEmpty || !mounted) return;

    final succes = await provider.confirmerAbonnement(numero);

    if (!mounted) return;
    if (succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abonnement activé avec succès !')),
      );
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('FASO CINÉ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.accent)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Center(
                        child: Text(
                          'CHOISISSEZ VOTRE ÉPOPÉE',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: AppColors.accent),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          'Soutenez le cinéma Burkinabè et accédez à des exclusivités FESPACO.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 24),
                      for (final plan in provider.plans)
                        _CartePlan(
                          plan: plan,
                          estSelectionne: provider.planChoisi?.id == plan.id,
                          onTap: () => provider.choisirPlan(plan),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        'COMPARAISON DES SERVICES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      const _ComparaisonServices(),
                      const SizedBox(height: 24),
                      const Text(
                        'MODE DE PAIEMENT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      for (final methode in PaymentMethod.values)
                        _CarteMoyenPaiement(
                          methode: methode,
                          estSelectionne: provider.methodeChoisie == methode,
                          onTap: () => provider.choisirMethodePaiement(methode),
                        ),
                      const SizedBox(height: 24),
                      if (provider.planChoisi != null)
                        _Recapitulatif(plan: provider.planChoisi!),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: "S'abonner maintenant",
                        trailingIcon: Icons.bolt,
                        isLoading: provider.isPaiementEnCours,
                        onPressed: provider.planChoisi == null
                            ? null
                            : _ouvrirDialogueConfirmation,
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Paiement sécurisé par cryptage de bout en bout.',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _BadgesSecurite(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _CartePlan extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool estSelectionne;
  final VoidCallback onTap;

  const _CartePlan(
      {required this.plan, required this.estSelectionne, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: estSelectionne ? AppColors.accent : Colors.transparent,
            width: 2),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      plan.badge,
                      style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(plan.nom,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(
                        plan.prixMensuel == 0
                            ? '0'
                            : plan.prixMensuel.toInt().toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text('CFA/mois',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (final avantage in plan.avantages)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(avantage,
                                  style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (plan.estPopulaire)
            Positioned(
              top: -1,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: const Text('POPULAIRE',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComparaisonServices extends StatelessWidget {
  const _ComparaisonServices();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.high_quality, 'Qualité Vidéo', 'SD à Ultra HD 4K'),
      (Icons.devices, 'Appareils', '1 à 5 connexions'),
      (Icons.download_outlined, 'Téléchargement', 'Premium & Famille'),
      (Icons.star_border, 'Avant-Premières', 'Membres VIP Gold'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.$1, size: 20, color: AppColors.textPrimary),
                const SizedBox(height: 8),
                Text(item.$2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(item.$3,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
      ],
    );
  }
}

class _CarteMoyenPaiement extends StatelessWidget {
  final PaymentMethod methode;
  final bool estSelectionne;
  final VoidCallback onTap;

  const _CarteMoyenPaiement(
      {required this.methode,
      required this.estSelectionne,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final estOrange = methode == PaymentMethod.orangeMoney;
    final couleurLogo =
        estOrange ? const Color(0xFFFF6600) : const Color(0xFF0072CE);
    final sousTitre = estOrange ? 'Burkina Faso' : 'Flooz Services';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: estSelectionne ? AppColors.accent : Colors.transparent,
            width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: couleurLogo,
                child: Text(estOrange ? 'O' : 'M',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(methode.libelle,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(sousTitre,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Radio<bool>(
                value: true,
                groupValue: estSelectionne,
                onChanged: (_) => onTap(),
                fillColor: WidgetStateProperty.all(AppColors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Recapitulatif extends StatelessWidget {
  final SubscriptionPlanModel plan;

  const _Recapitulatif({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RÉCAPITULATIF',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Forfait ${plan.nom}'),
              Text('${plan.prixMensuel.toInt()} CFA')
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Taxe (TVA 18%)'), Text('Inclus')],
          ),
          const Divider(height: 24, color: AppColors.surfaceElevated),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL À PAYER',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${plan.prixMensuel.toInt()} CFA',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgesSecurite extends StatelessWidget {
  const _BadgesSecurite();

  @override
  Widget build(BuildContext context) {
    const badges = [
      (Icons.shield_outlined, 'SÉCURISÉ'),
      (Icons.credit_card, 'PCI-DSS'),
      (Icons.lock_outline, 'AES-256'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final badge in badges)
          Column(
            children: [
              Icon(badge.$1, size: 18, color: AppColors.textSecondary),
              const SizedBox(height: 4),
              Text(badge.$2,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
      ],
    );
  }
}
