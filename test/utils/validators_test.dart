import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_auth_starter/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error when email is empty', () {
      expect(
        Validators.email(''),
        'Email is required',
      );
    });

    test('returns error when email is null', () {
      expect(
        Validators.email(null),
        'Email is required',
      );
    });

    test('returns error when email is invalid', () {
      expect(
        Validators.email('hello'),
        'Enter a valid email',
      );
    });

    test('returns null when email is valid', () {
      expect(
        Validators.email('test@example.com'),
        isNull,
      );
    });
  });

  group('Validators.password', () {
    test('returns error when password is empty', () {
      expect(
        Validators.password(''),
        'Password is required',
      );
    });

    test('returns error when password is too short', () {
      expect(
        Validators.password('123'),
        'Password must be at least 6 characters',
      );
    });

    test('returns null when password is valid', () {
      expect(
        Validators.password('password123'),
        isNull,
      );
    });
  });

  group('Validators.confirmPassword', () {
    test('returns error when confirmation is empty', () {
      expect(
        Validators.confirmPassword('', 'password123'),
        'Please confirm your password',
      );
    });

    test('returns error when passwords do not match', () {
      expect(
        Validators.confirmPassword(
          'different123',
          'password123',
        ),
        'Passwords do not match',
      );
    });

    test('returns null when passwords match', () {
      expect(
        Validators.confirmPassword(
          'password123',
          'password123',
        ),
        isNull,
      );
    });
  });
}