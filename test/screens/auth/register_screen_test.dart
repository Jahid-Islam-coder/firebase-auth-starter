import 'package:firebase_auth_starter/screens/auth/register_screen.dart';
import 'package:firebase_auth_starter/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createSignupScreen() {
    return const MaterialApp(
      home: SignupScreen(),
    );
  }

  group('SignupScreen', () {
    testWidgets('renders all UI components', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSignupScreen());

      expect(find.text('Sign up'), findsNWidgets(2));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Yes! I Agree all Terms & Condition'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSignupScreen());

      final passwordFieldFinder = find.descendant(
        of: find.widgetWithText(AuthTextField, 'Password'),
        matching: find.byType(TextField),
      );

      expect(tester.widget<TextField>(passwordFieldFinder).obscureText, true);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(tester.widget<TextField>(passwordFieldFinder).obscureText, false);
    });

    testWidgets('shows validation errors when sign up button is pressed with empty fields',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSignupScreen());

      final signupButton = find.widgetWithText(FilledButton, 'Sign up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows snackbar when terms are not agreed', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSignupScreen());

      await tester.enterText(find.widgetWithText(AuthTextField, 'Full Name'), 'John Doe');
      await tester.enterText(find.widgetWithText(AuthTextField, 'Email'), 'john@example.com');
      await tester.enterText(find.widgetWithText(AuthTextField, 'Phone'), '1234567890');
      await tester.enterText(find.widgetWithText(AuthTextField, 'Password'), 'password123');

      final signupButton = find.widgetWithText(FilledButton, 'Sign up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('Please agree to the Terms & Conditions.'), findsOneWidget);
    });

    testWidgets('navigates back when Login is pressed', (tester) async {
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
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                child: const Text('Go to Signup'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Signup'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreen), findsOneWidget);

      await tester.ensureVisible(find.text('Login'));
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreen), findsNothing);
    });

    testWidgets('shows invalid email error', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSignupScreen());

      await tester.enterText(find.widgetWithText(AuthTextField, 'Email'), 'invalid-email');

      final signupButton = find.widgetWithText(FilledButton, 'Sign up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('shows weak password error', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSignupScreen());

      await tester.enterText(find.widgetWithText(AuthTextField, 'Password'), '123');

      final signupButton = find.widgetWithText(FilledButton, 'Sign up');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });
}
