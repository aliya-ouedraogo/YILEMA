import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/content_model.dart';

class ContentDetailScreen extends StatelessWidget {
  final ContentModel content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: content.affiche != null
                  ? Image.network(content.affiche!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[800]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.titre,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(content.anneeSortie.toString()),
                      const SizedBox(width: 12),
                      Text('${content.duree} min'),
                      const SizedBox(width: 12),
                      Chip(label: Text(content.type)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content.synopsis,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/player/${content.id}', extra: content);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Regarder'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}