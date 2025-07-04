import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:carma/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteDataConfirmationDialog extends StatelessWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;
  final SettingsBloc bloc;

  const DeleteDataConfirmationDialog(
      {super.key,
      required this.onCancelPressed,
      required this.onConfirmPressed,
      required this.bloc,
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state){
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Text(
                      'Are you sure to delete?',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This operation will delete all data, please be careful!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                height: 0.5,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // if (_controller.text.isNotEmpty) {
                  //   await locator<Mixpanel>().track('Feedback', properties: {"Message" : _controller.text});
                  //   Navigator.of(context).pop();
                  // }else {
                  //   print('text is empty cute girl');
                  // }

                  Navigator.of(context).pop();
                  onConfirmPressed();
                },
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 0.5,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              GestureDetector(
                onTap: () {

                  Navigator.of(context).pop();
                  onCancelPressed();
                },
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
