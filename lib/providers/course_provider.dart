import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);

  final CourseRepository repository;

  List<Course> courses = [];

  // Menyimpan mata kuliah hasil POST selama aplikasi berjalan.
  final List<Course> _createdCourses = [];

  final Set<String> _favorites = {};

  bool isLoading = false;
  bool isSaving = false;
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

  // Menggabungkan data API dan data hasil POST.
  // Data dengan kode sama tidak akan ditampilkan dua kali.
  List<Course> _mergeCourses(
    List<Course> apiCourses,
    List<Course> createdCourses,
  ) {
    final merged = <Course>[];

    for (final course in apiCourses) {
      final localIndex = createdCourses.indexWhere(
        (item) => item.code == course.code,
      );

      if (localIndex >= 0) {
        merged.add(createdCourses[localIndex]);
      } else {
        merged.add(course);
      }
    }

    for (final course in createdCourses) {
      final alreadyExists = merged.any(
        (item) => item.code == course.code,
      );

      if (!alreadyExists) {
        merged.add(course);
      }
    }

    return merged;
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final apiCourses = await repository.getCourses();

      // Refresh data API tanpa menghilangkan hasil POST sebelumnya.
      courses = _mergeCourses(apiCourses, _createdCourses);
      error = null;
    } catch (e) {
      error = e.toString();

      // Jika refresh gagal, pertahankan daftar yang sudah ada.
      if (courses.isEmpty && _createdCourses.isNotEmpty) {
        courses = List<Course>.from(_createdCourses);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Course> createCourse(Course course) async {
    if (isSaving) {
      throw Exception('Penyimpanan sedang berlangsung.');
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      // Kirim data melalui Repository ke API.
      final createdCourse = await repository.createCourse(course);

      // Simpan hasil POST di memori selama aplikasi berjalan.
      final existingIndex = _createdCourses.indexWhere(
        (item) => item.code == createdCourse.code,
      );

      if (existingIndex >= 0) {
        _createdCourses[existingIndex] = createdCourse;
      } else {
        _createdCourses.add(createdCourse);
      }

      try {
        final apiCourses = await repository.getCourses();

        courses = _mergeCourses(apiCourses, _createdCourses);
      } catch (_) {
        courses = _mergeCourses(courses, _createdCourses);
      }

      error = null;
      return createdCourse;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
