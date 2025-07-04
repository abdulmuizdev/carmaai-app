import 'package:carma/features/charts/domain/use_cases/get_lifetime_financials_use_case.dart';
import 'package:carma/features/charts/domain/use_cases/get_month_wise_financials_use_case.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthWiseFinancialsBloc extends Bloc<MonthWiseFinancialsEvent, MonthWiseFinancialsState> {
  final GetMonthWiseFinancialsUseCase _getMonthWiseFinancialsUseCase;
  final GetLifetimeFinancialsUseCase _getLifetimeFinancialsUseCase;

  MonthWiseFinancialsBloc(this._getMonthWiseFinancialsUseCase, this._getLifetimeFinancialsUseCase)
      : super(const InitialMonthWiseFinancial()) {
    on<FetchMonthWiseFinancials>((event, emit) async {
      emit(const FetchingMonthWiseFinancial());

      final result = await _getMonthWiseFinancialsUseCase.execute();

      result.fold((left) {
        emit(MonthWiseFinancialError(left.message));
      }, (right) {
        emit(FetchedMonthWiseFinancial(result: right));
      });
    });

    on<FetchLifeTimeFinancials>((event, emit) async {
      emit(const FetchingLifeTimeFinancials());

      final result = await _getLifetimeFinancialsUseCase.execute();

      result.fold((left) {
        emit(LifeTimeFinancialsError(left.message));
      }, (right) {
        emit(FetchedLifeTimeFinancials(right));
      });
    });
  }
}
