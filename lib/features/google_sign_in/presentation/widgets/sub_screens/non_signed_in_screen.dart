import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/apple_sign_in_button.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';

class NonSignedInScreen extends StatelessWidget {
  final VoidCallback onSignInWithGooglePressed;
  final VoidCallback onSignInWithApplePressed;

  const NonSignedInScreen({
    super.key,
    required this.onSignInWithGooglePressed,
    required this.onSignInWithApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/illustration_4.png'),
            ),
            Text(
              'After logging in, you can back up your data in real time!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            GoogleSignInButton(
              onPressed: onSignInWithGooglePressed,
            ),
            // const SizedBox(height: 18),
            AppleSignInButton(
              onPressed: onSignInWithApplePressed,
            ),
            Text(
              'By signing in, you agree to the Terms of use and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.secondary.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
