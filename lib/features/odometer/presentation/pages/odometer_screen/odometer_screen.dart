import 'dart:io';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/odometer/domain/entities/odometer_reading_entity.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_state.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_entry_screen/odometer_entry_screen.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_screen/widgets/buttons/odometer_button.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_screen/widgets/dialogs/ai_results_dialog.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_screen/widgets/odometer_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class OdometerScreen extends StatefulWidget {
  final OdometerBloc odometerBloc;

  const OdometerScreen({super.key, required this.odometerBloc});

  @override
  State<OdometerScreen> createState() => _OdometerScreenState();
}

class _OdometerScreenState extends State<OdometerScreen> {
  String _odometerReading = '--';
  String _notes = '(km / miles) driven';
  List<OdometerReadingEntity> _pastReadings = [];

  // File? _image;

  Future<void> _pickImage(
      BuildContext blocContext, ImageSource source, Function(File imageFile) onSuccessfulImagePicked) async {
    try {
      File? imageFile;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          imageFile = File(image.path);
        });
        if (imageFile != null) {
          // blocContext.read<OdometerBloc>().add(AnalyzeOdometerWithAI(_image!));
          onSuccessfulImagePicked(imageFile!);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OdometerBloc, OdometerState>(
      bloc: widget.odometerBloc,
      listener: (context, state) {
        if (state is GotOdometerReading) {
          _odometerReading = state.latestReading;
          _notes = state.notes;
          _pastReadings = state.pastReadings;
        }
        if (state is OdometerReadingError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AnalyzeOdometerWithAIError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is UpdatedOdometerReading) {
          _odometerReading = state.updatedReading;
          _notes = state.notes;
          _pastReadings = state.pastReadings;
        }
        if (state is UpdatedAIOdometerReading) {
          // Close the AI Analysis Dialog
          Navigator.of(context).pop();
          _odometerReading = state.updatedReading;
          _notes = state.notes;
          _pastReadings = state.pastReadings;
        }
        if (state is AnalyzedOdometerWithAI) {
          print('here is the detected odometer reading ${state.odometerReading}');
        }
      },
      child: BlocBuilder<OdometerBloc, OdometerState>(
        builder: (blocContext, state) {
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(blocContext).size.width,
                        // height: 128,
                        decoration: BoxDecoration(

                        color: AppColors.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                Text(
                                  'Odometer Reading',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Container(
                          width: MediaQuery.of(blocContext).size.width,
                          height: MediaQuery.of(blocContext).size.width / 2.8,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  _odometerReading,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'Digital7',
                                    fontSize: 90,
                                    letterSpacing: 10,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                                  child: Text(
                                    (_notes.isNotEmpty) ? _notes : '(km / miles) driven',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OdometerButton(
                            image: 'assets/images/scan.png',
                            isAiPowered: true,
                            label: 'Scan',
                            onPressed: () {
                              locator<Mixpanel>().track('Scan Clicked');
                              _pickImage(blocContext, ImageSource.camera, (image) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: AiResultsDialog(
                                            blocContext: blocContext,
                                            image: image,
                                            onEditPressed: (value) {
                                              print('edit is pressed ');
                                              Navigator.of(context).pop();
                                              _openOdometerEntryScreen(blocContext, true);
                                            },
                                            onDonePressed: (value, notes) {
                                              print('done is pressed ');
                                              print('selected value is this $value');
                                              Utils.playSound('sounds/submit.wav');
                                              blocContext.read<OdometerBloc>().add(UpdateAIOdometerReading(value, notes));
                                            },
                                          ),
                                        ));
                              });
                            },
                          ),
                          OdometerButton(
                            image: 'assets/images/edit.png',
                            label: 'Update',
                            onPressed: () {
                              locator<Mixpanel>().track('Update Clicked');
                              _openOdometerEntryScreen(blocContext, null);
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, top: 18),
                          child: Text(
                            'Odometer History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Stack(
                            children: [
                              if (_pastReadings.isNotEmpty) ...[
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _pastReadings.length,
                                  itemBuilder: (context, index) {
                                    return OdometerHistoryItem(
                                      reading: _pastReadings[index].reading,
                                      date: _pastReadings[index].date,
                                      imageAsset: 'assets/images/mileage.png',
                                      notes: _pastReadings[index].notes,
                                      isLast: index == (_pastReadings.length - 1),
                                    );
                                  },
                                ),
                              ] else ...[
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return OdometerHistoryItem(
                                      reading: '--',
                                      notes: '--',
                                      date: '--',
                                      imageAsset: 'assets/images/mileage.png',
                                      isLast: true,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openOdometerEntryScreen(BuildContext blocContext, bool? isEdit) {
    Utils.playSound('sounds/in.wav');
    Navigator.of(context).push(
      Utils.createRoute(
        OdometerEntryScreen(
          isEdit: isEdit,
          onDonePressed: (value, notes) {
            print('selected value is this $value');
            blocContext.read<OdometerBloc>().add(UpdateOdometerReading(value, notes));
          },
        ),
      ),
    );
  }
}
