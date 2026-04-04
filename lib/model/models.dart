

class StudentInfo{

  String? fullName;
  //String? indexNumber;
  String? referenceNumber;
  String? studentName;
  String? program;
  String? department;
  String? campus;
  String? status;
  int? age;
  String? year; //the academic year.


  StudentInfo({
    this.fullName,
    //this.indexNumber,
    this.referenceNumber,
    this.studentName,
    this.department,
    this.program,
    this.campus,
    this.status,
    this.age,
    this.year,
  });

  factory StudentInfo.fromMap(Map<String, dynamic> studentMap){
    return StudentInfo(
        fullName: studentMap['full_name'],
        //indexNumber: studentMap['indexNumber'],
        referenceNumber: studentMap['reference_number'],
        studentName: studentMap['student_name'],
        department: studentMap['department'],
        program: studentMap['program'],
        campus: studentMap['campus'],
        status: studentMap['status'],
        age: studentMap['age'] ?? 0,
        year: studentMap['age'].toString()
    );
  }
}




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
      academicYear: jsonMap['academic_year'],
      isAcceptingEvaluation: jsonMap['enable_evaluations'] ?? false
    );
  }
}



class RegisteredCourse{

  int? classCourseId;
  String courseCode;
  String courseTitle;
  String lecturer;
  String department;
  int creditHours;
  bool evaluated;
  bool isAcceptingResponse;

  RegisteredCourse({
    required this.courseCode,
    required this.courseTitle,
    required this.lecturer,
    required this.creditHours,
    this.classCourseId,
    this.evaluated = false,
    required this.isAcceptingResponse,
    this.department=''
  });


  factory RegisteredCourse.fromJson(Map<String, dynamic> jsonMap){
    return RegisteredCourse(
        courseCode: jsonMap['course_code'],
        courseTitle: jsonMap['course_title'],
        lecturer: jsonMap['lecturer'],
        creditHours: jsonMap['credit_hours'],
        department: jsonMap['department'],
        classCourseId: jsonMap['cc_id'],
        evaluated:  jsonMap['evaluated'],
        isAcceptingResponse: jsonMap['is_accepting_response']
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



// ignore_for_file: constant_identifier_names

class Questionnaire{
  final int questionId;
  final String question;
  final PossibleAnswers possibleAnswers;

  Questionnaire({required this.questionId, required this.question, required this.possibleAnswers});

  factory Questionnaire.fromJson(Map<String, dynamic> jsonMap){
    return Questionnaire(
        questionId: jsonMap['id'],
        question: jsonMap['question'],
        possibleAnswers: PossibleAnswers.fromString(jsonMap['answer_type'])
    );
  }

}


enum PossibleAnswers{

  yes_no('yes_no', ["Yes", "No"]),
  performance('performance', ["Excellent", "Very Good", "Good", "Average", "Poor"]),
  time('time', ["Very Often", "Often", "Sometimes", "Rarely", "Never"]);

  final String answerTypeString;
  final List<String> answers;
  const PossibleAnswers(this.answerTypeString, this.answers);


  factory PossibleAnswers.fromString(String answerTypeString){

    for(PossibleAnswers answer in PossibleAnswers.values){
      if(answer.answerTypeString == answerTypeString) return answer;
    }

    return PossibleAnswers.yes_no;
  }

  @override String toString() => answerTypeString;
}