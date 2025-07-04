import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class FetchTransactions extends TransactionEvent{
  const FetchTransactions();
}

class SaveTransaction extends TransactionEvent {
  TransactionEntity entity;
  SaveTransaction(this.entity);
}

class DeleteTransaction extends TransactionEvent {
  TransactionEntity entity;
  DeleteTransaction(this.entity);
}

class UpdateDataEvent extends TransactionEvent {
  const UpdateDataEvent();
}