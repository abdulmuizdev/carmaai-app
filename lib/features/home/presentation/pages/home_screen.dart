import 'package:carma/app/app.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_state.dart';
import 'package:carma/features/add_financial_screen/presentation/pages/add_financial_screen.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_event.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/charts/presentation/pages/charts_screen.dart';
import 'package:carma/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:carma/features/home/presentation/widget/navigation_item.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_screen/odometer_screen.dart';
import 'package:carma/features/profile/presentation/pages/profileScreen.dart';
import 'package:carma/features/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    print('home screen opened');
    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name': 'Home Screen',
    });
    // validatePaywall();
    _animationController = AnimationController(vsync: this, duration: 2000.ms)
      ..repeat(reverse: false);
    _animationController.reset();
    final transactionBloc = context.read<TransactionBloc>();
    final catagWiseAmountBloc = context.read<CategoryWiseAmountBloc>();
    final monthWiseFinancialsBloc = context.read<MonthWiseFinancialsBloc>();
    final odometerBloc = context.read<OdometerBloc>();
    _widgetOptions = <Widget>[
      DashboardScreen(transactionBloc: transactionBloc),
      ChartsScreen(
          catagWiseAmountBloc: catagWiseAmountBloc,
          monthWiseFinancialsBloc: monthWiseFinancialsBloc),
      OdometerScreen(odometerBloc: odometerBloc),
      ProfileScreen(transactionBloc: transactionBloc),
    ];
  }

  void validatePaywall() async {
    final status = await Superwall.shared.getIsConfigured();
    print('Validating paywall');
    print('Validating paywall $status');
    Superwall.shared.registerEvent('full_access', feature: () {
      print('ACCESS IS GRANTED');
      locator<Mixpanel>().track('Converted');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is SavedTransaction) {
          context.read<TransactionBloc>().add(const FetchTransactions());

          context.read<CategoryWiseAmountBloc>().add(FetchCatagWiseAmount(
              locator<App>().fromDate, locator<App>().toDate));

          context
              .read<MonthWiseFinancialsBloc>()
              .add(const FetchMonthWiseFinancials());

          context
              .read<MonthWiseFinancialsBloc>()
              .add(const FetchLifeTimeFinancials());

          _animationController.reset();
        }
        if (state is UpdateData) {
          context.read<TransactionBloc>().add(const FetchTransactions());

          context.read<CategoryWiseAmountBloc>().add(FetchCatagWiseAmount(
              locator<App>().fromDate, locator<App>().toDate));

          context
              .read<MonthWiseFinancialsBloc>()
              .add(const FetchMonthWiseFinancials());

          context
              .read<MonthWiseFinancialsBloc>()
              .add(const FetchLifeTimeFinancials());

          context.read<OdometerBloc>().add(const GetOdometerReading());

          _animationController.reset();
        }
        if (state is FetchedTransactions) {
          if (state.result.isEmpty) {
            _animationController.repeat(reverse: false);
          }
        }
        if (state is SaveTransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: AppColors.white,
              floatingActionButton: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    // effects: [
                    //   FadeEffect(duration: 2000.ms, curve: Curves.easeInOut, begin: 0.3, end: 0.8),
                    //   ScaleEffect(duration: 2000.ms, curve: Curves.easeInOut, begin: Offset(1.0, 1.0), end: Offset(1.5, 1.5))
                    // ],
                    // Tween<double>(begin: 0.3, end: 0.8).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)).value,
                    builder: (context, child) {
                      return Opacity(
                        opacity: Tween<double>(begin: 0.7, end: 0)
                            .animate(CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.easeInOut))
                            .value,
                        child: Transform.scale(
                          scale: Tween<double>(begin: 1.0, end: 1.6)
                              .animate(CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeInOut))
                              .value,
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      locator<Mixpanel>().track('Add Financial Clicked');
                      Utils.playSound('sounds/in.wav');
                      Navigator.of(context).push(
                        Utils.createRoute(
                          AddFinancialScreen(blocContext: context),
                        ),
                      );
                    },
                    elevation: 0,
                    // mini: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                surfaceTintColor: AppColors.primary,
                height: 60,
                padding: EdgeInsets.zero,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  children: [
                    NavigationItem(
                        imageAsset: 'assets/images/home.png',
                        imageAssetToggled: 'assets/images/home_toggled.png',
                        label: 'Home',
                        isSelected: _selectedIndex == 0,
                        onTap: () => _onItemTapped(0)),
                    NavigationItem(
                        imageAsset: 'assets/images/charts.png',
                        imageAssetToggled: 'assets/images/charts_toggled.png',
                        label: 'Charts',
                        isSelected: _selectedIndex == 1,
                        onTap: () => _onItemTapped(1)),
                    NavigationItem(
                        imageAsset: 'assets/images/home.png',
                        imageAssetToggled: 'assets/images/home_toggled.png',
                        label: '',
                        isSelected: false,
                        onTap: () => _onItemTapped(2)),
                    NavigationItem(
                        imageAsset: 'assets/images/mileage.png',
                        imageAssetToggled: 'assets/images/mileage_toggled.png',
                        label: 'Mileage',
                        isSelected: _selectedIndex == 2,
                        onTap: () => _onItemTapped(2)),
                    NavigationItem(
                        imageAsset: 'assets/images/me.png',
                        imageAssetToggled: 'assets/images/me_toggled.png',
                        label: 'Me',
                        isSelected: _selectedIndex == 3,
                        onTap: () => _onItemTapped(3))
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 128,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                    ),
                  ),
                  IndexedStack(
                    index: _selectedIndex,
                    children: _widgetOptions,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
