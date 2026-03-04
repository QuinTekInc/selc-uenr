
import 'package:selc_uenr/model/questionnaire.dart';

class GeneralSettings{

  int currentSemester;
  String academicYear;
  bool isAcceptingEvaluation;

  GeneralSettings({
    required this.currentSemester,
    required this.academicYear,
    required this.isAcceptingEvaluation
  });


  factory GeneralSettings.fromJson(Map<String, dynamic> jsonMap){
    return GeneralSettings(
      currentSemester: jsonMap['current_semester'],
      academicYear: jsonMap['academic_year'].toString(),
      isAcceptingEvaluation: jsonMap['enable_evaluations'] ?? false
    );
  }
}



class QuestionCategory{
  int categoryId;
  String categoryName;
  List<Questionnaire> questionnaires;

  QuestionCategory({
    required this.categoryId,
    required this.categoryName,
    required this.questionnaires
  });


  factory QuestionCategory.fromJson(Map<String, dynamic> jsonMap){
    return QuestionCategory(
      categoryId: jsonMap['category_id'],
      categoryName: jsonMap['category_name'],
      questionnaires: List<dynamic>.from(jsonMap['questionnaires'])
          .map((jsonMap) => Questionnaire.fromJson(jsonMap)).toList()
    );
  }
}