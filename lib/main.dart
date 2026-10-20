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
      title: 'Tahap 2 - Prop Drilling',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const FavoritesParentPage(),
    );
  }
}

// PARENT: Menyimpan satu sumber state favorites.
class FavoritesParentPage extends StatefulWidget {
  const FavoritesParentPage({super.key});

  @override
  State<FavoritesParentPage> createState() =>
      _FavoritesParentPageState();
}

class _FavoritesParentPageState
    extends State<FavoritesParentPage> {
  final List<String> _favorites = [];

  // Callback untuk mengubah favorites.
  void _toggleFavorite(String courseName) {
    setState(() {
      if (_favorites.contains(courseName)) {
        _favorites.remove(courseName);
      } else {
        _favorites.add(courseName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool jaringanIsFavorite =
        _favorites.contains('Jaringan Komputer');

    final bool pemrogramanIsFavorite =
        _favorites.contains('Pemrograman Mobile');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksperimen Prop Drilling'),
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
          const SizedBox(height: 20),

          // Menampilkan jumlah favorites.
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: const Text('Jumlah Favorit'),
              trailing: Text(
                '${_favorites.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Daftar Mata Kuliah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // CHILD PERTAMA
          // Parent meneruskan data dan callback melalui constructor.
          CourseFavoriteChild(
            courseName: 'Jaringan Komputer',
            isFavorite: jaringanIsFavorite,
            onToggleFavorite: () {
              _toggleFavorite('Jaringan Komputer');
            },
          ),

          const SizedBox(height: 12),

          // CHILD KEDUA
          // Parent meneruskan data dan callback melalui constructor.
          CourseFavoriteChild(
            courseName: 'Pemrograman Mobile',
            isFavorite: pemrogramanIsFavorite,
            onToggleFavorite: () {
              _toggleFavorite('Pemrograman Mobile');
            },
          ),

          const SizedBox(height: 20),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan Eksperimen',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'State favorit disimpan pada parent. '
                    'Setiap child menerima status favorit '
                    'dan callback melalui constructor. '
                    'Jika jumlah child bertambah, data dan '
                    'callback perlu diteruskan ke lebih banyak '
                    'widget sehingga alur kode lebih sulit diikuti.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CHILD: Menerima data dan callback dari parent.
class CourseFavoriteChild extends StatelessWidget {
  final String courseName;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const CourseFavoriteChild({
    super.key,
    required this.courseName,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(courseName),
        subtitle: Text(
          isFavorite
              ? 'Sudah ditambahkan ke favorit'
              : 'Belum menjadi favorit',
        ),
        trailing: IconButton(
          tooltip: isFavorite
              ? 'Hapus dari favorit'
              : 'Tambah ke favorit',
          icon: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}
