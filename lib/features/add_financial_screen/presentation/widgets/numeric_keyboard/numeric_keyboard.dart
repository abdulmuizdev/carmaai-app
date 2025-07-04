import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_state.dart';
import 'package:carma/features/add_financial_screen/presentation/widgets/numeric_keyboard/key_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NumericKeyboard extends StatefulWidget {
  final Function(String value, String notes, String selectedDate) onTickPressed;

  const NumericKeyboard({super.key, required this.onTickPressed});

  @override
  State<NumericKeyboard> createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  String numericText = '0';
  String _selectedDate = 'Today';
  String _selectedYear = '';
  DateTime _fullSelectedDate = DateTime.now();
  TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 18, right: 18, top: 9, bottom: 18),
          color: const Color(0xFfD3D2D7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                // Utils.formatNumber(numericText) ?? '0',
                numericText,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 14,
                decoration: BoxDecoration(
                  color: AppColors.white,
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
                          hintText: 'Enter a note...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 9),
                  ],
                ),
              ),
              SizedBox(height: 9),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 2,
                  children: [
                    KeyButton(
                      text: '7',
                      onPressed: () => onKeyPressed('7'),
                    ),
                    KeyButton(
                      text: '8',
                      onPressed: () => onKeyPressed('8'),
                    ),
                    KeyButton(
                      text: '9',
                      onPressed: () => onKeyPressed('9'),
                    ),
                    KeyButton(
                      backgroundColor: const Color(0xFFB7B8BD),
                      onPressed: () => {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 360 * 50)),
                          lastDate: DateTime.now().add(
                            const Duration(days: 360 * 50),
                          ),
                          initialDate: DateTime.now(),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            print(selectedDate.toIso8601String());
                            setState(() {
                              _fullSelectedDate = selectedDate;
                              _selectedDate =
                                  DateFormat('dd MMM').format(selectedDate);
                              _selectedYear =
                                  DateFormat('yy').format(selectedDate);
                            });
                          }
                        }),
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                            size: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (_selectedYear.isNotEmpty) ...[
                                Text(
                                  _selectedYear,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                    KeyButton(
                      text: '4',
                      onPressed: () => onKeyPressed('4'),
                    ),
                    KeyButton(
                      text: '5',
                      onPressed: () => onKeyPressed('5'),
                    ),
                    KeyButton(
                      text: '6',
                      onPressed: () => onKeyPressed('6'),
                    ),
                    KeyButton(
                      text: '+',
                      onPressed: () => {},
                    ),
                    KeyButton(
                      text: '1',
                      onPressed: () => onKeyPressed('1'),
                    ),
                    KeyButton(
                      text: '2',
                      onPressed: () => onKeyPressed('2'),
                    ),
                    KeyButton(
                      text: '3',
                      onPressed: () => onKeyPressed('3'),
                    ),
                    KeyButton(
                      text: '--',
                      onPressed: () => {},
                    ),
                    KeyButton(
                      text: '.',
                      onPressed: () => onKeyPressed('.'),
                    ),
                    KeyButton(
                      text: '0',
                      onPressed: () => onKeyPressed('0'),
                    ),
                    KeyButton(
                      child: Icon(
                        Icons.backspace_outlined,
                        color: AppColors.white,
                        size: 15,
                      ),
                      onPressed: () => onKeyPressed('backspace'),
                    ),
                    KeyButton(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color:
                            (double.tryParse(numericText.replaceAll(',', '')) ??
                                        0) >
                                    0
                                ? AppColors.primary
                                : const Color(0xFFB7B8BD),
                        size: 27,
                      ),
                      onPressed: () =>
                          (double.tryParse(numericText.replaceAll(',', '')) ??
                                      0) >
                                  0
                              ? widget.onTickPressed(
                            (double.tryParse(numericText.replaceAll(',', '')) ?? 0).toString(),
                                  _notesController.text,
                                  DateFormat(Utils.dateFormat).format(_fullSelectedDate),
                                )
                              : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
      } else if (RegExp(r'^[0-9.]$').hasMatch(key)) {
        Utils.playSound('sounds/type.wav');

        String plainNumber = numericText.replaceAll(',', '');
        String plainDigits = plainNumber.replaceAll(RegExp(r'\D'), '');

        if (plainDigits.length >= 10) return;

        if (key == '.') {
          if (!numericText.contains('.')) {
            numericText = numericText == '0' ? '0.' : numericText + '.';
          }
        } else if (key == '0') {
          if (numericText != '0' && !numericText.endsWith('.')) {
            numericText += '0';
          }
        } else {
          numericText = numericText == '0' ? key : numericText + key;
        }

        if (numericText.contains('.')) {
          int decimalIndex = numericText.indexOf('.');
          if (numericText.length - decimalIndex - 1 > 2) {
            numericText = numericText.substring(0, decimalIndex + 3);
          }
        }

        try {
          if (numericText.contains('.')) {
            double number = double.parse(numericText.replaceAll(',', ''));
            numericText = numericText.contains('.') && numericText.endsWith('.')
                ? numericText // Keep trailing dot if user just entered it
                : NumberFormat('#,##0.##', 'en_US').format(number);
          } else {
            int number = int.parse(numericText.replaceAll(',', ''));
            numericText = NumberFormat('#,##0', 'en_US').format(number);
          }
        } catch (_) {
          // Handle formatting errors
        }
      }
    });
  }
}
