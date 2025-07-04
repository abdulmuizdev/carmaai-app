import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/add_financial_screen/data/models/transaction_model.dart';
import 'package:carma/features/add_financial_screen/domain/entities/current_month_financial_entity.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentMonthFinancialsUseCase {
  final TransactionRepository transactionRepository;
  const GetCurrentMonthFinancialsUseCase(this.transactionRepository);

  Future<Either<Failure, CurrentMonthFinancialEntity>> execute() async{
    return transactionRepository.getCurrentMonthFinancials();
  }
}