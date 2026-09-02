import 'package:firebase_auth_starter/screens/auth/auth_wrapper.dart';
import 'package:firebase_auth_starter/screens/auth/login_screen.dart';
import 'package:firebase_auth_starter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    AuthService.instance = mockAuthService;

    // Default mock behaviors
    when(() => mockAuthService.currentUser).thenReturn(null);
    when(() => mockAuthService.userChanges).thenAnswer((_) => Stream.value(null));
  });

  testWidgets('App smoke test - starts with AuthWrapper', (WidgetTester tester) async {
    // Build app and trigger a frame
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthWrapper(),
      ),
    );

    // After loading, since no user is logged in, it should show LoginScreen
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
