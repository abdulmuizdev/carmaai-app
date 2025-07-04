import 'dart:ui';

import 'package:carma/features/charts/data/data_sources/month_wise_financials_data_source.dart';
import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';

class MonthWiseFinancialModel extends MonthWiseFinancialEntity {
  final String year;
  final String month;
  final String totalExpenses;
  final String totalIncome;
  final String balance;

  const MonthWiseFinancialModel({
    required this.year,
    required this.month,
    required this.totalExpenses,
    required this.totalIncome,
    required this.balance,
  }) : super(
          year: year,
          month: month,
          totalExpenses: totalExpenses,
          totalIncome: totalIncome,
          balance: balance,
        );

// factory CatagWiseAmountModel.fromJson(Map<String, dynamic> raw) {
//   return CatagWiseAmountModel(
//     category: raw['category'],
//     amount: raw['amount'],
//     color: raw['color'],
//   );
// }
}
