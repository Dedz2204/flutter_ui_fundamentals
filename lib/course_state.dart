import 'package:flutter/foundation.dart';

class CourseState extends ChangeNotifier {
  // Satu kumpulan untuk menyimpan ID mata kuliah favorit.
  final Set<String> favorites = {};

  // Menambah atau menghapus mata kuliah dari favorit.
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    // Memberi tahu widget bahwa state telah berubah.
    notifyListeners();
  }

  // Memeriksa apakah mata kuliah menjadi favorit.
  bool isFavorite(String id) {
    return favorites.contains(id);
  }

  // Menghitung jumlah mata kuliah favorit.
  int get favoriteCount => favorites.length;
}
