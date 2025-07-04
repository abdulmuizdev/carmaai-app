import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_state.dart';
import 'package:carma/features/dashboard/presentation/widget/balance_card.dart';
import 'package:carma/features/dashboard/presentation/widget/balance_detail_card.dart';
import 'package:carma/features/dashboard/presentation/widget/transaction_list_item.dart';
import 'package:carma/features/transaction_detail/transaction_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  final TransactionBloc transactionBloc;

  const DashboardScreen({super.key, required this.transactionBloc});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionEntity> _transactions = [];
  String _totalIncome = '--';
  String _totalExpenses = '--';
  String _netBalance = '--';
  final _currentMonth = Utils.getCurrentMonth(showYear: true);

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: widget.transactionBloc,
      listener: (context, state) {
        if (state is FetchedTransactions) {
          setState(() {
            _transactions = state.result;
            _totalIncome = state.totalIncome;
            _totalExpenses = state.totalExpenses;
            _netBalance = state.netBalance;
          });
        }
        if (state is FetchTransactionsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is DeleteTransactionError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is DeletedTransaction) {
          context.read<TransactionBloc>().add(const UpdateDataEvent());
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.successMessage),
                behavior: SnackBarBehavior.floating),
          );
        }
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                _currentMonth,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.secondary.withOpacity(0.4),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: Container(
                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: AppColors.primary.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    BalanceCard(value: _netBalance),
                                    const SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BalanceDetailCard(
                                            isExpense: true,
                                            value: _totalExpenses),
                                        BalanceDetailCard(
                                            isExpense: false,
                                            value: _totalIncome),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18,
                          top: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction List',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondary,
                                ),
                              ),
                              if (_transactions.isNotEmpty) ...[
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _transactions.length,
                                  itemBuilder: (context, index) {
                                    final currentTransaction =
                                        _transactions[index];
                                    final currentDate = currentTransaction.date;

                                    // Check if it's the first transaction of this date
                                    bool showDate = index == 0 ||
                                        _transactions[index - 1].date !=
                                            currentDate;

                                    // Calculate the total daily expenses and income
                                    double totalDailyExpenses = 0;
                                    double totalDailyIncome = 0;

                                    // Sum up the expenses and income for the current date
                                    for (var transaction in _transactions) {
                                      if (transaction.date == currentDate) {
                                        if (transaction.type == 0) {
                                          totalDailyExpenses += double.tryParse(
                                                  transaction.amount) ??
                                              0; // Expense
                                        } else {
                                          totalDailyIncome += double.tryParse(
                                                  transaction.amount) ??
                                              0; // Income
                                        }
                                      }
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        Utils.playSound('sounds/in.wav');
                                        Navigator.of(context).push(
                                            // Utils.createRoute(context, _transactions[index]));
                                            Utils.createRoute(
                                                TransactionDetailScreen(
                                          entity: _transactions[index],
                                          onDeletePressed: () {
                                            context.read<TransactionBloc>().add(
                                                DeleteTransaction(
                                                    _transactions[index]));
                                          },
                                        )));
                                      },
                                      child: TransactionListItem(
                                        showDate: showDate,
                                        title: currentTransaction.categoryName,
                                        value: currentTransaction.amount,
                                        imageAsset:
                                            currentTransaction.imageAsset,
                                        date: currentTransaction.date,
                                        time: currentTransaction.time,
                                        isExpense:
                                            (currentTransaction.type == 0),
                                        totalDailyExpenses:
                                            totalDailyExpenses.toString(),
                                        totalDailyIncome:
                                            totalDailyIncome.toString(),
                                      ),
                                    );
                                  },
                                ),
                              ] else ...[
                                TransactionListItem(
                                  showDate: true,
                                  title: '--',
                                  value: '--',
                                  date: '--',
                                  time: '--',
                                  isGrey: true,
                                  isExpense: false,
                                  totalDailyExpenses: '--',
                                  totalDailyIncome: '--',
                                )
                              ],
                            ],
                          ),
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
    );
  }
}
