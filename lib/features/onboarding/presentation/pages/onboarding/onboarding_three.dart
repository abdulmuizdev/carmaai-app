import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_four.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class OnboardingThree extends StatefulWidget {
  const OnboardingThree({super.key});

  @override
  State<OnboardingThree> createState() => _OnboardingThreeState();
}

class _OnboardingThreeState extends State<OnboardingThree> {

  @override
  void initState() {
    super.initState();
    locator<Mixpanel>().track('Onboarding', properties: { 'screen': 3 });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Keep your financials securely in your possession',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.asset('assets/images/illustration_3.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Row(
                children: [
                  // Text(
                  //   'SKIP',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: AppColors.white,
                  //   ),
                  // ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnboardingFour()));
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
