import 'package:firebase_auth_starter/screens/auth/forgot_password_screen.dart';
import 'package:firebase_auth_starter/screens/auth/login_screen.dart';
import 'package:firebase_auth_starter/screens/auth/register_screen.dart';
import 'package:firebase_auth_starter/widgets/auth_button.dart';
import 'package:firebase_auth_starter/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createLoginScreen() {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders all UI components', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Login'), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot your password?'), findsOneWidget);
      expect(find.byType(AuthButton), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createLoginScreen());

      final passwordField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(AuthTextField, 'Password'),
          matching: find.byType(TextField),
        ),
      );

      expect(passwordField.obscureText, true);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      final updatedPasswordField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(AuthTextField, 'Password'),
          matching: find.byType(TextField),
        ),
      );
      expect(updatedPasswordField.obscureText, false);
    });

    testWidgets('shows validation errors when login button is pressed with empty fields',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createLoginScreen());

      await tester.ensureVisible(find.byType(AuthButton));
      await tester.tap(find.byType(AuthButton));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows invalid email error when email format is incorrect', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.widgetWithText(AuthTextField, 'Email'),
        'invalid-email',
      );
      await tester.ensureVisible(find.byType(AuthButton));
      await tester.tap(find.byType(AuthButton));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('navigates to ForgotPasswordScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createLoginScreen());

      await tester.ensureVisible(find.text('Forgot your password?'));
      await tester.tap(find.text('Forgot your password?'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('navigates to SignupScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createLoginScreen());

      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreen), findsOneWidget);
    });
  });
}
