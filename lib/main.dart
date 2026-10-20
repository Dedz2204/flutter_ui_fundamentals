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
      title: 'Praktikum Provider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CoursePage(),
    );
  }
}

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  final List<Map<String, String>> courses = const [
    {'code': 'JK', 'name': 'Jaringan Komputer'},
    {'code': 'PBM', 'name': 'Pemrograman Berbasis Mobile'},
    {'code': 'BD', 'name': 'Basis Data'},
    {'code': 'AI', 'name': 'Artificial Intelligence'},
  ];

  @override
  Widget build(BuildContext context) {
    // watch: halaman mendengarkan perubahan jumlah favorit.
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Provider'),
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('NIM: 2415051104'),
            const SizedBox(height: 20),

            // Consumer: membatasi rebuild pada bagian jumlah favorit.
            Consumer<CourseProvider>(
              builder: (context, courseProvider, child) {
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: const Text('Jumlah Favorit'),
                    trailing: Text(
                      '${courseProvider.favoriteCount}',
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
            const Text(
              'Daftar Mata Kuliah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final isFavorite =
                      provider.isFavorite(course['code']!);

                  return Card(
                    child: ListTile(
                      title: Text(course['name']!),
                      subtitle: Text('Kode: ${course['code']}'),
                      trailing: IconButton(
                        // read: memanggil aksi tanpa listen.
                        onPressed: () {
                          context
                              .read<CourseProvider>()
                              .toggleFavorite(course['code']!);
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
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
