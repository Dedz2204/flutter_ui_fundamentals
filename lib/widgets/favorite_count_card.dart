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
      child: ListTile(
        leading: const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        title: const Text('Jumlah Favorit'),
        trailing: Text(
          '$count',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
