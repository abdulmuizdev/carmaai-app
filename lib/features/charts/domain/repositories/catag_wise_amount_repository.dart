import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CatagWiseAmountRepository {
  Future<Either<Failure, List<CatagWiseAmountEntity>>> getCatagWiseAmounts(int type, String fromDate, String toDate);
}