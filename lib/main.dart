import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/catalogue/providers/catalogue_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const FasoCineApp());
}

class FasoCineApp extends StatelessWidget {
  const FasoCineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Chaque feature expose son propre provider.
        // Ajoutez ici les providers de subscription, profile, reviews
        // au fur et à mesure qu'ils seront développés.
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CatalogueProvider()),
      ],
      child: MaterialApp.router(
        title: 'Faso Ciné',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
