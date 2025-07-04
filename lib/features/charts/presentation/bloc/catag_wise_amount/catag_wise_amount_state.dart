import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';

abstract class CatagWiseAmountState {
  const CatagWiseAmountState();
}

class InitialCatagWiseAmount extends CatagWiseAmountState {
  const InitialCatagWiseAmount();
}

class FetchingCatagWiseAmount extends CatagWiseAmountState {
  const FetchingCatagWiseAmount();
}

class FetchedCatagWiseAmount extends CatagWiseAmountState {
  final List<CatagWiseAmountEntity> expenses;
  final String totalExpenses;

  final List<CatagWiseAmountEntity> income;
  final String totalIncome;

  const FetchedCatagWiseAmount({
    required this.expenses,
    required this.totalExpenses,
    required this.income,
    required this.totalIncome,
  });
}

class CatagWiseAmountError extends CatagWiseAmountState {
  final String message;

  const CatagWiseAmountError(this.message);
}
