import 'package:carma/features/onboarding/presentation/pages/survey/domain/entities/survey_entity.dart';

class SurveyModel extends SurveyEntity {
  final String question;
  final List<String> answers;
  SurveyModel({required this.question, required this.answers}) :
      super (question: question, answers: answers);
}