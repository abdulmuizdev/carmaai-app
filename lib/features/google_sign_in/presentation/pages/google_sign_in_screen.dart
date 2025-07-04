import 'package:carma/common/presentation/bloc/google_sign_in_bloc.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_event.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_state.dart';
import 'package:carma/common/widgets/carma_loading_dialog.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/sub_screens/non_signed_in_screen.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/sub_screens/signed_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class GoogleSignInScreen extends StatefulWidget {
  final VoidCallback onSignedInSuccessful;
  final VoidCallback onSignedOutSuccessful;
  final VoidCallback onAccountDeletedSuccessful;

  const GoogleSignInScreen({
    super.key,
    required this.onSignedInSuccessful,
    required this.onSignedOutSuccessful,
    required this.onAccountDeletedSuccessful,
  });

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isUserSignedIn = false;
  String _id = '--';
  String? _name;
  String _email = '--';

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
          if (state is SignOutError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is SignedIn) {
            Navigator.of(context).pop();
            widget.onSignedInSuccessful();
          }
          if (state is SignedOut) {
            Navigator.of(context).pop();
            widget.onSignedOutSuccessful();
          }
          if (state is DeletedAccount) {
            Navigator.of(context).pop();
            widget.onAccountDeletedSuccessful();
          }

          if (state is DeleteAccountError) {
            print('error is this ${state.message}');
          }

          if (state is CheckIsUserSignedInError) {}

          if (state is CheckedIsUserSignedIn) {
            _isUserSignedIn = (state.result != null);

            if (state.result != null) {
              _id = state.result!.id;
              _name = state.result!.name;
              _email = state.result!.email;
            }
          }
        },
        child: BlocBuilder<GoogleSignInBloc, GoogleSignInState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(26),
                                    bottomRight: Radius.circular(26),
                                  ),
                                ),
                              ),
                              SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Utils.playSound(
                                                    'sounds/out.wav');
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              (_isUserSignedIn)
                                                  ? 'Profile'
                                                  : 'Sign In',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 155 - 70),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(26),
                                                      topRight:
                                                          Radius.circular(26),
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      if (_isUserSignedIn) ...[
                                                        // Maybe it require all 18 padding
                                                        SignedInScreen(
                                                          id: _id,
                                                          name: _name,
                                                          email: _email,
                                                          blocContext: context,
                                                        ),
                                                      ] else ...[
                                                        NonSignedInScreen(
                                                          onSignInWithGooglePressed:
                                                              () {
                                                            context
                                                                .read<
                                                                    GoogleSignInBloc>()
                                                                .add(
                                                                    SignIn());
                                                          },
                                                          onSignInWithApplePressed: () async {
                                                            context.read<GoogleSignInBloc>()
                                                                .add(SignIn(isApple: true));
                                                          },
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                  ),
                  if (state is SigningIn) ...[
                    const Center(child: CarmaLoadingDialog()),
                  ],
                  if (state is SigningOut) ...[
                    const Center(child: CarmaLoadingDialog()),
                  ],
                  if (state is DeletingAccount) ...[
                    const Center(child: CarmaLoadingDialog()),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
