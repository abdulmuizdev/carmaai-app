import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/data/data_sources/Catag_wise_amount_data_source.dart';
import 'package:carma/features/charts/data/data_sources/month_wise_financials_data_source.dart';
import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:carma/features/charts/domain/repositories/catag_wise_amount_repository.dart';
import 'package:dartz/dartz.dart';

class CatagWiseAmountRepositoryImpl extends CatagWiseAmountRepository {
  final CatagWiseAmountDataSource catagWiseAmountDataSource;
  CatagWiseAmountRepositoryImpl(this.catagWiseAmountDataSource);

  @override
  Future<Either<Failure, List<CatagWiseAmountEntity>>> getCatagWiseAmounts(int type, String fromDate, String toDate) {
    return catagWiseAmountDataSource.getCategoryWiseAmounts(type, fromDate, toDate);
  }

}