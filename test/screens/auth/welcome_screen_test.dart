import 'package:firebase_auth_starter/screens/auth/welcome_screen_%20animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WelcomeScreen', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('renders initial state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeScreen(
            userId: 'test_user',
            onFinished: () {},
          ),
        ),
      );

      // Check for static elements
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Welcome! 👋'), findsOneWidget);
      expect(find.text('Your account is ready.\nLet’s get started!'), findsOneWidget);
    });

    testWidgets('calls onFinished after animation', (tester) async {
      bool finishedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeScreen(
            userId: 'test_user',
            onFinished: () {
              finishedCalled = true;
            },
          ),
        ),
      );

      // Advance time for the animations and the 2-second delay
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(finishedCalled, isTrue);
    });
  });
}
