import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course');
    }

    final List data = jsonDecode(response.body) as List;

    return data.take(3).map((item) {
      final post = item as Map<String, dynamic>;

      return Course(
        id: post['id'] as int,
        code: 'API-${post['id']}',
        title: post['title'] as String,
        credits: 3,
        status: 'planned',
      );
    }).toList();
  }
}
