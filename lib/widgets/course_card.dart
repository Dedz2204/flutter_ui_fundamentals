import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(course.title),
        subtitle: Text(
          'Kode: ${course.code}\n'
          'SKS: ${course.credits}\n'
          'Status: ${course.status}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: onToggleFavorite,
          icon: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
