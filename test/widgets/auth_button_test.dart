import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_auth_starter/widgets/auth_button.dart';

void main() {
  testWidgets(
    'shows button text when not loading',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              onPressed: () {},
              text: 'Sign In',
            ),
          ),
        ),
      );

      expect(
        find.text('Sign In'),
        findsOneWidget,
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
      );
    },
  );

  testWidgets(
    'shows loading indicator when loading',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              onPressed: () {},
              text: 'Sign In',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      expect(
        find.text('Sign In'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'button is disabled while loading',
        (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              onPressed: () {
                pressed = true;
              },
              text: 'Sign In',
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byType(FilledButton),
      );

      expect(pressed, false);
    },
  );
}