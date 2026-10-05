import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_starter/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/auth_text_field.dart';
import 'forgot_password_screen.dart';

// This is where the user logs in
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // A key to help us validate the form fields
  final _formKey = GlobalKey<FormState>();

  // Controllers to get the text the user typed
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Clean up controllers when we leave this screen
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // This runs when the login button is pressed
  Future<void> _login() async {
    // Check if the email and password are valid before trying to log in
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Show the loading spinner
    });

    try {
      // Try logging in with the email and password
      await AuthService.instance.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      // Show an error message if Firebase says something is wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_firebaseError(e)),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      // Generic error message if something else goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide the loading spinner
        });
      }
    }
  }

  // This function makes the Firebase error messages look nicer for the user
  String _firebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your connection.';

      default:
        return e.message ?? 'Unable to sign in.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            return SingleChildScrollView(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                      children: [
                        const _LoginHeader(),
                        _LoginForm(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            isLoading: _isLoading,
                            onTogglePassword: () {
                              setState(() {
                                // Switch between seeing and hiding the password
                                _obscurePassword =
                                !_obscurePassword;
                              });
                            },
                            onLogin: _login,
                          ),

                      ],
                    ),

                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// The top part of the screen with the purple wave
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: ClipPath(
        clipper: _WaveClipper(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4D0BA8),
                Color(0xFF7A28D9),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Just some circles for decoration
              Positioned(
                top: -70,
                right: -45,
                child: _CircleDecoration(
                  size: 165,
                ),
              ),

              Positioned(
                top: 125,
                left: -55,
                child: _CircleDecoration(
                  size: 115,
                ),
              ),

              Positioned(
                bottom: 75,
                right: 60,
                child: _CircleDecoration(
                  size: 70,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// The middle part with the input fields and login button
class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        48,
        0,
        48,
        55,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Email input field
            AuthTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),

            const SizedBox(height: 20),

            // Password input field
            AuthTextField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              obscureText: obscurePassword,
              validator: Validators.password,
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Button to go to the forgot password screen
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ForgotPasswordScreen(),
                  ),
                );
              },
              child: const Text(
                'Forgot your password?',
                style: TextStyle(
                  color: Color(0xFF6020BC),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // The main login button
            SizedBox(
              width: double.infinity,
              height: 70,
              child: AuthButton(
                onPressed: onLogin,
                text: 'Login',
                isLoading: isLoading,
              ),
            ),

            const SizedBox(height: 22),

            // Link to the sign up screen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 17,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF6020BC),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable widget for those decorative circles
class _CircleDecoration extends StatelessWidget {
  const _CircleDecoration({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 2,
        ),
      ),
    );
  }
}

// This helps us draw that nice wave shape at the top
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.78);

    path.cubicTo(
      size.width * 0.20,
      size.height * 0.90,
      size.width * 0.32,
      size.height * 0.82,
      size.width * 0.48,
      size.height * 0.69,
    );

    path.cubicTo(
      size.width * 0.65,
      size.height * 0.55,
      size.width * 0.82,
      size.height * 0.68,
      size.width,
      size.height * 0.80,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}
