import 'package:firebase_auth_starter/screens/auth/auth_wrapper.dart';
import 'package:firebase_auth_starter/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test - starts with AuthWrapper', (WidgetTester tester) async {
    // Build app and trigger a frame
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthWrapper(),
      ),
    );

    // Initially it might show a loader because AuthWrapper is loading its state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    // After loading, since no user is logged in, it should show LoginScreen
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
