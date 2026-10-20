import 'package:flutter/foundation.dart';

class CourseProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }

    notifyListeners();
  }
}
