import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_four.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_three.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class OnboardingTwo extends StatefulWidget {
  const OnboardingTwo({super.key});

  @override
  State<OnboardingTwo> createState() => _OnboardingTwoState();
}

class _OnboardingTwoState extends State<OnboardingTwo> {

  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Onboarding', properties: { 'screen': 2 });
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
              'Snap a pic of your odometer to log it with a note',
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
              child: Image.asset('assets/images/illustration_2.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnboardingThree()));
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
