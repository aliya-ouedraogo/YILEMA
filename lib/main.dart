import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/catalogue/providers/catalogue_provider.dart';
import 'features/profile/providers/history_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/subscription/providers/subscription_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const YilemaApp());
}

class YilemaApp extends StatefulWidget {
  const YilemaApp({super.key});

  @override
  State<YilemaApp> createState() => _YilemaAppState();
}

class _YilemaAppState extends State<YilemaApp> {
  // Créés une seule fois ici (pas dans MultiProvider) car AppRouter a besoin
  // de la même instance d'AuthProvider pour écouter les changements de
  // connexion et rediriger automatiquement (voir redirect: dans app_router.dart).
  final _authProvider = AuthProvider();
  final _catalogueProvider = CatalogueProvider();
  late final _router = AppRouter.createRouter(_authProvider);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers de subscription, profile, reviews : ajoutés au fur et
        // à mesure. Ceux ci-dessous sont de Fadila (feature/subscription-profile).
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _catalogueProvider),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp.router(
        title: 'Yilema',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
