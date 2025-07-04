import 'dart:io';

import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiResultsDialog extends StatefulWidget {
  final BuildContext blocContext;
  final File image;
  final Function(String reading, String notes) onDonePressed;
  final Function(String reading) onEditPressed;

  const AiResultsDialog(
      {super.key,
      required this.image,
      required this.blocContext,
      required this.onDonePressed,
      required this.onEditPressed});

  @override
  State<AiResultsDialog> createState() => _AiResultsDialogState();
}

class _AiResultsDialogState extends State<AiResultsDialog> {
  String _reading = '--';
  String _label = 'Analyzing...';
  bool _isButtonEnabled = false;
  TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<OdometerBloc>()..add(AnalyzeOdometerWithAI(widget.image)))
      ],
      child: BlocListener<OdometerBloc, OdometerState>(
        listener: (context, state) {
          print('state listener is called');
          if (state is AnalyzeOdometerWithAIError) {
            print('error is there');
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is AnalyzedOdometerWithAI) {
            print('successful with cute girl');
            _reading = state.odometerReading;
            _label = 'Odometer Reading';
            _isButtonEnabled = true;
          }
        },
        child: BlocBuilder<OdometerBloc, OdometerState>(
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.transparent,
                          ),
                        ),
                        Text(
                          _label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _reading,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontFamily: 'Digital7',
                        fontSize: 80,
                        letterSpacing: 10,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFfD3D2D7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 18),
                            Text(
                              'Note:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: TextField(
                                controller: _notesController,
                                decoration: InputDecoration(
                                  hintText: 'e.g, Changed oil',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: 9),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: (double.tryParse(_reading) != null) ? () => widget.onEditPressed(_reading) : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.secondary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, color: AppColors.secondary),
                                const SizedBox(width: 5),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: ((double.tryParse(_reading) != null) ? () => widget.onDonePressed(_reading, _notesController.text) : null),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: AppColors.primary,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline_rounded, color: AppColors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Done',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
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
