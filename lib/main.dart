
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
      title: 'Tahap 4 - ValueNotifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const FavoriteCounterPage(),
    );
  }
}

class FavoriteCounterPage extends StatefulWidget {
  const FavoriteCounterPage({super.key});

  @override
  State<FavoriteCounterPage> createState() =>
      _FavoriteCounterPageState();
}

class _FavoriteCounterPageState
    extends State<FavoriteCounterPage> {
  // ValueNotifier menyimpan satu nilai sederhana.
  final ValueNotifier<int> favoriteCounter =
      ValueNotifier<int>(0);

  // Mengubah nilai tanpa memanggil setState().
  void increaseFavorite() {
    favoriteCounter.value++;
  }

  void decreaseFavorite() {
    if (favoriteCounter.value > 0) {
      favoriteCounter.value--;
    }
  }

  void resetFavorite() {
    favoriteCounter.value = 0;
  }

  @override
  void dispose() {
    favoriteCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueNotifier'),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Putu Agus Dedy Putra Adnyana',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('NIM: 2415051104'),
              const SizedBox(height: 32),

              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),

              const Text(
                'Jumlah Favorit',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),

              // Widget ini mendengarkan perubahan nilai.
              ValueListenableBuilder<int>(
                valueListenable: favoriteCounter,
                builder: (context, value, child) {
                  return Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    onPressed: decreaseFavorite,
                    icon: const Icon(Icons.remove),
                    tooltip: 'Kurangi favorit',
                  ),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    onPressed: increaseFavorite,
                    icon: const Icon(Icons.add),
                    tooltip: 'Tambah favorit',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: resetFavorite,
                child: const Text('Reset'),
              ),

              const SizedBox(height: 24),

              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'ValueNotifier memperbarui widget '
                    'yang mendengarkan nilainya melalui '
                    'ValueListenableBuilder. Perubahan '
                    'angka tidak memerlukan pemanggilan '
                    'setState() pada parent.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
