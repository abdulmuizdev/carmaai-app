import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/google_sign_in/presentation/pages/google_sign_in_screen.dart';
import 'package:carma/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:carma/features/profile/presentation/bloc/profile_event.dart';
import 'package:carma/features/profile/presentation/bloc/profile_state.dart';
import 'package:carma/features/profile/presentation/widgets/item_cell.dart';
import 'package:carma/features/rate_app_service/rate_app_service.dart';
import 'package:carma/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  final TransactionBloc transactionBloc;

  const ProfileScreen({super.key, required this.transactionBloc});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String _userEmail = 'Sign In';
  String _userId = 'Sign In, more exciting!';

  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Profile Screen',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<ProfileBloc>()..add(const GetSignedInUserInfo())),
      ],
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is SignedInUserInfoError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is GotSignedInUserInfo) {
            // print('Got signedin user info in profile');
            _userName = state.result.name;
            _userEmail = state.result.email;
            _userId = state.result.id;
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: 155,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: (155 / 2.5) - (49), left: 18),
                          child: GestureDetector(
                            onTap: () {
                              // showModalBottomSheet(
                              //   useSafeArea: true,
                              //   isScrollControlled: true,
                              //   context: context,
                              //   builder: (context) => const GoogleSignInScreen(),
                              // );
                              print('sign in clicked');
                              Navigator.of(context).push(Utils.createRoute(GoogleSignInScreen(
                                onSignedOutSuccessful: () {
                                  print('sign out is successful in profile');
                                  context.read<ProfileBloc>().add(const GetSignedInUserInfo());
                                },
                                onSignedInSuccessful: () {
                                  print('sign in is successful in profile');
                                  context.read<ProfileBloc>().add(const GetSignedInUserInfo());
                                },
                                onAccountDeletedSuccessful: () {
                                  print('Account deletion is successful in profile');
                                  context.read<ProfileBloc>().add(const GetSignedInUserInfo());
                                },
                              )));
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 49,
                                  height: 49,
                                  decoration: BoxDecoration(
                                      color: AppColors.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(49)),
                                  child: Center(
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: Image.asset(
                                        'assets/images/me_white.png',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userName ?? _userEmail,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        (double.tryParse(_userId) != null) ? 'id: $_userId' : _userId,
                                        style: TextStyle(
                                          color: AppColors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 155 - (60), left: 18, right: 18),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Container(
                                //   height: 60,
                                //   decoration: BoxDecoration(
                                //     color: AppColors.white,
                                //     borderRadius: BorderRadius.circular(12.5),
                                //     border: Border.all(
                                //       color: AppColors.primary.withOpacity(0.2),
                                //       width: 0.5,
                                //     ),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: AppColors.primary.withOpacity(0.16),
                                //         offset: const Offset(0, 3),
                                //         blurRadius: 6,
                                //       )
                                //     ],
                                //   ),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(18),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Row(
                                //           children: [
                                //             Image.asset('assets/images/premium.png'),
                                //             const SizedBox(width: 10),
                                //             Text(
                                //               'Premium Member',
                                //               style: TextStyle(
                                //                 fontSize: 16,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: AppColors.secondary,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //         Icon(
                                //           Icons.arrow_forward_ios_rounded,
                                //           color: AppColors.secondary.withOpacity(0.5),
                                //           size: 12,
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 18),
                                Container(
                                  // height: 243,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Column(
                                    children: [
                                      ItemCell(
                                        imageAsset: 'assets/images/recommend.png',
                                        label: 'Recommend to friends',
                                        onPressed: () {
                                          print('pressed');
                                          const String message = '''
                                      Hey! 🚗💰
                                      
                                      I just found this awesome app called Carma AI, perfect personal management tool for car owners. It helps you easily manage all your car-related finances, including tracking your expenses, income, and even your odometer with the help of AI-recognizable pictures. It's a game changer for keeping your car finances organized!
                                      
                                      Check it out and give it a try:
                                      https://www.carmaai.app
                                  ''';
                                          Share.share(message);
                                        },
                                      ),
                                      ItemCell(
                                        imageAsset: 'assets/images/rate_app.png',
                                        label: 'Rate the app',
                                        onPressed: () {
                                          RateAppService.rateApp();
                                        },
                                      ),
                                      // ItemCell(
                                      //   imageAsset: 'assets/images/block_ads.png',
                                      //   label: 'Block ads',
                                      //   onPressed: () {},
                                      // ),
                                      ItemCell(
                                        imageAsset: 'assets/images/settings.png',
                                        label: 'Settings',
                                        isLast: true,
                                        onPressed: () {
                                          Utils.playSound('sounds/in.wav');
                                          Navigator.of(context).push(
                                              Utils.createRoute(SettingsScreen(transactionBloc: widget.transactionBloc)));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
