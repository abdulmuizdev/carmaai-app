import 'dart:io';

import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/odometer/data/data_sources/odometer_data_source.dart';
import 'package:carma/features/odometer/data/model/odometer_reading_model.dart';
import 'package:carma/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:dartz/dartz.dart';

class OdometerRepositoryImpl extends OdometerRepository {
  final OdometerDataSource odometerDataSource;

  OdometerRepositoryImpl(this.odometerDataSource);

  @override
  Future<Either<Failure, List<OdometerReadingModel>>> getOdometerReading() {
    return odometerDataSource.getOdometerReading();
  }

  @override
  Future<Either<Failure, String>> updateOdometer(String reading, String date, String notes) {
    return odometerDataSource.updateOdometer(reading, date, notes);
  }

  @override
  Future<Either<Failure, String>> analyzeOdometerWithAI(File file) {
    return odometerDataSource.analyzeOdometerWithAI(file);
  }

}