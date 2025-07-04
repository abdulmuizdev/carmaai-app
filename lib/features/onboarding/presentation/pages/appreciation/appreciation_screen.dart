import 'package:carma/common/widgets/carma_loading_dialog.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_one.dart';
import 'package:carma/features/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class AppreciationScreen extends StatefulWidget {
  const AppreciationScreen({super.key});

  @override
  State<AppreciationScreen> createState() => _AppreciationScreenState();
}

class _AppreciationScreenState extends State<AppreciationScreen> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.initializeSuperWall((){
        print('callback received');
        setState(() {
          _showLoading = false;
        });
      });
    });
    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name': 'Appreciation Screen',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/car.png',
                  height: 70,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159),
                    // This flips the image horizontally
                    child: Image.asset(
                      'assets/images/car.png',
                      height: 100,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'assets/images/car.png',
                    height: 100,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                      ),
                      const Spacer(),
                      Text(
                        '''Congratulations!''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '''You are on your way to smarter vehicle expense management''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _navigateToOnboardingScreenOne(context);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showLoading) ...[
            const Center(child: CarmaLoadingDialog()),
          ],
        ],
      ),
    );
  }

  void _navigateToOnboardingScreenOne(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingOne()));
  }
}
