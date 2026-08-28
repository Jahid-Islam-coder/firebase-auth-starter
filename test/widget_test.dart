import 'package:firebase_auth_starter/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test - renders LoginScreen', (WidgetTester tester) async {
    // Build  app and trigger a frame
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verify the login screen is rendered correctly
    expect(find.text('Login'), findsWidgets);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });
}
