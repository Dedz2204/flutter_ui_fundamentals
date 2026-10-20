import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/favorite_count_card.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Daftar Mata Kuliah'
              : 'Mata Kuliah Favorit',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama: Putu Agus Dedy Putra Adnyana',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('NIM: 2415051104'),
                const SizedBox(height: 12),
                FavoriteCountCard(
                  count: provider.favoriteCount,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: _selectedIndex == 0
                ? _buildCourseList(provider)
                : const FavoritesPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Mata Kuliah',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Favorit (${provider.favoriteCount})',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(CourseProvider provider) {
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

    if (provider.courses.isEmpty) {
      return const Center(
        child: Text('Belum ada data mata kuliah.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: provider.courses.length,
      itemBuilder: (context, index) {
        final course = provider.courses[index];

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
