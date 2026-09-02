import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_starter/screens/auth/verify_email_screen.dart';
import 'package:firebase_auth_starter/screens/auth/welcome_screen_%20animation.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/welcome_preferences.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';



class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  bool _isLoading = true;
  bool _isWelcomeLoading = false;
  bool _hasSeenWelcome = true;

  @override
  void initState() {
    super.initState();

    // Set initial state from current user
    _user = AuthService.instance.currentUser;
    if (_user != null) {
      _isLoading = false;
      _handleAuthStateChange(_user);
    }

    _authSubscription = AuthService.instance.userChanges.listen(
      _handleAuthStateChange,
    );
  }

  Future<void> _handleAuthStateChange(User? user) async {
    if (!mounted) return;

    // Immediately update the current authentication state.
    setState(() {
      _user = user;
      _isLoading = false;
    });

    // No signed-in user means there is no welcome preference to load.
    if (user == null) {
      if (!mounted) return;

      setState(() {
        _hasSeenWelcome = true;
        _isWelcomeLoading = false;
      });

      return;
    }

    // Load the welcome status for the currently signed-in user.
    setState(() {
      _isWelcomeLoading = true;
    });

    try {
      final hasSeenWelcome = await WelcomePreferences.hasSeenWelcome(user.uid);

      // The active user may have changed while SharedPreferences was loading.
      if (!mounted || _user?.uid != user.uid) return;

      setState(() {
        _hasSeenWelcome = hasSeenWelcome;
        _isWelcomeLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isWelcomeLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> refreshAuthState() async {
    await AuthService.instance.refreshUser();
  }

  void _onWelcomeFinished() {
    if (!mounted || _user == null) return;

    setState(() {
    _hasSeenWelcome = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isWelcomeLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return const LoginScreen();
    }

    if (!_user!.emailVerified) {
      return const VerifyEmailScreen();
    }

    if (!_hasSeenWelcome) {
      return WelcomeScreen(
        userId: _user!.uid,
        onFinished: _onWelcomeFinished,
      );
    }

    return const HomeScreen();
  }
}
