import 'package:firebase_auth_starter/services/welcome_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WelcomePreferences', () {
    const userId = 'test_user_123';

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('hasSeenWelcome returns false by default', () async {
      final hasSeen = await WelcomePreferences.hasSeenWelcome(userId);
      expect(hasSeen, isFalse);
    });

    test('markWelcomeAsSeen sets the value to true', () async {
      await WelcomePreferences.markWelcomeAsSeen(userId);
      final hasSeen = await WelcomePreferences.hasSeenWelcome(userId);
      expect(hasSeen, isTrue);
    });

    test('different users have different welcome states', () async {
      const userId2 = 'test_user_456';

      await WelcomePreferences.markWelcomeAsSeen(userId);

      expect(await WelcomePreferences.hasSeenWelcome(userId), isTrue);
      expect(await WelcomePreferences.hasSeenWelcome(userId2), isFalse);
    });
  });
}
