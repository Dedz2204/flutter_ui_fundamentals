import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 6 - Provider',
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

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>()
        .favoriteCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider pada Widget Tree'),
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

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: const Text('Jumlah Favorit'),
              trailing: Text(
                '$favoriteCount',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Daftar Mata Kuliah',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const CourseCard(
            courseId: 'jaringan',
            courseName: 'Jaringan Komputer',
            description:
                'Mempelajari perangkat dan komunikasi jaringan.',
          ),

          const SizedBox(height: 12),

          const CourseCard(
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
                'CourseProvider disediakan pada widget tree '
                'melalui ChangeNotifierProvider. Widget yang '
                'membutuhkan data dapat mengaksesnya dengan '
                'Provider tanpa meneruskan object melalui '
                'constructor setiap widget.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String description;

  const CourseCard({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isFavorite = provider.isFavorite(courseId);

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
            context
                .read<CourseProvider>()
                .toggleFavorite(courseId);
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
  }
}
