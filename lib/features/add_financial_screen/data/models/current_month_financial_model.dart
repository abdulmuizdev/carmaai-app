import 'package:carma/features/add_financial_screen/domain/entities/current_month_financial_entity.dart';

class CurrentMonthFinancialModel extends CurrentMonthFinancialEntity {
  final String totalExpenses;
  final String totalIncome;
  final String netBalance;
  final String currentMonth;

  const CurrentMonthFinancialModel(
      {required this.totalExpenses,
      required this.totalIncome,
      required this.netBalance,
      required this.currentMonth})
      : super(
          totalExpenses: totalExpenses,
          totalIncome: totalIncome,
          netBalance: netBalance,
          currentMonth: currentMonth,
        );
}
