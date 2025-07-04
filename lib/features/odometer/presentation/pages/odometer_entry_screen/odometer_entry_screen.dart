import 'package:carma/common/widgets/carma_app_bar.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_entry_screen/dialog/notes_dialog.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_entry_screen/widgets/numeric_keyboard_odometer/key_button_odometer.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_entry_screen/widgets/numeric_keyboard_odometer/numeric_keyboard_odometer.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class OdometerEntryScreen extends StatefulWidget {
  final bool? isEdit;
  final Function(String value, String notes) onDonePressed;

  const OdometerEntryScreen({super.key, required this.onDonePressed, this.isEdit});

  @override
  State<OdometerEntryScreen> createState() => _OdometerEntryScreenState();
}

class _OdometerEntryScreenState extends State<OdometerEntryScreen> {
  final TextEditingController _controller = TextEditingController()..text = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                // height: 65,
                // height: 80,
                decoration: BoxDecoration(
                color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                ),
                child: const SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: CarmaAppBar(label: 'Odometer'),
                  ),
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (widget.isEdit ?? false) ? 'Edit Mileage' : 'Update Mileage',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.isEdit ?? false) ...[
                                Text(
                                  'This will help us improve our AI',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: AppColors.secondary.withOpacity(0.3)),
                                ),
                              ],
                              const SizedBox(height: 36),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height / 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFfD3D2D7),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 9),
                                          Expanded(
                                            child: TextField(
                                              readOnly: true,
                                              keyboardType: TextInputType.number,
                                              maxLength: 6,
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                // hintText: 'Enter a note...',
                                                border: InputBorder.none,
                                                counterText: '',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 9),
                                          Text(
                                            'km / miles',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                          SizedBox(width: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 9),
                                  KeyButtonOdometer(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: (double.tryParse(_controller.text.replaceAll(',', '')) ?? 0) > 0
                                          ? AppColors.primary
                                          : const Color(0xFFB7B8BD),
                                      size: 27,
                                    ),
                                    onPressed: ((double.tryParse(_controller.text.replaceAll(',', '')) ?? 0) > 0)
                                        ? () {
                                            final value = (double.tryParse(_controller.text.replaceAll(',', '')) ?? 0)
                                                .toStringAsFixed(0);

                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: NotesDialog(
                                                  onDonePressed: (notes) {
                                                    widget.onDonePressed(value, notes);
                                                    Utils.playSound('sounds/submit.wav');

                                                    locator<Mixpanel>().track('Odometer Updated', properties: {
                                                      'isEdit': widget.isEdit,
                                                      'value': value,
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        : () {
                                            print('rejected');
                                          },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NumericKeyboardOdometer(onTextChange: (value) {
              setState(() {
                _controller.text = value;
              });
            }),
          ),
        ],
      ),
    );
  }
}
