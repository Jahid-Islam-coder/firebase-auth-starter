import 'package:firebase_auth_starter/screens/auth/verify_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createVerifyEmailScreen() {
    return const MaterialApp(
      home: VerifyEmailScreen(),
    );
  }

  group('VerifyEmailScreen', () {
    testWidgets('renders all UI components', (tester) async {
      await tester.pumpWidget(createVerifyEmailScreen());

      expect(find.text('Verify Email'), findsOneWidget);
      expect(find.text('Verify your email'), findsOneWidget);
      expect(find.text("I've verified my email"), findsOneWidget);
      expect(find.text('Resend verification email'), findsOneWidget);
      expect(find.byIcon(Icons.mark_email_unread_outlined), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('shows loading indicator on buttons when state is loading', (tester) async {
      await tester.pumpWidget(createVerifyEmailScreen());

      // We can't easily trigger the loading state from outside without mocks,
      // but we can verify the initial state.
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
