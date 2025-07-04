import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/odometer/presentation/pages/odometer_entry_screen/widgets/numeric_keyboard_odometer/key_button_odometer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumericKeyboardOdometer extends StatefulWidget {
  final Function(String value) onTextChange;

  const NumericKeyboardOdometer({super.key, required this.onTextChange});

  @override
  State<NumericKeyboardOdometer> createState() =>
      _NumericKeyboardOdometerState();
}

class _NumericKeyboardOdometerState extends State<NumericKeyboardOdometer> {
  String numericText = '0';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          // height: MediaQuery.of(context).size.height / 2.35,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 18, right: 18, top: 9, bottom: 18),
          color: const Color(0xFfD3D2D7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text(
              //   // Utils.formatNumber(numericText) ?? '0',
              //   numericText,
              //   style: TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.secondary,
              //   ),
              // ),
              SizedBox(height: 9),
              GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 2,
                children: [
                  KeyButtonOdometer(
                    text: '7',
                    onPressed: () => onKeyPressed('7'),
                  ),
                  KeyButtonOdometer(
                    text: '8',
                    onPressed: () => onKeyPressed('8'),
                  ),
                  KeyButtonOdometer(
                    text: '9',
                    onPressed: () => onKeyPressed('9'),
                  ),
                  KeyButtonOdometer(
                    child: Icon(
                      Icons.backspace_outlined,
                      color: AppColors.white,
                      size: 15,
                    ),
                    backgroundColor: AppColors.secondary.withOpacity(0.7),
                    onPressed: () => onKeyPressed('backspace'),
                  ),
                  KeyButtonOdometer(
                    text: '4',
                    onPressed: () => onKeyPressed('4'),
                  ),
                  KeyButtonOdometer(
                    text: '5',
                    onPressed: () => onKeyPressed('5'),
                  ),
                  KeyButtonOdometer(
                    text: '6',
                    onPressed: () => onKeyPressed('6'),
                  ),
                  Container(),
                  KeyButtonOdometer(
                    text: '1',
                    onPressed: () => onKeyPressed('1'),
                  ),
                  KeyButtonOdometer(
                    text: '2',
                    onPressed: () => onKeyPressed('2'),
                  ),
                  KeyButtonOdometer(
                    text: '3',
                    onPressed: () => onKeyPressed('3'),
                  ),
                  Container(),
                  Container(),
                  KeyButtonOdometer(
                    text: '0',
                    onPressed: () => onKeyPressed('0'),
                  ),
                  Container(),
                  // KeyButtonOdometer(
                  //   backgroundColor: Colors.transparent,
                  //   child: Icon(
                  //     Icons.check_circle_outline_rounded,
                  //     color:
                  //         (double.tryParse(numericText.replaceAll(',', '')) ??
                  //                     0) >
                  //                 0
                  //             ? AppColors.primary
                  //             : const Color(0xFFB7B8BD),
                  //     size: 27,
                  //   ),
                  //   onPressed:
                  //       ((double.tryParse(numericText.replaceAll(',', '')) ??
                  //                   0) >
                  //               0)
                  //           ? () {
                  //               widget.onTickPressed((double.tryParse(
                  //                           numericText.replaceAll(',', '')) ??
                  //                       0)
                  //                   .toStringAsFixed(0));
                  //               Utils.playSound('sounds/submit.wav');
                  //               Navigator.of(context).pop();
                  //             }
                  //           : () {},
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  void onKeyPressed(String key) {
    setState(() {
      if (key == 'backspace') {
        Utils.playSound('sounds/backspace.wav');
        if (numericText.isNotEmpty && numericText != '0') {
          numericText = numericText.substring(0, numericText.length - 1);
        }
        if (numericText.isEmpty) {
          numericText = '0';
        }
      } else if (RegExp(r'^[0-9]$').hasMatch(key)) { // Removed '.' from regex
        Utils.playSound('sounds/type.wav');

        String plainNumber = numericText.replaceAll(',', '');
        String plainDigits = plainNumber.replaceAll(RegExp(r'\D'), '');

        if (plainDigits.length >= 6) return;

        numericText = numericText == '0' ? key : numericText + key;

        try {
          int number = int.parse(numericText.replaceAll(',', ''));
          numericText = NumberFormat('#,##0', 'en_US').format(number);
        } catch (_) {
          // Handle formatting errors
        }
      }
    });

    print('final numeric text is this $numericText');
    widget.onTextChange(numericText);
  }

}
