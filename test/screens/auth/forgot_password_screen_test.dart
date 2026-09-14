import 'package:firebase_auth_starter/screens/auth/forgot_password_screen.dart';
import 'package:firebase_auth_starter/widgets/auth_button.dart';
import 'package:firebase_auth_starter/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createForgotPasswordScreen() {
    return const MaterialApp(
      home: ForgotPasswordScreen(),
    );
  }

  group('ForgotPasswordScreen', () {
    testWidgets('renders initial UI components', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createForgotPasswordScreen());

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Reset your password'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(AuthButton), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Back to Sign In'), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset_outlined), findsOneWidget);
    });

    testWidgets('shows validation errors when email is empty', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createForgotPasswordScreen());

      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows invalid email error when email format is incorrect', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createForgotPasswordScreen());

      await tester.enterText(
        find.widgetWithText(AuthTextField, 'Email'),
        'invalid-email',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('navigates back when Back to Sign In is pressed', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: const Text('Go to Forgot Password'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Forgot Password'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);

      await tester.tap(find.text('Back to Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsNothing);
    });
  });
}
