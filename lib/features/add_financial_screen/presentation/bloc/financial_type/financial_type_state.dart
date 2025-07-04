import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';

abstract class FinancialTypeState{
  const FinancialTypeState();
}

class FinancialTypeInitial extends FinancialTypeState {
  const FinancialTypeInitial();
}

class FetchIncomeTypesError extends FinancialTypeState {
  final String message;
  const FetchIncomeTypesError(this.message);
}

class FetchedIncomeTypes extends FinancialTypeState {
  final List<FinancialTypeEntity> result;
  const FetchedIncomeTypes(this.result);
}

class FetchExpenseTypesError extends FinancialTypeState {
  final String message;
  const FetchExpenseTypesError(this.message);
}

class FetchedExpenseTypes extends FinancialTypeState {
  final List<FinancialTypeEntity> result;
  const FetchedExpenseTypes(this.result);
}

class IncomeTypesError extends FinancialTypeState {
  final String message;
  const IncomeTypesError(this.message);
}

class ExpenseTypesError extends FinancialTypeState {
  final String message;
  const ExpenseTypesError(this.message);
}