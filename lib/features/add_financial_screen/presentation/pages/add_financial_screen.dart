import 'dart:math';

import 'package:carma/common/widgets/carma_app_bar.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/financial_type/financial_type_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/financial_type/financial_type_event.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/financial_type/financial_type_state.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_state.dart';
import 'package:carma/features/add_financial_screen/presentation/widgets/financial_type_widget.dart';
import 'package:carma/features/add_financial_screen/presentation/widgets/numeric_keyboard/numeric_keyboard.dart';
import 'package:carma/common/widgets/type_selection_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class AddFinancialScreen extends StatefulWidget {
  final BuildContext blocContext;

  const AddFinancialScreen({super.key, required this.blocContext});

  @override
  State<AddFinancialScreen> createState() => _AddFinancialScreenState();
}

class _AddFinancialScreenState extends State<AddFinancialScreen> {
  int _tabIndex = 0;
  bool _showNumericKeypad = false;
  String _selectedCategoryId = '';
  String _selectedCategoryName = '';

  List<FinancialTypeEntity> _onFinancialTypePressed(
      List<FinancialTypeEntity> list, int index) {
    print('financial pressed');
    // Utils.playSound('sounds/select.wav');
    setState(() {
      _showNumericKeypad = true;
    });
    return list
        .asMap()
        .entries
        .map((e) => e.value.copyWith(isSelected: e.key == index))
        .toList();
  }

  List<FinancialTypeEntity> expenses = [];
  List<FinancialTypeEntity> incomes = [];

  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Add Financial Screen',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => locator<FinancialTypeBloc>()
              ..add(const FetchExpenseTypes())
              ..add(const FetchIncomeTypes()))
      ],
      child: BlocListener<FinancialTypeBloc, FinancialTypeState>(
        listener: (context, state) {
          if (state is FetchedExpenseTypes) {
            expenses = state.result;
            print('expenses length at ui');
            print(expenses.length);
          }
          if (state is FetchedIncomeTypes) {
            incomes = state.result;
            print('incomes length at ui');
            print(incomes.length);
          }
          if (state is FetchIncomeTypesError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is FetchExpenseTypesError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<FinancialTypeBloc, FinancialTypeState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.white,
              body: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              CarmaAppBar(label: 'Add'),
                              SizedBox(height: 20),
                              TypeSelectionTab(
                                onSelectionChange: (selectedIndex) {
                                  setState(() {
                                    _tabIndex = selectedIndex;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: AppColors.white,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // 4 columns
                              crossAxisSpacing: 10, // Horizontal spacing
                              mainAxisSpacing: 10, // Vertical spacing
                              childAspectRatio:
                                  1, // To make the grid items square
                            ),
                            itemCount: (_tabIndex == 0)
                                ? expenses.length
                                : incomes.length,
                            // You can change the item count here
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              if (_tabIndex == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    print(
                                        '${expenses[index]} selected with expense');

                                    setState(() {
                                      expenses = _onFinancialTypePressed(
                                          expenses, index);
                                      _selectedCategoryId =
                                          expenses[index].id!;
                                      _selectedCategoryName =
                                          expenses[index].label;
                                    });
                                  },
                                  child: FinancialTypeWidget(
                                      entity: expenses[index]),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    print(
                                        '${incomes[index]} selected with income');
                                    setState(() {
                                      incomes = _onFinancialTypePressed(
                                          incomes, index);
                                      _selectedCategoryId =
                                          incomes[index].id!;
                                      _selectedCategoryName =
                                          incomes[index].label;
                                    });
                                  },
                                  child: FinancialTypeWidget(
                                      entity: incomes[index]),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      if (_showNumericKeypad == true) ...[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BlocProvider.value(
                            value: locator<TransactionBloc>(),
                            child: NumericKeyboard(
                              onTickPressed:
                                  (value, notes, selectedDate) {
                                Utils.playSound('sounds/submit.wav');

                                final entity = TransactionEntity(
                                  type: _tabIndex,
                                  categoryId: _selectedCategoryId,
                                  categoryName: _selectedCategoryName,
                                  amount: value,
                                  date: selectedDate,
                                  time: Utils.getCurrentTime(),
                                  notes: notes,
                                );

                                widget.blocContext
                                    .read<TransactionBloc>()
                                    .add(SaveTransaction(entity));

                                locator<Mixpanel>().track(
                                    'Transaction Saved',
                                    properties: entity.toJson());

                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ]
                    ],
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
