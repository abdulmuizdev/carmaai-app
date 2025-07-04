import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/data/models/transaction_model.dart';
import 'package:carma/features/add_financial_screen/domain/entities/current_month_financial_entity.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions();
  Future<Either<Failure, void>> saveTransaction(TransactionEntity entity);
  Future<Either<Failure, bool>> deleteTransaction(TransactionEntity entity);
  Future<Either<Failure, CurrentMonthFinancialEntity>> getCurrentMonthFinancials();
}