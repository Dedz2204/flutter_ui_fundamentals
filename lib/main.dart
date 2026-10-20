
import 'package:flutter/material.dart';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 3 - Lifting State Up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const FavoritePage(),
    );
  }
}

// PARENT: Satu-satunya pemilik state favorit.
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool favorite = false;

  // Semua perubahan state dilakukan di parent.
  void toggleFavorite() {
    setState(() {
      favorite = !favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifting State Up'),
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
            'Single Source of Truth',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Status favorit disimpan pada parent. '
            'Dua widget di bawah menerima nilai yang sama '
            'melalui constructor.',
          ),
          const SizedBox(height: 20),

          // CHILD 1: Menampilkan status dan tombol perubahan.
          CourseCard(
            courseName: 'Jaringan Komputer',
            isFavorite: favorite,
            onFavoriteChanged: toggleFavorite,
          ),

          const SizedBox(height: 16),

          // CHILD 2: Menampilkan status dari sumber yang sama.
          FavoriteStatusCard(
            isFavorite: favorite,
          ),
        ],
      ),
    );
  }
}

// CHILD 1: Tidak menyimpan salinan state favorit.
class CourseCard extends StatelessWidget {
  final String courseName;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(courseName),
        subtitle: Text(
          isFavorite
              ? 'Mata kuliah sudah difavoritkan'
              : 'Mata kuliah belum difavoritkan',
        ),
        trailing: IconButton(
          tooltip: 'Ubah status favorit',
          onPressed: onFavoriteChanged,
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

// CHILD 2: Menerima nilai favorit yang sama dari parent.
class FavoriteStatusCard extends StatelessWidget {
  final bool isFavorite;

  const FavoriteStatusCard({
    super.key,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isFavorite
          ? Colors.red.shade50
          : Colors.grey.shade100,
      child: ListTile(
        leading: Icon(
          isFavorite ? Icons.check_circle : Icons.info_outline,
          color: isFavorite ? Colors.green : Colors.grey,
        ),
        title: const Text('Status Favorit Saat Ini'),
        subtitle: Text(
          isFavorite
              ? 'Favorit: Ya'
              : 'Favorit: Tidak',
        ),
      ),
    );
  }
}
