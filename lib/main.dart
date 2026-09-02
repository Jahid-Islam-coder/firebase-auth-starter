import 'package:firebase_auth_starter/screens/auth/verify_email_screen.dart';
import 'package:firebase_auth_starter/screens/auth/welcome_screen_%20animation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FirebaseAuthStarterApp());
}

class FirebaseAuthStarterApp extends StatelessWidget {
  const FirebaseAuthStarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Starter',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home:  WelcomeScreen (userId: '', onFinished: () {  },),
    );
  }
}
