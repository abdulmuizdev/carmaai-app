import 'dart:io';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/odometer/domain/entities/odometer_reading_entity.dart';
import 'package:dartz/dartz.dart';

abstract class OdometerRepository {
  Future<Either<Failure, String>> updateOdometer(String reading, String date, String notes);
  Future<Either<Failure, List<OdometerReadingEntity>>> getOdometerReading();
  Future<Either<Failure, String>> analyzeOdometerWithAI(File file);
}