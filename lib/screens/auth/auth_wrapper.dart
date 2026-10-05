import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_starter/screens/auth/verify_email_screen.dart';
import 'package:firebase_auth_starter/screens/auth/welcome_screen_animation.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/welcome_preferences.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

// This class helps us decide which screen to show based on if the user is logged in or not
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

    // Let's check if the user is already signed in when the app starts
    _user = AuthService.instance.currentUser;
    if (_user != null) {
      _isLoading = false;
      _handleAuthStateChange(_user);
    }

    // This listens for any changes in the user's login status
    _authSubscription = AuthService.instance.userChanges.listen(
      _handleAuthStateChange,
    );
  }

  // This function runs whenever the login status changes
  Future<void> _handleAuthStateChange(User? user) async {
    if (!mounted) return;

    // Update our local user variable and stop the loading spinner
    setState(() {
      _user = user;
      _isLoading = false;
    });

    // If no one is logged in, we don't need to check for the welcome screen
    if (user == null) {
      if (!mounted) return;

      setState(() {
        _hasSeenWelcome = true;
        _isWelcomeLoading = false;
      });

      return;
    }

    // Start loading the welcome screen status from preferences
    setState(() {
      _isWelcomeLoading = true;
    });

    try {
      // Check if this specific user has seen the welcome animation before
      final hasSeenWelcome = await WelcomePreferences.hasSeenWelcome(user.uid);

      // Make sure the user hasn't logged out while we were waiting
      if (!mounted || _user?.uid != user.uid) return;

      setState(() {
        _hasSeenWelcome = hasSeenWelcome;
        _isWelcomeLoading = false;
      });
    } catch (e) {
      // If something goes wrong, just stop loading
      if (!mounted) return;
      setState(() {
        _isWelcomeLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Always clean up our listener to avoid memory leaks
    _authSubscription?.cancel();
    super.dispose();
  }

  // Manually refresh the user data from Firebase
  Future<void> refreshAuthState() async {
    await AuthService.instance.refreshUser();
  }

  // This is called when the welcome animation finishes
  void _onWelcomeFinished() {
    if (!mounted || _user == null) return;

    setState(() {
      _hasSeenWelcome = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading circle if we are still checking stuff
    if (_isLoading || _isWelcomeLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If no user, show the login screen
    if (_user == null) {
      return const LoginScreen();
    }

    // If user hasn't verified their email, send them to the verify screen
    if (!_user!.emailVerified) {
      return const VerifyEmailScreen();
    }

    // If they haven't seen the welcome message, show that first
    if (!_hasSeenWelcome) {
      return WelcomeScreen(
        userId: _user!.uid,
        onFinished: _onWelcomeFinished,
      );
    }

    // Finally, if everything is good, show the home screen!
    return const HomeScreen();
  }
}
