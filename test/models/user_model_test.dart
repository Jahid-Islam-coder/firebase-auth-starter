import 'package:firebase_auth_starter/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('toMap() returns correct map', () {
      final user = UserModel(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
      );

      final map = user.toMap();

      expect(map['name'], 'John Doe');
      expect(map['email'], 'john@example.com');
      expect(map['phone'], '1234567890');
    });

    test('Constructor creates correct object', () {
      final user = UserModel(
        name: 'Jane Doe',
        email: 'jane@example.com',
        phone: '0987654321',
      );

      expect(user.name, 'Jane Doe');
      expect(user.email, 'jane@example.com');
      expect(user.phone, '0987654321');
    });
  });
}
