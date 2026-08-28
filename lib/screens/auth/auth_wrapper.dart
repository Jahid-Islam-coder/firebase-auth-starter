import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _authSubscription = AuthService.instance.userChanges.listen(
      _handleAuthStateChange,
    );
  }

  Future<void> _handleAuthStateChange(User? user) async {
    if (!mounted) return;

    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> refreshAuthState() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
    }

    if (!mounted) return;

    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return  LoginScreen();
    }

    if (!_user!.emailVerified) {
      return const VerifyEmailScreen();
    }

    return const HomeScreen();
  }
}