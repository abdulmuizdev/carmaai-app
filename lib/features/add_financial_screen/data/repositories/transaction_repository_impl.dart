import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/data/data_sources/transaction_data_source.dart';
import 'package:carma/features/add_financial_screen/data/models/current_month_financial_model.dart';
import 'package:carma/features/add_financial_screen/data/models/transaction_model.dart';
import 'package:carma/features/add_financial_screen/domain/entities/current_month_financial_entity.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final TransactionDataSource transactionDataSource;
  TransactionRepositoryImpl(this.transactionDataSource);

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions() {
    return transactionDataSource.getTransactions();
  }

  @override
  Future<Either<Failure, void>> saveTransaction(TransactionEntity entity) {
    return transactionDataSource.saveTransaction(TransactionModel.fromEntity(entity));
  }

  @override
  Future<Either<Failure, bool>> deleteTransaction(TransactionEntity entity) {
    return transactionDataSource.deleteTransaction(TransactionModel.fromEntity(entity));
  }

  @override
  Future<Either<Failure, CurrentMonthFinancialModel>> getCurrentMonthFinancials() {
    return transactionDataSource.getCurrentMonthFinancials();
  }

}