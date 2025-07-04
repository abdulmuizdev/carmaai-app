import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';

abstract class MonthWiseFinancialsState {
  const MonthWiseFinancialsState();
}

class InitialMonthWiseFinancial extends MonthWiseFinancialsState {
  const InitialMonthWiseFinancial();
}

class FetchingMonthWiseFinancial extends MonthWiseFinancialsState {
  const FetchingMonthWiseFinancial();
}

class FetchedMonthWiseFinancial extends MonthWiseFinancialsState {
  final List<MonthWiseFinancialEntity> result;

  const FetchedMonthWiseFinancial({
    required this.result,
  });
}

class MonthWiseFinancialError extends MonthWiseFinancialsState {
  final String message;
  const MonthWiseFinancialError(this.message);
}

class FetchingLifeTimeFinancials extends MonthWiseFinancialsState {
  const FetchingLifeTimeFinancials();
}

class FetchedLifeTimeFinancials extends MonthWiseFinancialsState {
  final List<LifetimeFinancialsEntity> result;
  const FetchedLifeTimeFinancials(this.result);
}

class LifeTimeFinancialsError extends MonthWiseFinancialsState {
  final String message;
  const LifeTimeFinancialsError(this.message);
}
