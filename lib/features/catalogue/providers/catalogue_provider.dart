import 'package:flutter/foundation.dart';

import '../data/catalogue_repository.dart';
import '../data/content_model.dart';

class CatalogueProvider extends ChangeNotifier {
  final _repository = CatalogueRepository();

  // ⚠️ Mettre a false quand l'API sera prete
  static const bool _useMockData = false;

  final List<ContentModel> _mockContents = [
    ContentModel(
      id: 1,
      titre: 'Wend Kuuni',
      synopsis: 'Un enfant muet recueilli par une famille dans le Burkina Faso traditionnel.',
      type: 'film',
      anneeSortie: 1982,
      duree: 75,
      urlVideo: '',
      affiche: 'https://picsum.photos/seed/wendkuuni/300/450',
    ),
    ContentModel(
      id: 2,
      titre: 'Tasuma',
      synopsis: 'Un ancien combattant se bat pour ses droits et sa dignite.',
      type: 'film',
      anneeSortie: 2004,
      duree: 90,
      urlVideo: '',
      affiche: 'https://picsum.photos/seed/tasuma/300/450',
    ),
    ContentModel(
      id: 3,
      titre: 'Ouaga Stories',
      synopsis: 'Une serie suivant plusieurs familles dans la capitale burkinabe.',
      type: 'serie',
      anneeSortie: 2021,
      duree: 45,
      urlVideo: '',
      affiche: 'https://picsum.photos/seed/ouagastories/300/450',
    ),
    ContentModel(
      id: 4,
      titre: 'FESPACO, 50 ans de cinema',
      synopsis: 'Documentaire retracant l\'histoire du plus grand festival de cinema africain.',
      type: 'documentaire',
      anneeSortie: 2019,
      duree: 60,
      urlVideo: '',
      affiche: 'https://picsum.photos/seed/fespaco/300/450',
    ),
    ContentModel(
      id: 5,
      titre: 'Sya, le reve du python',
      synopsis: 'Un conte initiatique inspire des legendes mandingues.',
      type: 'film',
      anneeSortie: 2016,
      duree: 82,
      urlVideo: '',
      affiche: 'https://picsum.photos/seed/sya/300/450',
    ),
    ContentModel(
      id: 6,
      titre: 'Terre de resistance',
      synopsis: 'Documentaire sur les luttes sociales contemporaines en Afrique de l\'Ouest.',
      type: 'documentaire',
      anneeSortie: 2022,
      duree: 52,
      urlVideo: '',
      affiche: 'https://picsum.photos/seed/terre/300/450',
    ),
  ];

  List<ContentModel> contents = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadContents() async {
    isLoading = true;
    notifyListeners();

    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      contents = _mockContents;
      errorMessage = null;
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      contents = await _repository.getContents();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}