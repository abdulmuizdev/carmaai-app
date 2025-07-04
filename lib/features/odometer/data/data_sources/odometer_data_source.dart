import 'dart:io';

import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/constants/secrets.dart';
import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/odometer/data/model/odometer_reading_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

abstract class OdometerDataSource {
  Future<Either<Failure, String>> updateOdometer(String reading, String date, String notes);

  Future<Either<Failure, List<OdometerReadingModel>>> getOdometerReading();

  Future<Either<Failure, String>> analyzeOdometerWithAI(File file);
}

class OdometerDataSourceImpl extends OdometerDataSource {
  final DbHelper dbHelper;
  final http.Client client;

  OdometerDataSourceImpl(this.dbHelper, this.client);

  @override
  Future<Either<Failure, List<OdometerReadingModel>>>
      getOdometerReading() async {
    try {
      final result = await dbHelper.getOdometerReadings();

      List<OdometerReadingModel> readings =
          result.map((raw) => OdometerReadingModel.fromJson(raw)).toList();

      return Right(readings);
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('An error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> updateOdometer(
      String reading, String date, String notes) async {
    try {
      final result =
          await dbHelper.insertOdometerReading(reading: reading, date: date, notes: notes);
      if (result > 0) {
        return Right(reading);
      } else {
        return const Left(GeneralFailure('Something went wrong'));
      }
    } catch (e) {
      print(e);
      return const Left(GeneralFailure('An error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> analyzeOdometerWithAI(File file) async {
    try {
      // Automatically get the MIME type from the file extension
      final mimeType = lookupMimeType(file.path);

      // If mimeType is null, default to 'application/octet-stream'
      final contentType = mimeType != null
          ? MediaType.parse(mimeType)
          : MediaType('application', 'octet-stream');

      var uri = Uri.parse('${Secrets.baseUrl}/readOdometerImage');

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          file.path,
          contentType: contentType,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('File uploaded successfully: $responseBody');

        return Right(responseBody);
      } else {
        print('Failed to upload file: ${response.statusCode}');
        return Left(GeneralFailure('Unable to scan odometer'));
      }
    } catch (e) {
      print('Exception: $e');
      return Left(GeneralFailure('Unable to scan odometer'));
    }
  }
}
