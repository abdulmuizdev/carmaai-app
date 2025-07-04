import 'package:carma/common/widgets/carma_app_bar.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:carma/features/settings/presentation/bloc/settings_event.dart';
import 'package:carma/features/settings/presentation/bloc/settings_state.dart';
import 'package:carma/features/settings/presentation/widgets/dialogs/delete_data_confirmation_dialog.dart';
import 'package:carma/features/settings/presentation/widgets/settings_item.dart';
import 'package:carma/features/settings/presentation/widgets/settings_switch_item.dart';
import 'package:carma/features/static/presentation/pages/about_us_screen.dart';
import 'package:carma/features/static/presentation/pages/privacy_policy_screen.dart';
import 'package:carma/features/static/presentation/pages/terms_and_conditions_screen.dart';
import 'package:carma/features/static/presentation/widgets/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class SettingsScreen extends StatefulWidget {
  final TransactionBloc transactionBloc;

  const SettingsScreen({super.key, required this.transactionBloc});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEffectState = true;
  String _lastBackupDate = '--';

  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Settings Screen',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                locator<SettingsBloc>()..add(const GetSavedSettings())),
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is GetSettingsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is ChangedSoundEffectSetting) {
            _soundEffectState = state.changedState;
          }

          if (state is GotSettings) {
            _soundEffectState = state.soundSetting;
            _lastBackupDate = state.lastBackup;
            print('got sound effect settings $_soundEffectState');
          }

          if (state is DeleteAllDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }

          if (state is DeletedAllData) {
            widget.transactionBloc.add(const UpdateDataEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All data deleted successfully'),
              ),
            );
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (blocContext, state) {
            return Scaffold(
              backgroundColor: AppColors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: SafeArea(child: CarmaAppBar(label: 'Settings')),
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          SizedBox(height: 18),
                          SettingsSwitchItem(
                            label: 'Sound Effects',
                            imageAsset: 'assets/images/sound.png',
                            isChecked: _soundEffectState,
                            onChanged: (isChecked) {
                              blocContext
                                  .read<SettingsBloc>()
                                  .add(ChangeSoundEffectSetting(isChecked));
                            },
                          ),
                          SettingsItem(
                            label: 'Delete all data',
                            imageAsset: 'assets/images/delete.png',
                            onPressed: () {
                              print('clear data command');
                              showDialog(
                                context: blocContext,
                                builder: (context) => Dialog(
                                  child: DeleteDataConfirmationDialog(
                                    bloc: blocContext.read<SettingsBloc>(),
                                    onCancelPressed: () {},
                                    onConfirmPressed: () {
                                      blocContext
                                          .read<SettingsBloc>()
                                          .add(const DeleteAllData());
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          SettingsItem(
                            label: 'Automatically backup data',
                            imageAsset: 'assets/images/backup.png',
                            trailing: Text(_lastBackupDate),
                            onPressed: () {},
                          ),
                          // SettingsItem(
                          //   label: 'Terms of use',
                          //   imageAsset: 'assets/images/terms.png',
                          //   trailing: Container(),
                          //   onPressed: () {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) =>
                          //             const TermsOfUseScreen()));
                          //   },
                          // ),
                          SettingsItem(
                            label: 'Privacy Policy',
                            imageAsset: 'assets/images/privacy.png',
                            trailing: Container(),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyScreen()));
                            },
                          ),
                          SettingsItem(
                            label: 'Terms and Conditions',
                            imageAsset: 'assets/images/terms.png',
                            trailing: Container(),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsAndConditionsScreen()));
                            },
                          ),
                          SettingsItem(
                            label: 'About us',
                            imageAsset: 'assets/images/about.png',
                            trailing: Container(),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AboutUsScreen()));
                            },
                          ),
                          SettingsItem(
                            label: 'Feedback',
                            imageAsset: 'assets/images/feedback.png',
                            trailing: Container(),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: FeedbackDialog(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
