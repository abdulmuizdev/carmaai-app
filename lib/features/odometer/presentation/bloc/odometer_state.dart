import 'package:carma/features/odometer/domain/entities/odometer_reading_entity.dart';

abstract class OdometerState {
  const OdometerState();
}

class Initial extends OdometerState {
  const Initial();
}

class UpdatingOdometerReading extends OdometerState {
  const UpdatingOdometerReading();
}

class UpdatedOdometerReading extends OdometerState {
  final List<OdometerReadingEntity> pastReadings;
  final String updatedReading;
  final String notes;
  const UpdatedOdometerReading({required this.updatedReading, required this.pastReadings, required this.notes});
}

class UpdatingAIOdometerReading extends OdometerState {
  const UpdatingAIOdometerReading();
}

class UpdatedAIOdometerReading extends OdometerState {
  final List<OdometerReadingEntity> pastReadings;
  final String updatedReading;
  final String notes;
  const UpdatedAIOdometerReading({required this.updatedReading, required this.pastReadings, required this.notes});
}

class OdometerReadingError extends OdometerState {
  final String message;
  const OdometerReadingError(this.message);
}

class GotOdometerReading extends OdometerState {
  final List<OdometerReadingEntity> pastReadings;
  final String latestReading;
  final String notes;
  const GotOdometerReading({required this.pastReadings, required this.latestReading, required this.notes});
}

class AnalyzingOdometerWithAI extends OdometerState {
  const AnalyzingOdometerWithAI();
}

class AnalyzedOdometerWithAI extends OdometerState {
  final String odometerReading;
  const AnalyzedOdometerWithAI(this.odometerReading);
}

class AnalyzeOdometerWithAIError extends OdometerState {
  final String message;
  const AnalyzeOdometerWithAIError(this.message);
}


