import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favorites = provider.favoriteCourses;

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          'Gagal memuat data: ${provider.error}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (favorites.isEmpty) {
      return const Center(
        child: Text('Belum ada mata kuliah favorit.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final course = favorites[index];

        return CourseCard(
          course: course,
          isFavorite: provider.isFavorite(course.code),
          onToggleFavorite: () {
            context
                .read<CourseProvider>()
                .toggleFavorite(course.code);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(course: course),
              ),
            );
          },
        );
      },
    );
  }
}
