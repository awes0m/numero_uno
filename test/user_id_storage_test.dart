import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Normalization Tests', () {
    test('Email should be normalized as user ID', () {
      const email1 = 'JOHN.DOE@EXAMPLE.COM';
      const email2 = '  john.doe@example.com  ';
      const email3 = 'john.doe@example.com';

      // Normalize emails
      final userId1 = email1.trim().toLowerCase();
      final userId2 = email2.trim().toLowerCase();
      final userId3 = email3.trim().toLowerCase();

      // All should normalize to the same value
      expect(userId1, equals('john.doe@example.com'));
      expect(userId2, equals('john.doe@example.com'));
      expect(userId3, equals('john.doe@example.com'));
      expect(userId1, equals(userId2));
      expect(userId2, equals(userId3));
    });
  });
}
