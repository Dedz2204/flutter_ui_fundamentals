
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/providers/course_provider.dart';
import 'package:flutter_application_1/repositories/course_repository.dart';
import 'package:flutter_application_1/screens/course_page.dart';
import 'package:flutter_application_1/services/course_api_service.dart';

class FakeCourseApiService extends CourseApiService {
  FakeCourseApiService() : super('https://example.com');

  @override
  Future<List<Course>> getCourses() async {
    return const [
      Course(
        id: 1,
        code: 'JK',
        title: 'Jaringan Komputer',
        credits: 3,
        status: 'Aktif',
      ),
      Course(
        id: 2,
        code: 'PBO',
        title: 'Pemrograman Berorientasi Objek',
        credits: 3,
        status: 'Aktif',
      ),
      Course(
        id: 3,
        code: 'PBM',
        title: 'Pemrograman Berbasis Mobile',
        credits: 3,
        status: 'Aktif',
      ),
    ];
  }
}

void main() {
  testWidgets(
    'Course Explorer menampilkan daftar mata kuliah',
    (WidgetTester tester) async {
      final provider = CourseProvider(
        CourseRepository(FakeCourseApiService()),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<CourseProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: CoursePage(),
          ),
        ),
      );

      await provider.loadCourses();
      await tester.pumpAndSettle();

      expect(find.text('My Courses'), findsOneWidget);
      expect(find.text('Jaringan Komputer'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Pemrograman Berorientasi Objek'),
        300,
      );

      expect(
        find.text('Pemrograman Berorientasi Objek'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Pemrograman Berbasis Mobile'),
        300,
      );

      expect(
        find.text('Pemrograman Berbasis Mobile'),
        findsOneWidget,
      );
    },
  );
}
