import 'dart:io';

import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:dartz/dartz.dart';

class AnalyzeOdometerWithAiUseCase {
  final OdometerRepository odometerRepository;

  AnalyzeOdometerWithAiUseCase(this.odometerRepository);

  Future<Either<Failure, String>> execute(File file) {
    return odometerRepository.analyzeOdometerWithAI(file);
  }
}