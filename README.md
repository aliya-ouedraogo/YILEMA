# Yilema — App Mobile Flutter

## Architecture

Organisation **par fonctionnalité** (feature-first), pas par type de fichier.
Chaque dossier dans `lib/features/` correspond à une entité du diagramme de
classes et peut être développé en parallèle par un membre de l'équipe sans
conflit Git avec les autres.

```
lib/
├── main.dart                  # point d'entrée, déclare les providers globaux
├── core/                      # tout ce qui est partagé entre features
│   ├── constants/              # URLs API, constantes globales
│   ├── network/                # client HTTP (Dio) + gestion du token JWT
│   ├── theme/                  # couleurs, styles de texte
│   ├── utils/                  # validateurs, formatteurs (dates, FCFA...)
│   └── widgets/                # boutons, loaders, etc. réutilisables
├── features/
│   ├── auth/                   # Utilisateur : inscription, connexion, profil
│   ├── catalogue/               # Contenu, Film, Serie, Documentaire, Categorie
│   ├── player/                  # lecteur vidéo (Episode inclus)
│   ├── subscription/            # Abonnement, Paiement
│   ├── profile/                 # HistoriqueVisionnage, gestion du compte
│   └── reviews/                 # Avis (notes, commentaires)
└── routes/
    └── app_router.dart          # toutes les routes de navigation, centralisées
```

Chaque feature suit la même sous-structure :
- `data/` — modèles (`*_model.dart`) + repository qui appelle l'API Django
- `providers/` — état de la feature (`ChangeNotifier`), consommé par l'UI
- `presentation/screens/` — écrans complets
- `presentation/widgets/` — composants réutilisables propres à la feature

## Règle à suivre en équipe

Le repository (`data/`) ne fait *que* des appels API et retourne des modèles.
Le provider ne fait *que* gérer l'état (loading, erreur, données).
L'écran ne fait *que* afficher l'état du provider. Ne mélangez pas les trois.

## Prochaines étapes

1. `flutter pub get` pour installer les dépendances
2. Adapter `ApiConstants.baseUrl` une fois le backend Django déployé
3. Compléter `subscription/`, `profile/`, `player/`, `reviews/` sur le même
   modèle que `auth/` et `catalogue/` (déjà scaffoldés)
4. Générer les modèles manquants à partir de la réponse réelle de l'API
   (attention aux noms de champs `snake_case` du backend Django)
