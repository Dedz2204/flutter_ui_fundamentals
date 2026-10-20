import 'package:flutter/foundation.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider({CourseRepository? repository})
      : _repository = repository ??
            CourseRepository(CourseService()) {
    loadCourses();
  }

  final CourseRepository _repository;

  List<Course> _courses = [];
  final Set<String> _favorites = {};

  bool _isLoading = true;
  String? _error;

  List<Course> get courses => List.unmodifiable(_courses);
  int get favoriteCount => _favorites.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
    } catch (e) {
      _error = 'Gagal memuat data mata kuliah: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
