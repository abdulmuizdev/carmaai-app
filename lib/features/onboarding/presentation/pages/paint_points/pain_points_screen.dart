import 'package:carma/app/app.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_event.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/home/presentation/pages/home_screen.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PainPointsScreen extends StatefulWidget {
  const PainPointsScreen({super.key});

  @override
  State<PainPointsScreen> createState() => _PainPointsScreenState();
}

class _PainPointsScreenState extends State<PainPointsScreen> {

  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Pain Points Screen',
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _painPoints = [
      'Forgetting Expenses',
      'Having messy receipts everywhere',
      '''Unaware of your vehicle's financials''',
      'Remembering your odometer',
      '''Unaware of vehicle's lifetime expenses while selling''',
    ];
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
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

                  const Spacer(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _navigateToHomeScreen(context);
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
                          '''Let's Solve it! ''',
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '''You may be:''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                        itemCount: _painPoints.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 35,
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.cancel_rounded, color: AppColors.red),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _painPoints[index],
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
