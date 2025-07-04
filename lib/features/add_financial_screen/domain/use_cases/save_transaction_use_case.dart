import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/data/models/transaction_model.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class SaveTransactionUseCase {
  final TransactionRepository transactionRepository;
  const SaveTransactionUseCase(this.transactionRepository);

  Future<Either<Failure, void>> execute(TransactionEntity entity) async{
    return transactionRepository.saveTransaction(entity);
  }
}