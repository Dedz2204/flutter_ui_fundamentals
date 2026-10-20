import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class DetailPage extends StatelessWidget {
  final Course course;

  const DetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isFavorite = provider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama: Putu Agus Dedy Putra Adnyana',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('NIM: 2415051104'),
            const SizedBox(height: 24),

            Text(
              course.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text('Kode: ${course.code}'),
            Text('SKS: ${course.credits}'),
            Text('Status: ${course.status}'),
            const SizedBox(height: 20),

            Row(
              children: [
                Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  isFavorite
                      ? 'Status: Mata kuliah favorit'
                      : 'Status: Belum menjadi favorit',
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CourseProvider>()
                    .toggleFavorite(course.code);
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite_border
                    : Icons.favorite,
              ),
              label: Text(
                isFavorite
                    ? 'Hapus dari Favorit'
                    : 'Tambahkan ke Favorit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
