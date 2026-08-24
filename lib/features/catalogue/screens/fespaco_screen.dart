import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/movie_card.dart';
import '../providers/catalogue_provider.dart';

class FespacoScreen extends StatefulWidget {
  const FespacoScreen({super.key});

  @override
  State<FespacoScreen> createState() => _FespacoScreenState();
}

class _FespacoScreenState extends State<FespacoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CatalogueProvider>();
      if (provider.contents.isEmpty) {
        provider.loadContents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<CatalogueProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }
            if (provider.contents.isEmpty) {
              return const Center(
                child: Text(
                  'Aucun contenu disponible',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events, color: AppColors.accent, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          'Collection FESPACO',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'Le meilleur du cinema africain, prime au Festival Panafricain du Cinema de Ouagadougou.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.52,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = provider.contents[index];
                        return MovieCard(
                          title: item.titre,
                          subtitle: '${item.anneeSortie}',
                          posterUrl: item.affiche ?? '',
                          badges: const [MovieBadge.fespaco],
                          onTap: () => context.push('/content/${item.id}', extra: item),
                        );
                      },
                      childCount: provider.contents.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}