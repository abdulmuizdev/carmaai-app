import 'package:carma/core/errors/failure.dart';
import 'package:carma/features/onboarding/presentation/pages/survey/data/models/survey_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class SurveyDataSource {
  Future<Either<Failure, SurveyModel>> getSurveyData();
}