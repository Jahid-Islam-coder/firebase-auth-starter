import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      if (!mounted) return;

      setState(() {
        _emailSent = true;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getFirebaseErrorMessage(e)),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account was found with this email.';

      case 'too-many-requests':
        return 'Too many requests. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your connection.';

      default:
        return e.message ??
            'Unable to send password reset email.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: _emailSent
                  ? _buildSuccessContent()
                  : _buildResetForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.lock_reset_outlined,
            size: 80,
            color: Color(0xFF5D12B5),
          ),

          const SizedBox(height: 24),

          Text(
            'Reset your password',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Enter the email address associated with your account '
                'and we will send you a password reset link.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 32),

          AuthTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }

              if (!value.contains('@')) {
                return 'Enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 24),

          AuthButton(
            onPressed: _sendPasswordResetEmail,
            text: 'Send Reset Link',
            isLoading: _isLoading,
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 80,
        ),

        const SizedBox(height: 24),

        Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'We sent a password reset link to:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: 8),

        Text(
          _emailController.text.trim(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Open the email and follow the instructions '
              'to create a new password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 32),

        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back to Sign In'),
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text('Use a different email'),
        ),
      ],
    );
  }
}