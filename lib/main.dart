import 'package:flutter/material.dart';
import 'course_state.dart';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 5 - ChangeNotifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const CoursePage(),
    );
  }
}

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // Object state dibuat satu kali dan digunakan bersama.
  final CourseState courseState = CourseState();

  @override
  void dispose() {
    courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChangeNotifier'),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Putu Agus Dedy Putra Adnyana',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('NIM: 2415051104'),
          const SizedBox(height: 24),

          const Text(
            'Daftar Mata Kuliah',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Menampilkan jumlah favorit yang selalu diperbarui.
          AnimatedBuilder(
            animation: courseState,
            builder: (context, child) {
              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: const Text('Jumlah Favorit'),
                  trailing: Text(
                    '${courseState.favoriteCount}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          CourseFavoriteCard(
            courseState: courseState,
            courseId: 'jaringan',
            courseName: 'Jaringan Komputer',
            description:
                'Mempelajari perangkat dan komunikasi jaringan.',
          ),

          const SizedBox(height: 12),

          CourseFavoriteCard(
            courseState: courseState,
            courseId: 'pemrograman',
            courseName: 'Pemrograman',
            description:
                'Mempelajari logika dan pembuatan program.',
          ),

          const SizedBox(height: 20),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'CourseState mengelola state favorit. '
                'Ketika toggleFavorite() dipanggil, '
                'notifyListeners() memberi tahu widget '
                'yang mendengarkan agar memperbarui tampilan.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget child yang mendengarkan perubahan CourseState.
class CourseFavoriteCard extends StatelessWidget {
  final CourseState courseState;
  final String courseId;
  final String courseName;
  final String description;

  const CourseFavoriteCard({
    super.key,
    required this.courseState,
    required this.courseId,
    required this.courseName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: courseState,
      builder: (context, child) {
        final bool isFavorite =
            courseState.isFavorite(courseId);

        return Card(
          child: ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(courseName),
            subtitle: Text(
              '$description\n'
              '${isFavorite ? "Sudah menjadi favorit" : "Belum menjadi favorit"}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: isFavorite
                  ? 'Hapus dari favorit'
                  : 'Tambah ke favorit',
              onPressed: () {
                courseState.toggleFavorite(courseId);
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
