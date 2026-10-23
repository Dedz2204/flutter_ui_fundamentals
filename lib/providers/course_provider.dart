import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);

  final CourseRepository repository;

  List<Course> courses = [];
  final Set<String> _favorites = {};

  bool isLoading = false;
  String? error;

  int get favoriteCount => _favorites.length;

  List<Course> get favoriteCourses {
    return courses
        .where((course) => _favorites.contains(course.code))
        .toList();
  }

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    notifyListeners();
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final loadedCourses = await repository.getCourses();
      courses = loadedCourses;
    } catch (e) {
      error = e.toString();
      courses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
