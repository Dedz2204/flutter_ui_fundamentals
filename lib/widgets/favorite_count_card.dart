import 'package:flutter/material.dart';

class FavoriteCountCard extends StatelessWidget {
  final int count;

  const FavoriteCountCard({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.favorite,
              size: 28,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            const Text('Favorites'),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
