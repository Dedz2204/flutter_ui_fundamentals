
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_page.dart';
import 'services/course_api_service.dart';

// Ganti dengan alamat dasar backend course yang sebenarnya.
const String apiBaseUrl =
    'https://jsonplaceholder.typicode.com';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(
        CourseRepository(
          CourseApiService(apiBaseUrl),
        ),
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
