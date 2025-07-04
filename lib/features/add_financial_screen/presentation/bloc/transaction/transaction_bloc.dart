import 'package:carma/features/add_financial_screen/domain/use_cases/delete_transaction_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_current_month_financials_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_transactions_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/save_transaction_use_case.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_event.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase _getTransactionUseCase;
  final SaveTransactionUseCase _saveTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final GetCurrentMonthFinancialsUseCase _getCurrentMonthFinancialsUseCase;

  TransactionBloc(
    this._getTransactionUseCase,
    this._saveTransactionUseCase,
    this._deleteTransactionUseCase,
    this._getCurrentMonthFinancialsUseCase,
  ) : super(const InitialTransactionState()) {
    on<FetchTransactions>((event, emit) async {
      await _fetchTransactions(emit);
    });

    on<SaveTransaction>((event, emit) async {
      emit(const SavingTransaction());

      final result = await _saveTransactionUseCase.execute(event.entity);
      result.fold((left) {
        emit(SaveTransactionError(left.message));
      }, (right) {
        emit(const SavedTransaction());
      });
    });

    on<DeleteTransaction>((event, emit) async {
      emit(const DeletingTransaction());

      final result = await _deleteTransactionUseCase.execute(event.entity);
      await result.fold((left) {
        emit(DeleteTransactionError(left.message));
      }, (right) async {
        emit(const DeletedTransaction('Transaction deleted successfully'));
        await _fetchTransactions(emit);
      });
    });

    on<UpdateDataEvent>((event, emit) {
      emit(const UpdateData());
    });
  }

  Future<void> _fetchTransactions(emit) async {
    emit(const FetchingTransactions());

    final result = await _getTransactionUseCase.execute();
    await result.fold((left) {
      emit(FetchTransactionsError(left.message));
    }, (right) async {
      print('fetched transactions');

      final result2 = await _getCurrentMonthFinancialsUseCase.execute();

      String totalIncome = '--';
      String totalExpenses = '--';
      String netBalance = '--';

      result2.fold((left){
        emit(FetchTransactionsError(left.message));
      }, (right){
        totalIncome = right.totalIncome;
        totalExpenses = right.totalExpenses;
        netBalance = right.netBalance;
      });

      emit(
        FetchedTransactions(
          result: right,
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          netBalance: netBalance,
        ),
      );
    });
  }
}
