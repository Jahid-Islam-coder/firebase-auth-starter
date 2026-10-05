import 'package:flutter/material.dart';

enum AuthTextFieldStyle {
  light,
  purple,
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.style = AuthTextFieldStyle.light,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final AuthTextFieldStyle style;

  @override
  Widget build(BuildContext context) {
    final isPurple = style == AuthTextFieldStyle.purple;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        color: isPurple ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
      cursorColor: isPurple
          ? Colors.white
          : const Color(0xFF5D1AB5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isPurple
              ? Colors.white70
              : Colors.grey.shade700,
        ),
        prefixIcon: Icon(
          icon,
          color: isPurple
              ? Colors.white
              : Colors.grey.shade700,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isPurple
                ? Colors.white.withValues(alpha: 0.65)
                : Colors.grey.shade500,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isPurple
                ? Colors.white
                : const Color(0xFF5D1AB5),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}