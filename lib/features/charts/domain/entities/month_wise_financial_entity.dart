import 'dart:ui';

import 'package:carma/features/charts/data/models/month_wise_financials_model.dart';

class MonthWiseFinancialEntity {
  final String year;
  final String month;
  final String totalExpenses;
  final String totalIncome;
  final String balance;

  const MonthWiseFinancialEntity({
    required this.year,
    required this.month,
    required this.totalExpenses,
    required this.totalIncome,
    required this.balance,
  });
}
