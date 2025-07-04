import 'package:carma/app/app.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_event.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/home/presentation/pages/home_screen.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:carma/features/onboarding/presentation/pages/appreciation/appreciation_screen.dart';
import 'package:carma/features/onboarding/presentation/pages/onboarding/onboarding_one.dart';
import 'package:carma/features/splash/presentation/bloc/initialize_categories_bloc.dart';
import 'package:carma/features/splash/presentation/bloc/initialize_categories_event.dart';
import 'package:carma/features/splash/presentation/bloc/initialize_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Splash Screen Screen',
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.initializeSuperWall((){
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => locator<InitializeCategoriesBloc>()
              ..add(const InitializeCategories())),
      ],
      child: BlocListener<InitializeCategoriesBloc, InitializeCategoriesState>(
        listener: (context, state) {
          if (state is InitializedCategories) {
            Future.delayed(const Duration(seconds: 3), () async {
              String? isOnboarded = locator<SharedPreferences>()
                  .getString('isOnboarded');
              print('isOnboarded is this $isOnboarded');
              if (isOnboarded != null && isOnboarded == 'true') {
                _navigateToHomeScreen(context);
              } else {
                _navigateToAppreciationScreen(context);
              }
            });
          }
          if (state is InitializeCategoriesError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            Future.delayed(const Duration(seconds: 3), () async {
              String? isOnboarded = locator<SharedPreferences>()
                  .getString('isOnboarded');
              if (isOnboarded != null && isOnboarded == 'true') {
                _navigateToHomeScreen(context);
              } else {
                // _navigateToOnboardingScreenOne(context);
                _navigateToAppreciationScreen(context);
              }
            });
          }
        },
        child: Scaffold(
          body: Center(
            child:
            Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  // Adjust the radius as needed
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void _navigateToAppreciationScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppreciationScreen()));
  }

  // void _navigateToHomeScreen(BuildContext context) {
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
  //             create: (context) => locator<OdometerBloc>()
  //               ..add(
  //                 const GetOdometerReading(),
  //               ),
  //           ),
  //           BlocProvider(
  //             create: (context) => locator<MonthWiseFinancialsBloc>()
  //               ..add(
  //                 const FetchMonthWiseFinancials(),
  //               )
  //               ..add(const FetchLifeTimeFinancials()),
  //           ),
  //         ],
  //         child: const HomeScreen(),
  //       ),
  //     ),
  //   );
  // }

  void _navigateToHomeScreen(BuildContext context) async{

    await locator<SharedPreferences>()
        .setString('isOnboarded', 'true');
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => locator<TransactionBloc>()
                  ..add(
                    const FetchTransactions(),
                  ),
              ),
              BlocProvider(
                create: (context) => locator<CategoryWiseAmountBloc>()
                  ..add(
                    FetchCatagWiseAmount(
                        locator<App>().fromDate, locator<App>().toDate),
                  ),
              ),
              BlocProvider(
                create: (context) => locator<OdometerBloc>()
                  ..add(
                    const GetOdometerReading(),
                  ),
              ),
              BlocProvider(
                create: (context) => locator<MonthWiseFinancialsBloc>()
                  ..add(
                    const FetchMonthWiseFinancials(),
                  )
                  ..add(const FetchLifeTimeFinancials()),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );
    }
  }
}
