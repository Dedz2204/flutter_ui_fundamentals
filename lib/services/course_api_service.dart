import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data. Kode HTTP: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Format data dari server tidak valid.');
    }

    const courseNames = [
      'Pemrograman Mobile',
      'Jaringan Komputer',
      'Basis Data',
    ];

    return decoded.take(3).map<Course>((item) {
      final post = item as Map<String, dynamic>;
      final id = post['id'] as int;

      return Course(
        id: id,
        code: 'API-$id',
        title: courseNames[id - 1],
        credits: 3,
        status: 'planned',
      );
    }).toList();
  }

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'code': course.code,
        'title': course.title,
        'credits': course.credits,
        'status': course.status,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Format respons POST tidak valid.');
      }

      return Course(
        id: decoded['id'] as int? ?? course.id,
        code: course.code,
        title: course.title,
        credits: course.credits,
        status: course.status,
      );
    }

    throw Exception('Gagal membuat course. Kode HTTP: ${response.statusCode}');
  }

  // Tahap 7: Memperbarui mata kuliah menggunakan HTTP PUT.
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': id,
        'code': course.code,
        'title': course.title,
        'credits': course.credits,
        'status': course.status,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal memperbarui mata kuliah. '
        'Kode HTTP: ${response.statusCode}',
      );
    }
  }
}
