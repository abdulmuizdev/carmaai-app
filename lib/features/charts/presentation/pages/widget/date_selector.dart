import 'package:carma/app/app.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_event.dart';
import 'package:carma/features/charts/presentation/pages/dialogs/selection_dialog.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {

  final CategoryWiseAmountBloc catagWiseAmountBloc;

  const DateSelector({super.key, required this.catagWiseAmountBloc});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late String _selectedMonth;
  late String _selectedYear;

  @override
  void initState() {
    super.initState();

    _selectedMonth = Utils.getCurrentMonth();
    _selectedYear = Utils.getCurrentYear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Month: ',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: SelectionDialog(
                        label: 'Select Month',
                        list: Constants.MONTHS,
                        initialSelectedString: _selectedMonth,
                        onDonePressed: (selectedMonth) {
                          print('selected Month is this $selectedMonth');
                          setState(() {
                            _selectedMonth = selectedMonth;
                          });
                          locator<App>().fromDate = Utils.getFirstDateOfMonth(_selectedMonth, _selectedYear);
                          locator<App>().toDate = Utils.getLastDateOfMonth(_selectedMonth, _selectedYear);
                          widget.catagWiseAmountBloc.add(
                                FetchCatagWiseAmount(
                                  locator<App>().fromDate,
                                  locator<App>().toDate,
                                ),
                              );
                        },
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedMonth,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      height: 0.5,
                      width: 50,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Year: ',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: SelectionDialog(
                        label: 'Select Year',
                        list: Utils.YEARS(),
                        initialSelectedString: _selectedYear,
                        onDonePressed: (selectedYear) {
                          print('selected Year is this $selectedYear');
                          setState(() {
                            _selectedYear = selectedYear;
                          });
                          locator<App>().fromDate = Utils.getFirstDateOfMonth(_selectedMonth, _selectedYear);
                          locator<App>().toDate = Utils.getLastDateOfMonth(_selectedMonth, _selectedYear);

                          widget.catagWiseAmountBloc.add(
                            FetchCatagWiseAmount(
                              locator<App>().fromDate,
                              locator<App>().toDate,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedYear,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      height: 0.5,
                      width: 50,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
