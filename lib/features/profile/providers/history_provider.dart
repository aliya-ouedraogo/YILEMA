import 'package:flutter/foundation.dart';

import '../data/profile_repository.dart';
import '../data/transaction_model.dart';
import '../data/watch_history_model.dart';

/// État de l'écran "Mon Historique" : liste des contenus vus, liste des
/// transactions, et onglet actuellement affiché.
class HistoryProvider extends ChangeNotifier {
  final _repository = ProfileRepository();

  List<WatchHistoryItemModel> visionnages = [];
  List<TransactionModel> transactions = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> chargerHistorique() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      visionnages = await _repository.fetchWatchHistory();
      transactions = await _repository.fetchTransactions();
    } catch (e) {
      errorMessage = "Impossible de charger l'historique";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Regroupe les visionnages par mois pour l'affichage
  /// (ex: "Février 2024" -> [Le Retour du Roi, Sira et le Tambour]).
  Map<String, List<WatchHistoryItemModel>> get visionnagesParMois {
    final Map<String, List<WatchHistoryItemModel>> groupes = {};
    for (final item in visionnages) {
      final cle = item.cleMois;
      if (groupes[cle] == null) {
        groupes[cle] = [];
      }
      groupes[cle]!.add(item);
    }
    return groupes;
  }

  Future<void> effacerTout() async {
    await _repository.effacerHistorique();
    visionnages = [];
    notifyListeners();
  }
}
