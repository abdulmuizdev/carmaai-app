import 'dart:math';

import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/domain/use_cases/get_categ_wise_amount_expense_use_case.dart';
import 'package:carma/features/charts/domain/use_cases/get_categ_wise_amount_income_use_case.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_event.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWiseAmountBloc
    extends Bloc<CatagWiseAmountEvent, CatagWiseAmountState> {
  final GetCategoryWiseAmountExpenseUseCase
      _getCategoryWiseAmountExpenseUseCase;
  final GetCategoryWiseAmountIncomeUseCase _getCategoryWiseAmountIncomeUseCase;

  CategoryWiseAmountBloc(this._getCategoryWiseAmountExpenseUseCase,
      this._getCategoryWiseAmountIncomeUseCase)
      : super(const InitialCatagWiseAmount()) {
    on<FetchCatagWiseAmount>((event, emit) async {
      emit(const FetchingCatagWiseAmount());

      final expenseResults =
          await _getCategoryWiseAmountExpenseUseCase.execute(event.fromDate, event.toDate);
      final incomeResults = await _getCategoryWiseAmountIncomeUseCase.execute(event.fromDate, event.toDate);

      String totalExpenses = '';
      String totalIncome = '';

      List<CatagWiseAmountEntity> expenses = [];
      List<CatagWiseAmountEntity> income = [];

      expenseResults.fold((left) {
        emit(CatagWiseAmountError(left.message));
      }, (right) {
        totalExpenses = _calculateTotalAmount(right);
        expenses = _calculateWeightage(right, totalExpenses);

      });

      incomeResults.fold((left) {
        emit(CatagWiseAmountError(left.message));
      }, (right) {
        totalIncome = _calculateTotalAmount(right);
        income = _calculateWeightage(right, totalIncome);
      });

      emit(FetchedCatagWiseAmount(
        expenses: expenses,
        totalExpenses: totalExpenses,
        income: income,
        totalIncome: totalIncome,
      ));
    });
  }

  List<CatagWiseAmountEntity> _calculateWeightage(List<CatagWiseAmountEntity> list, String totalAmount){
    return list.map((item) {
      final double amount = double.tryParse(item.amount) ?? 0.0;
      final double weightage = (double.tryParse(totalAmount) ?? 0) == 0 ? 0 : amount / (double.tryParse(totalAmount) ?? 0);

      // Return a new entity with the calculated weightage
      return item.copyWith(weightage: weightage);
    }).toList();
  }

  String _calculateTotalAmount(List<CatagWiseAmountEntity> list) {
    String totalAmount = '--';
    int sum = 0;
    for (int i = 0; i < list.length; i++) {
      sum += int.parse(list[i].amount) ?? 0;
    }
    ;
    totalAmount = sum.toString();

    return totalAmount;
  }
}
