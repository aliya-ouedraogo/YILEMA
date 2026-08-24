import 'package:flutter/foundation.dart';

import '../../auth/data/user_model.dart';
import '../data/profile_repository.dart';
import '../data/watch_history_model.dart';

/// État de l'écran Profil : infos utilisateur + contenu "Continuer la lecture".
class ProfileProvider extends ChangeNotifier {
  final _repository = ProfileRepository();

  UserModel? utilisateur;
  WatchHistoryItemModel? enCoursDeLecture;
  bool isLoading = false;
  String? errorMessage;

  Future<void> chargerProfil() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      utilisateur = await _repository.fetchProfile();

      // "Continuer la lecture" = le premier contenu de l'historique qui
      // n'est pas encore terminé (progression < 100%).
      final historique = await _repository.fetchWatchHistory();
      enCoursDeLecture = null;
      for (final item in historique) {
        if (item.progressionPourcent < 100) {
          enCoursDeLecture = item;
          break;
        }
      }
    } catch (e) {
      errorMessage = 'Impossible de charger le profil';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
