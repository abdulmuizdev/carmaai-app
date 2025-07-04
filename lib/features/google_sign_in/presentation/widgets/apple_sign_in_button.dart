import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AppleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Padding(
        padding:
        const EdgeInsets.all(10),
        child: Image.asset(
            'assets/images/apple.png',
            width: 30,
            height: 30),
      ),
      label: Text(
        'Sign In With Apple',
        style: TextStyle(
          fontSize: 18,
          color: AppColors.white,
        ),
      ),
      style: FilledButton.styleFrom(
          backgroundColor:
          const Color(0xFF1D1D1F)),
    );
  }
}
