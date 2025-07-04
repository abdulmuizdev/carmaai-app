import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateOdometerReadingUseCase {
  final OdometerRepository odometerRepository;
  UpdateOdometerReadingUseCase(this.odometerRepository);

  Future<Either<Failure, String>> execute(String reading, String date, String notes){
    return odometerRepository.updateOdometer(reading, date, notes);
  }
}