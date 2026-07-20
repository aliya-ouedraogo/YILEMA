import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/transaction_model.dart';
import '../../data/watch_history_model.dart';
import '../../providers/history_provider.dart';

/// Écran "Mon Historique" : deux onglets, Vus récemment et Transactions.
/// Voir maquettes : historique1.jpeg (Vus récemment), historiq2.jpeg (Transactions)
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().chargerHistorique();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmerSuppression() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Tout effacer ?'),
        content: const Text(
            "Cette action supprime tout l'historique de visionnage."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Effacer',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirme == true && mounted) {
      await context.read<HistoryProvider>().effacerTout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('MON HISTORIQUE',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Vus récemment'),
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _OngletVisionnages(
                  groupes: provider.visionnagesParMois,
                  onEffacerTout: _confirmerSuppression,
                ),
                _OngletTransactions(transactions: provider.transactions),
              ],
            ),
    );
  }
}

/// Onglet "Vus récemment" : liste groupée par mois avec barre de progression.
class _OngletVisionnages extends StatelessWidget {
  final Map<String, List<WatchHistoryItemModel>> groupes;
  final VoidCallback onEffacerTout;

  const _OngletVisionnages(
      {required this.groupes, required this.onEffacerTout});

  @override
  Widget build(BuildContext context) {
    if (groupes.isEmpty) {
      return const Center(child: Text('Aucun visionnage pour le moment.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final mois in groupes.keys) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(mois,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton(
                onPressed: onEffacerTout,
                child: const Text('TOUT EFFACER'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in groupes[mois]!) _LigneVisionnage(item: item),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _LigneVisionnage extends StatelessWidget {
  final WatchHistoryItemModel item;

  const _LigneVisionnage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 70,
              height: 100,
              color: AppColors.surface,
              child: const Icon(Icons.movie_outlined,
                  color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(item.dureeRestante,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.progressionPourcent / 100,
                    backgroundColor: AppColors.surfaceElevated,
                    color: AppColors.accent,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${item.progressionPourcent.toInt()}% terminé',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }
}

/// Onglet "Transactions" : historique des paiements.
class _OngletTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _OngletTransactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Aucune transaction pour le moment.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Historique des paiements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        for (final transaction in transactions)
          _CarteTransaction(transaction: transaction),
      ],
    );
  }
}

class _CarteTransaction extends StatelessWidget {
  final TransactionModel transaction;

  const _CarteTransaction({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long_outlined,
                  color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    '${_formaterDate(transaction.date)} • ${transaction.methodePaiement}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${transaction.montant.toInt()} F CFA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (transaction.estReussi
                            ? AppColors.success
                            : AppColors.danger)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.estReussi ? 'SUCCÈS' : 'ÉCHEC',
                    style: TextStyle(
                      color: transaction.estReussi
                          ? AppColors.success
                          : AppColors.danger,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formaterDate(DateTime date) {
    const mois = [
      'Janv',
      'Fév',
      'Mars',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Août',
      'Sept',
      'Oct',
      'Nov',
      'Déc',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${mois[date.month - 1]}. ${date.year}';
  }
}
