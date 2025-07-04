import 'package:carma/features/odometer/domain/entities/odometer_reading_entity.dart';

class OdometerReadingModel extends OdometerReadingEntity {
  final String reading;
  final String notes;
  final String date;

  OdometerReadingModel({required this.reading, required this.date, required this.notes})
      : super(reading: reading, date: date, notes: notes);

  factory OdometerReadingModel.fromJson(Map<String, dynamic> raw) {
    return OdometerReadingModel(
      reading: raw['reading'],
      notes: raw['notes'],
      date: raw['date'],
    );
  }
}
