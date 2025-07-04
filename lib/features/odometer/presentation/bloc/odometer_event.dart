import 'dart:io';

abstract class OdometerEvent {
  const OdometerEvent();
}

class GetOdometerReading extends OdometerEvent {
  const GetOdometerReading();
}

class UpdateOdometerReading extends OdometerEvent {
  final String reading;
  final String notes;
  const UpdateOdometerReading(this.reading, this.notes);
}

class UpdateAIOdometerReading extends OdometerEvent {
  final String reading;
  final String notes;
  const UpdateAIOdometerReading(this.reading, this.notes);
}

class AnalyzeOdometerWithAI extends OdometerEvent {
  final File file;
  const AnalyzeOdometerWithAI(this.file);
}