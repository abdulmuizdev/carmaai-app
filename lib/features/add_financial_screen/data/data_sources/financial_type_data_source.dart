import 'package:carma/common/data/models/financial_type_model.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class FinancialTypeDataSource {
  Future<Either<Failure, List<FinancialTypeModel>>> getExpenseTypes();
  Future<Either<Failure, List<FinancialTypeModel>>> getIncomeTypes();
}

class FinancialTypeDataSourceImpl extends FinancialTypeDataSource {
  final DbHelper dbHelper;

  FinancialTypeDataSourceImpl(this.dbHelper);

  @override
  Future<Either<Failure, List<FinancialTypeModel>>> getExpenseTypes() async {
    final result = await dbHelper.getCategoriesByType(Constants.TYPE_EXPENSE);
    if (result.isEmpty){
      return const Left(GeneralFailure('An error has occurred'));
    }
    List<FinancialTypeModel> list = result.map((raw) => FinancialTypeModel.fromJson(raw)).toList();
    return Right(list);
  }

  @override
  Future<Either<Failure, List<FinancialTypeModel>>> getIncomeTypes() async {
    final result = await dbHelper.getCategoriesByType(Constants.TYPE_INCOME);
    if (result.isEmpty){
      return const Left(GeneralFailure('An error has occurred'));
    }
    List<FinancialTypeModel> list = result.map((raw) => FinancialTypeModel.fromJson(raw)).toList();
    return Right(list);
  }
}
