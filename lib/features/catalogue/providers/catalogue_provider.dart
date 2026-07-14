import 'package:flutter/foundation.dart';

import '../data/catalogue_repository.dart';
import '../data/content_model.dart';

class CatalogueProvider extends ChangeNotifier {
  final _repository = CatalogueRepository();

  List<ContentModel> contents = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadContents() async {
    isLoading = true;
    notifyListeners();

    try {
      contents = await _repository.getContents();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Impossible de charger le catalogue';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
