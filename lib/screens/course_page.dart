
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'add_course_page.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int _selectedIndex = 0;

  static const String studentName =
      'Putu Agus Dedy Putra Adnyana';
  static const String studentNim = '2415051104';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF3F7FB),

          appBar: AppBar(
            title: const Text(
              'Course Explorer v2',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
          ),

          // Tombol tambah hanya muncul pada halaman Courses.
          floatingActionButton: _selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddCoursePage(),
                      ),
                    );
                  },
                  tooltip: 'Tambah mata kuliah',
                  child: const Icon(Icons.add),
                )
              : null,

          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                ),
              Expanded(
                child: _buildSelectedPage(provider),
              ),
            ],
          ),

          bottomNavigationBar: isWide
              ? null
              : BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  backgroundColor: const Color(0xFFE3F0FC),
                  selectedItemColor: const Color(0xFF174A7C),
                  unselectedItemColor: const Color(0xFF174A7C),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined),
                      activeIcon: Icon(Icons.menu_book),
                      label: 'Courses',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border),
                      activeIcon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSelectedPage(CourseProvider provider) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage(provider);
      case 1:
        return _buildCoursesPage(provider);
      case 2:
        return const FavoritesPage();
      default:
        return _buildHomePage(provider);
    }
  }

  Widget _buildHomePage(CourseProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NIM • Nama Mahasiswa',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20466F),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$studentNim • $studentName',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF20466F),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Courses',
                count: provider.courses.length,
                icon: Icons.menu_book,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Favorites',
                count: provider.favoriteCount,
                icon: Icons.favorite,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'My Courses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF20466F),
          ),
        ),
        const SizedBox(height: 12),
        if (provider.courses.isEmpty)
          const Text('Data course belum tersedia')
        else
          ...provider.courses.map((course) {
            return Card(
              color: const Color(0xFFFAFCFE),
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(
                  color: Color(0xFFC7D8E8),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20466F),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Kode: ${course.code}\n'
                    'SKS: ${course.credits}\n'
                    'Status: ${course.status}',
                  ),
                ),
                trailing: IconButton(
                  tooltip: provider.isFavorite(course.code)
                      ? 'Hapus dari favorit'
                      : 'Tambahkan ke favorit',
                  onPressed: () {
                    context
                        .read<CourseProvider>()
                        .toggleFavorite(course.code);
                  },
                  icon: Icon(
                    provider.isFavorite(course.code)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: provider.isFavorite(course.code)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(course: course),
                    ),
                  );
                },
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FB),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFA8CDE5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFF58728B),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF58728B),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF20466F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesPage(CourseProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    }

    if (provider.courses.isEmpty) {
      return const Center(
        child: Text('Data course belum tersedia'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Nama: $studentName',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('NIM: $studentNim'),
        const SizedBox(height: 16),
        ...provider.courses.map((course) {
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
        }),
      ],
    );
  }
}
