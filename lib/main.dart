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
      title: 'Service Data Source',
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('NIM: 2415051104'),
            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                title: const Text('Jumlah Favorit'),
                trailing: Text(
                  '${provider.favoriteCount}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (provider.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.error != null)
              Expanded(
                child: Center(
                  child: Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    final isFavorite =
                        provider.isFavorite(course.code);

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
                          onPressed: () {
                            context
                                .read<CourseProvider>()
                                .toggleFavorite(course.code);
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : Colors.grey,
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
