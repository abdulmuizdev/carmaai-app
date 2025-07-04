import 'dart:ui';

import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/charts/data/models/catag_wise_amount_model.dart';
import 'package:carma/features/charts/data/models/month_wise_financials_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class CatagWiseAmountDataSource {
  Future<Either<Failure, List<CatagWiseAmountModel>>> getCategoryWiseAmounts(int type, String fromDate, String toDate);
}

class CatagWiseAmountDataSourceImpl extends CatagWiseAmountDataSource {
  final DbHelper dbHelper;

  CatagWiseAmountDataSourceImpl(this.dbHelper);

  @override
  Future<Either<Failure, List<CatagWiseAmountModel>>> getCategoryWiseAmounts(
      int type, String fromDate, String toDate) async {
    print('I have $fromDate and $toDate');
    try {
      final rawCatagAmounts = await dbHelper.getCategoryWiseAmounts(type, fromDate, toDate);
      print(rawCatagAmounts);
      final List<CatagWiseAmountModel> catagAmounts = [];
      // print('begin chart check');
      for (var raw in rawCatagAmounts) {
        // print('here cute girl');
        // print(raw['image_asset']);
        catagAmounts.add(CatagWiseAmountModel(
          category: raw['name'],
          imageAsset: raw['image_asset'],
          amount: raw['total_amount'].toString(),
          color: Color(int.tryParse(raw['color']) ?? 0xFF),
        ));
      }
      print(catagAmounts);
      return Right(catagAmounts);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('Unable to load chart'));
    }
  }
}
