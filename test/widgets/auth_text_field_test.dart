import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_auth_starter/widgets/auth_text_field.dart';

void main() {
  Widget createTestWidget({
    required TextEditingController controller,
    String label = 'Email',
    IconData icon = Icons.email_outlined,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    AuthTextFieldStyle style = AuthTextFieldStyle.light,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthTextField(
            controller: controller,
            label: label,
            icon: icon,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            suffixIcon: suffixIcon,
            style: style,
          ),
        ),
      ),
    );
  }

  group('AuthTextField', () {
    testWidgets(
      'displays label and prefix icon',
          (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
            label: 'Email',
            icon: Icons.email_outlined,
          ),
        );

        expect(
          find.text('Email'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.email_outlined),
          findsOneWidget,
        );

        controller.dispose();
      },
    );

    testWidgets(
      'accepts user input',
          (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'test@example.com',
        );

        expect(
          controller.text,
          'test@example.com',
        );

        controller.dispose();
      },
    );

    testWidgets(
      'uses provided keyboard type',
          (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
          ),
        );

        final textField = tester.widget<TextField>(
          find.byType(TextField),
        );

        expect(
          textField.keyboardType,
          TextInputType.emailAddress,
        );

        controller.dispose();
      },
    );

    testWidgets(
      'hides text when obscureText is enabled',
          (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
        );

        final textField = tester.widget<TextField>(
          find.byType(TextField),
        );

        expect(
          textField.obscureText,
          true,
        );

        controller.dispose();
      },
    );

    testWidgets(
      'does not hide text by default',
          (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
          ),
        );

        final textField = tester.widget<TextField>(
          find.byType(TextField),
        );

        expect(
          textField.obscureText,
          false,
        );

        controller.dispose();
      },
    );

    testWidgets(
      'displays suffix icon when provided',
          (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
            label: 'Password',
            icon: Icons.lock_outline,
            suffixIcon: const Icon(
              Icons.visibility_outlined,
            ),
          ),
        );

        expect(
          find.byIcon(Icons.visibility_outlined),
          findsOneWidget,
        );

        controller.dispose();
      },
    );

    testWidgets(
      'runs validator when form is submitted',
          (tester) async {
        final controller = TextEditingController();
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: AuthTextField(
                  controller: controller,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }

                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        formKey.currentState!.validate();

        await tester.pump();

        expect(
          find.text('Email is required'),
          findsOneWidget,
        );

        controller.dispose();
      },
    );

    group('light style', () {
      testWidgets(
        'uses dark text color',
            (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            createTestWidget(
              controller: controller,
              style: AuthTextFieldStyle.light,
            ),
          );

          final textField = tester.widget<TextField>(
            find.byType(TextField),
          );

          expect(
            textField.style?.color,
            Colors.black87,
          );

          controller.dispose();
        },
      );

      testWidgets(
        'uses purple cursor color',
            (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            createTestWidget(
              controller: controller,
              style: AuthTextFieldStyle.light,
            ),
          );

          final textField = tester.widget<TextField>(
            find.byType(TextField),
          );

          expect(
            textField.cursorColor,
            const Color(0xFF5D1AB5),
          );

          controller.dispose();
        },
      );
    });

    group('purple style', () {
      testWidgets(
        'uses white text color',
            (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            createTestWidget(
              controller: controller,
              style: AuthTextFieldStyle.purple,
            ),
          );

          final textField = tester.widget<TextField>(
            find.byType(TextField),
          );

          expect(
            textField.style?.color,
            Colors.white,
          );

          controller.dispose();
        },
      );

      testWidgets(
        'uses white cursor color',
            (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            createTestWidget(
              controller: controller,
              style: AuthTextFieldStyle.purple,
            ),
          );

          final textField = tester.widget<TextField>(
            find.byType(TextField),
          );

          expect(
            textField.cursorColor,
            Colors.white,
          );

          controller.dispose();
        },
      );

      testWidgets(
        'uses purple style label color',
            (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            createTestWidget(
              controller: controller,
              style: AuthTextFieldStyle.purple,
            ),
          );

          final textField = tester.widget<TextField>(
            find.byType(TextField),
          );

          final decoration = textField.decoration!;

          final labelStyle = decoration.labelStyle!;

          expect(
            labelStyle.color,
            Colors.white70,
          );

          controller.dispose();
        },
      );

      testWidgets(
        'uses white prefix icon color',
            (tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            createTestWidget(
              controller: controller,
              icon: Icons.email_outlined,
              style: AuthTextFieldStyle.purple,
            ),
          );

          final icon = tester.widget<Icon>(
            find.byIcon(Icons.email_outlined),
          );

          expect(
            icon.color,
            Colors.white,
          );

          controller.dispose();
        },
      );
    });
  });
}