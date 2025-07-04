import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_four.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_two.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class OnboardingOne extends StatefulWidget {
  const OnboardingOne({super.key});

  @override
  State<OnboardingOne> createState() => _OnboardingOneState();
}

class _OnboardingOneState extends State<OnboardingOne> {
  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Onboarding', properties: {'screen': 1});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Text(
                '''Know you vehicle's lifetime expenses at any time''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.asset('assets/images/illustration_1.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnboardingFour()));
                    },
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnboardingTwo()));
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
