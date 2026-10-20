import 'package:flutter/material.dart';

void main() {
  runApp(const CourseExplorerApp());
}

// Identitas mahasiswa
const String studentName = 'Putu Agus Dedy Putra Adnyana';
const String studentId = '2415051104';

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const CourseListPage(),
    );
  }
}

// Model data course sederhana
class Course {
  final String code;
  final String title;
  final String description;
  final int credits;

  const Course({
    required this.code,
    required this.title,
    required this.description,
    required this.credits,
  });
}

// Data contoh
const List<Course> courses = [
  Course(
    code: 'MK001',
    title: 'Pemrograman Mobile',
    description:
        'Mempelajari pengembangan aplikasi mobile '
        'menggunakan Flutter dan Dart.',
    credits: 3,
  ),
  Course(
    code: 'MK002',
    title: 'Jaringan Komputer',
    description:
        'Mempelajari konsep jaringan, perangkat jaringan, '
        'dan komunikasi data.',
    credits: 3,
  ),
  Course(
    code: 'MK003',
    title: 'Basis Data',
    description:
        'Mempelajari perancangan database, tabel, '
        'relasi, dan pengolahan data.',
    credits: 3,
  ),
];

// Shared state sederhana untuk simulasi Tahap 1.
// Favorites dapat dibaca dan diubah dari beberapa halaman.
class FavoriteStore extends ChangeNotifier {
  final Set<String> _favoriteCodes = {};

  bool isFavorite(String code) {
    return _favoriteCodes.contains(code);
  }

  int get count => _favoriteCodes.length;

  List<Course> get favoriteCourses => courses
      .where((course) => _favoriteCodes.contains(course.code))
      .toList();

  void toggleFavorite(String code) {
    if (!_favoriteCodes.add(code)) {
      _favoriteCodes.remove(code);
    }

    notifyListeners();
  }
}

// Store dibuat satu kali agar state favorites dipakai bersama.
final FavoriteStore favoriteStore = FavoriteStore();

// Halaman daftar course
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  // LOCAL STATE:
  // Hanya digunakan oleh halaman daftar course ini.
  bool showDescription = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: [
          AnimatedBuilder(
            animation: favoriteStore,
            builder: (context, child) {
              return IconButton(
                tooltip: 'Course Favorit',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritesPage(),
                    ),
                  );
                },
                icon: Badge(
                  label: Text('${favoriteStore.count}'),
                  isLabelVisible: favoriteStore.count > 0,
                  child: const Icon(Icons.favorite),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Identitas mahasiswa
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text('NIM: $studentId'),
                SizedBox(height: 8),
                Text('Praktikum Pertemuan 6 - Tahap 1'),
              ],
            ),
          ),

          // Tombol demonstrasi local state
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    showDescription = !showDescription;
                  });
                },
                icon: Icon(
                  showDescription
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                label: Text(
                  showDescription
                      ? 'Sembunyikan Deskripsi'
                      : 'Tampilkan Deskripsi',
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Mata Kuliah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];

                return CourseCard(
                  course: course,
                  showDescription: showDescription,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(
                          course: course,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget kartu course
class CourseCard extends StatelessWidget {
  final Course course;
  final bool showDescription;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.showDescription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(course.code.substring(2)),
        ),
        title: Text(course.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode: ${course.code}'),
            Text('SKS: ${course.credits}'),
            if (showDescription) ...[
              const SizedBox(height: 6),
              Text(course.description),
            ],
          ],
        ),
        isThreeLine: showDescription,
        trailing: AnimatedBuilder(
          animation: favoriteStore,
          builder: (context, child) {
            final isFavorite =
                favoriteStore.isFavorite(course.code);

            return IconButton(
              tooltip: isFavorite
                  ? 'Hapus dari favorit'
                  : 'Tambah ke favorit',
              onPressed: () {
                favoriteStore.toggleFavorite(course.code);
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}

// Halaman detail course
class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              studentName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('NIM: $studentId'),
            const SizedBox(height: 24),
            Text(
              course.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text('Kode mata kuliah: ${course.code}'),
            Text('Jumlah SKS: ${course.credits}'),
            const SizedBox(height: 12),
            Text(course.description),
            const SizedBox(height: 24),

            // Shared state yang sama dengan halaman daftar
            AnimatedBuilder(
              animation: favoriteStore,
              builder: (context, child) {
                final isFavorite =
                    favoriteStore.isFavorite(course.code);

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      favoriteStore.toggleFavorite(course.code);
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman course favorit
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Favorit'),
      ),
      body: AnimatedBuilder(
        animation: favoriteStore,
        builder: (context, child) {
          final favorites = favoriteStore.favoriteCourses;

          return Column(
            children: [
              const ListTile(
                title: Text(studentName),
                subtitle: Text('NIM: $studentId'),
              ),
              Expanded(
                child: favorites.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada course favorit.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final course = favorites[index];

                          return ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            title: Text(course.title),
                            subtitle: Text(
                              '${course.code} • '
                              '${course.credits} SKS',
                            ),
                            trailing: IconButton(
                              tooltip: 'Hapus dari favorit',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                favoriteStore.toggleFavorite(
                                  course.code,
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CourseDetailPage(
                                    course: course,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
