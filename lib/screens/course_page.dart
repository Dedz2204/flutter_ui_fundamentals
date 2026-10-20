import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/favorite_count_card.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mata Kuliah'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama: Putu Agus Dedy Putra Adnyana',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('NIM: 2415051104'),
            const SizedBox(height: 16),

            FavoriteCountCard(
              count: provider.favoriteCount,
            ),

            const SizedBox(height: 12),

            const Text(
              'Daftar Mata Kuliah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            if (provider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (provider.error != null)
              Expanded(
                child: Center(
                  child: Text(
                    'Gagal memuat data: ${provider.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (provider.courses.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Belum ada data mata kuliah.',
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];

                    return CourseCard(
                      course: course,
                      isFavorite:
                          provider.isFavorite(course.code),
                      onToggleFavorite: () {
                        context
                            .read<CourseProvider>()
                            .toggleFavorite(course.code);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
