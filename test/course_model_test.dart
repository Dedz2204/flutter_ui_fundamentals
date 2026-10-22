import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/course.dart';

void main() {
  group('Course Model Test', () {
    test('Course dapat dibuat dengan data yang benar', () {
      const course = Course(
        id: 1,
        code: 'IF101',
        title: 'Pemrograman Mobile',
        credits: 3,
      );

      expect(course.id, 1);
      expect(course.code, 'IF101');
      expect(course.title, 'Pemrograman Mobile');
      expect(course.credits, 3);
      expect(course.status, 'planned');
    });

    test('Course dapat dikonversi dari JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'code': 'IF101',
        'title': 'Pemrograman Mobile',
        'credits': 3,
      };

      final course = Course.fromJson(json);

      expect(course.id, 1);
      expect(course.code, 'IF101');
      expect(course.title, 'Pemrograman Mobile');
      expect(course.credits, 3);
      expect(course.status, 'planned');
    });

    test('Course dapat dikonversi menjadi JSON', () {
      const course = Course(
        id: 1,
        code: 'IF101',
        title: 'Pemrograman Mobile',
        credits: 3,
        status: 'ongoing',
      );

      final json = course.toJson();

      expect(json['code'], 'IF101');
      expect(json['title'], 'Pemrograman Mobile');
      expect(json['credits'], 3);
      expect(json['status'], 'ongoing');
      expect(json.containsKey('id'), false);
    });
  });
}
