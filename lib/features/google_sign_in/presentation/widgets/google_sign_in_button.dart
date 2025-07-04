import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Padding(
        padding:
        const EdgeInsets.all(10),
        child: Image.asset(
            'assets/images/google.png',
            width: 30,
            height: 30),
      ),
      label: Text(
        'Sign In With Google',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      style: FilledButton.styleFrom(
          backgroundColor:
          const Color(0xFFE8E8EA)),
    );
  }
}
