import 'package:carma/app/app.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_bloc.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_event.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_state.dart';
import 'package:carma/common/widgets/carma_loading_dialog.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_event.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/apple_sign_in_button.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/google_sign_in_button.dart';
import 'package:carma/features/home/presentation/pages/home_screen.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:carma/features/onboarding/presentation/pages/survey/presentation/survey_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class OnboardingFour extends StatefulWidget {
  const OnboardingFour({super.key});

  @override
  State<OnboardingFour> createState() => _OnboardingFourState();
}

class _OnboardingFourState extends State<OnboardingFour> {
  bool _isRestoreBackupChecked = true;

  @override
  void initState() {
    super.initState();
    locator<Mixpanel>().track('Onboarding', properties: {'screen': 4});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                locator<GoogleSignInBloc>()..add(const CheckIsUserSignedIn()))
      ],
      child: BlocListener<GoogleSignInBloc, GoogleSignInState>(
        listener: (context, state) {
          if (state is SignInError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is SignedIn) {
            if (_isRestoreBackupChecked) {
              context.read<GoogleSignInBloc>().add(const RestoreBackup());
            } else {
              _navigateToHomeScreen(context);
            }
          }

          if (state is RestoreBackupError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            _navigateToHomeScreen(context);
          }

          if (state is RestoredBackup) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup restored successfully')));
            _navigateToHomeScreen(context);
          }
        },
        child: BlocBuilder<GoogleSignInBloc, GoogleSignInState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.white,
              body: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          'Sign in to enable backups',
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
                          child:
                              Image.asset('assets/images/illustration_4.png'),
                        ),
                        const Spacer(),
                        const Spacer(),
                        GoogleSignInButton(onPressed: () {
                          context.read<GoogleSignInBloc>().add(SignIn());
                        }),
                        const SizedBox(height: 18),
                        AppleSignInButton(onPressed: () async {
                          context.read<GoogleSignInBloc>().add(SignIn(
                                isApple: true,
                              ));
                        }),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isRestoreBackupChecked,
                              onChanged: (isChecked) {
                                setState(() {
                                  _isRestoreBackupChecked = isChecked ?? true;
                                });
                              },
                              checkColor: AppColors.white,
                              activeColor: AppColors.primary,
                            ),
                            Text(
                              'Restore my previous backup',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  _navigateToHomeScreen(context);
                                },
                                icon: Text(
                                  'Continue without sign in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is SigningIn) ...[
                    const Center(child: CarmaLoadingDialog()),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToHomeScreen(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SurveyScreen(),
      ),
    );
  }

// void _navigateToHomeScreen(context) {
//   Navigator.of(context).pushReplacement(
//     MaterialPageRoute(
//       builder: (context) => MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => locator<TransactionBloc>()
//               ..add(
//                 const FetchTransactions(),
//               ),
//           ),
//           BlocProvider(
//             create: (context) => locator<CategoryWiseAmountBloc>()
//               ..add(
//                 FetchCatagWiseAmount(
//                     locator<App>().fromDate, locator<App>().toDate),
//               ),
//           ),
//           BlocProvider(
//             create: (context) => locator<MonthWiseFinancialsBloc>()
//               ..add(
//                 FetchMonthWiseFinancials(),
//               )
//               ..add(const FetchLifeTimeFinancials()),
//           ),
//           BlocProvider(
//             create: (context) => locator<OdometerBloc>()
//               ..add(
//                 const GetOdometerReading(),
//               ),
//           )
//         ],
//         child: const HomeScreen(),
//       ),
//     ),
//   );
// }
}
