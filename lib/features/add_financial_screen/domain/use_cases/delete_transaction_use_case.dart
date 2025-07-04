import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/data/models/transaction_model.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteTransactionUseCase {
  final TransactionRepository transactionRepository;
  const DeleteTransactionUseCase(this.transactionRepository);

  Future<Either<Failure, bool>> execute(TransactionEntity entity) async{
    return transactionRepository.deleteTransaction(entity);
  }
}