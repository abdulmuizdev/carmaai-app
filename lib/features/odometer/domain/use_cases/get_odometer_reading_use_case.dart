import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/odometer/domain/entities/odometer_reading_entity.dart';
import 'package:carma/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:dartz/dartz.dart';

class GetOdometerReadingUseCase {
  final OdometerRepository odometerRepository;
  GetOdometerReadingUseCase(this.odometerRepository);

  Future<Either<Failure, List<OdometerReadingEntity>>> execute(){
    return odometerRepository.getOdometerReading();
  }
}