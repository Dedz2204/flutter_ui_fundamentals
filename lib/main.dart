
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_page.dart';
import 'services/course_service.dart';

const String apiUrl =
    'https://jsonplaceholder.typicode.com/posts/1';

Future<Map<String, dynamic>> fetchPost() async {
  final response = await http.get(Uri.parse(apiUrl));

  debugPrint('HTTP Status Code: ${response.statusCode}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  throw Exception('HTTP ${response.statusCode}');
}

Future<void> testFetchPost() async {
  try {
    final post = await fetchPost();

    debugPrint('Jumlah field JSON: ${post.length}');
    debugPrint('Data post: $post');
  } catch (e) {
    debugPrint('Gagal mengambil data: $e');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Pengujian sementara HTTP GET untuk Tahap 2.
  testFetchPost();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(
        CourseRepository(CourseService()),
      )..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const CoursePage(),
    );
  }
}
