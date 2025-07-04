import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';

abstract class TransactionState {
  const TransactionState();
}

class InitialTransactionState extends TransactionState {
  const InitialTransactionState();
}

class FetchingTransactions extends TransactionState {
  const FetchingTransactions();
}

class FetchTransactionsError extends TransactionState {
  final String message;

  const FetchTransactionsError(this.message);
}

class FetchedTransactions extends TransactionState {
  final List<TransactionEntity> result;
  final String totalIncome;
  final String totalExpenses;
  final String netBalance;

  const FetchedTransactions({
    required this.result,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
  });
}

class SavingTransaction extends TransactionState {
  const SavingTransaction();
}

class SaveTransactionError extends TransactionState {
  final String message;

  const SaveTransactionError(this.message);
}

class SavedTransaction extends TransactionState {
  const SavedTransaction();
}

class UpdateData extends TransactionState {
  const UpdateData();
}

class DeletingTransaction extends TransactionState {
  const DeletingTransaction();
}

class DeleteTransactionError extends TransactionState {
  final String message;

  const DeleteTransactionError(this.message);
}

class DeletedTransaction extends TransactionState {
  final String successMessage;

  const DeletedTransaction(this.successMessage);
}
