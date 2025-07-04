import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/domain/repositories/catag_wise_amount_repository.dart';
import 'package:dartz/dartz.dart';

class GetCategoryWiseAmountIncomeUseCase {
  final CatagWiseAmountRepository categoryWiseAmountRepository;

  GetCategoryWiseAmountIncomeUseCase(this.categoryWiseAmountRepository);

  Future<Either<Failure, List<CatagWiseAmountEntity>>> execute(String fromDate, String toDate) async{
    return categoryWiseAmountRepository.getCatagWiseAmounts(Constants.TYPE_INCOME, fromDate, toDate);
  }
}