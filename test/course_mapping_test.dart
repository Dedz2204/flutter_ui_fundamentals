import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/course.dart';

void main() {
  test('JSON dengan tipe id salah menghasilkan TypeError', () {
    final invalidJson = <String, dynamic>{
      'id': 'bukan_angka',
      'code': 'IF999',
      'title': 'Course Uji',
      'credits': 3,
      'status': 'planned',
    };

    expect(
      () => Course.fromJson(invalidJson),
      throwsA(isA<TypeError>()),
    );
  });
}
