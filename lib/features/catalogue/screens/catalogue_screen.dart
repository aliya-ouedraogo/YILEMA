import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/movie_card.dart';
import '../providers/catalogue_provider.dart';
import '../data/content_model.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogueProvider>().loadContents();
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
            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
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

            final featured = provider.contents.first;
            final films = provider.contents.where((c) => c.type == 'film').toList();
            final series = provider.contents.where((c) => c.type == 'serie').toList();
            final docs = provider.contents.where((c) => c.type == 'documentaire').toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Yilema',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: AppColors.textPrimary),
                          onPressed: () => context.push('/search'),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: _FeaturedBanner(content: featured),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                if (films.isNotEmpty)
                  _MovieRow(title: 'Films', contents: films),

                if (series.isNotEmpty)
                  _MovieRow(title: 'Series', contents: series),

                if (docs.isNotEmpty)
                  _MovieRow(title: 'Documentaires', contents: docs),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner({required this.content});
  final ContentModel content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/content/${content.id}', extra: content),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (content.affiche != null)
              Image.network(content.affiche!, fit: BoxFit.cover)
            else
              Container(color: AppColors.surface),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.titre,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${content.anneeSortie} • ${content.duree} min',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.push('/player/${content.id}', extra: content),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Regarder'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/content/${content.id}', extra: content),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.textSecondary),
                        ),
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Infos'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieRow extends StatelessWidget {
  const _MovieRow({required this.title, required this.contents});
  final String title;
  final List<ContentModel> contents;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: contents.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = contents[index];
                return SizedBox(
                  width: 130,
                  child: MovieCard(
                    title: item.titre,
                    subtitle: '${item.anneeSortie}',
                    posterUrl: item.affiche ?? '',
                    badges: const [],
                    onTap: () => context.push('/content/${item.id}', extra: item),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}