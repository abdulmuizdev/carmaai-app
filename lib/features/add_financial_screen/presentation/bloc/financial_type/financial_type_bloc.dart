import 'package:carma/features/add_financial_screen/domain/use_cases/get_expense_types_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_income_types_use_case.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/financial_type/financial_type_event.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/financial_type/financial_type_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialTypeBloc extends Bloc<FinancialTypeEvent, FinancialTypeState> {
  final GetIncomeTypesUseCase _getIncomeTypesUseCase;
  final GetExpenseTypesUseCase _getExpenseTypesUseCase;

  FinancialTypeBloc(this._getIncomeTypesUseCase, this._getExpenseTypesUseCase) : super(const FinancialTypeInitial()) {
    on<FetchIncomeTypes>((event, emit) async {
      final result = await _getIncomeTypesUseCase.execute();
      result.fold((left){
        emit(FetchIncomeTypesError(left.message));
      }, (right){
        emit(FetchedIncomeTypes(right));
      });
    });

    on<FetchExpenseTypes>((event, emit) async {
      final result = await _getExpenseTypesUseCase.execute();
      result.fold((left){
        emit(FetchExpenseTypesError(left.message));
      }, (right){
        emit(FetchedExpenseTypes(right));
      });
    });
  }

}