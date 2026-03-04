
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/model/models.dart';
import 'package:selc_uenr/model/student_info.dart';
import 'dart:convert';
import '../components/server_connector.dart' as connector;
import '../components/preferences_util.dart' as pref_util;
import '../model/questionnaire.dart';


/*
    THE JSON FORMAT FOR SUBMITTING THE EVALUATION

    {
      'cc_id': class_course_id,
      'student_id': student_id,
      'questionnaire_answers:[
        'question_id': question_id,
        'answer': answer
      ],
      'suggestion': student_suggestion_string
    }

 */

class SelcProvider extends ChangeNotifier{


  StudentInfo? _studentInfo;
  StudentInfo get studentInfo => _studentInfo!;

  GeneralSettings? _generalSettings;
  GeneralSettings get generalSettings => _generalSettings!;

  List<QuestionCategory> categories = [];

  List<Questionnaire>  get allQuestions{
    if(categories.isEmpty) return [];

    List<Questionnaire> items = [
      for(QuestionCategory category in categories)
          for(Questionnaire question in category.questionnaires) question
    ];

    return items;
  }

  List<RegisteredCourse> courses = [];

  int questionsCount = 0;

  void flushData(){
    _studentInfo = null;
    courses.clear();
    allQuestions.clear();
  }


  @override void dispose(){
    flushData();
    super.dispose();
  }


  //send a request to the backend for login.
  Future<void> login(String username, String password) async {

    dynamic body = jsonEncode({'username': username, 'password': password});

    Response response = await connector.postRequest(endpoint: 'login/', body: body);


    if(response.statusCode == 401 || response.statusCode == 403){
      throw Exception(jsonDecode(response.body)['message']);
    }

    if(response.statusCode != 200){
      throw Error();
    }


    dynamic responseBody = jsonDecode(response.body);

    _studentInfo = StudentInfo.fromMap(responseBody as Map<String, dynamic>);


    //todo: save the auth_token key that came with the response.
    await pref_util.saveAuthorizationToken(responseBody['token']);

    await getGeneralSettings();

    await getQuestions();

    notifyListeners();
  }



  //send a request to the backend for logout.
  Future<void> logout() async {

    final response = await connector.getRequest(endPoint: 'logout/');

    if(response.statusCode != 200){
      throw Error();
    }

    //todo:delete the the user's authentication from the shared preference
    await pref_util.deleteAuthorizationToken();

    //todo: delete the token after that.
    notifyListeners();
  }



  Future<void> getGeneralSettings() async {

    final response = await connector.getRequest(endPoint: 'get-general-settings/');

    if(response.statusCode != 200){
      throw Exception('Error retrieving general settings');
    }

    dynamic responseBody = jsonDecode(response.body);
    _generalSettings = GeneralSettings.fromJson(Map<String, dynamic>.from(responseBody));

    notifyListeners();
  }


  


  Future<void> getRegisteredCourses() async {

    final response = await connector.getRequest(endPoint: 'get-registered-courses/');

    if(response.statusCode != 200){
      throw Error();
    }

    List<dynamic> responseBody = jsonDecode(response.body);

    if(responseBody.isEmpty) return;

    courses = responseBody.map((jsonMap) => RegisteredCourse.fromJson(jsonMap)).toList();

    notifyListeners();

  } 



  int calculateTotalCreditHours(){


    if(courses.isEmpty) return 0;

    int sum = 0;

    for(RegisteredCourse rCourse in courses){
      sum  += rCourse.creditHours;
    }

    return sum;

  }


  String computeEvaluatedCourses(){
    int evaluatedCoursesLength = courses.where((RegisteredCourse course) => course.evaluated).toList().length;
    return '$evaluatedCoursesLength of ${courses.length}';
  }


  Future<void> getQuestions() async {
    final response = await connector.getRequest(endPoint: 'get-question-categories/');

    if(response.statusCode != 200) throw Error();

    List<dynamic> responseBody = jsonDecode(response.body);

    categories = responseBody.map(
            (jsonMap) => QuestionCategory.fromJson(jsonMap)).toList();

    notifyListeners();

  }



  Future<void> submitQuestionnaire(int classCourseId, dynamic answers, int rating, suggestion) async {

    Map<String, dynamic> requestBodyMap = {
      'cc_id': classCourseId,
      'answers': answers,
      'rating': rating,
      'suggestion': suggestion
    };

    dynamic requestBodyJson = jsonEncode(requestBodyMap);


    final response = await connector.postRequest(endpoint: 'submit-eval/', body: requestBodyJson);


    if(response.statusCode == 403){
      throw Exception(jsonDecode(response.body)['message']);
    }

    if(response.statusCode != 200){
      throw Error();
    }

    setCourseStatusEvaluated(classCourseId);
    notifyListeners();
  }


  void setCourseStatusEvaluated(int classCourseId){
    for(int i = 0; i < courses.length; i++){
      if(courses[i].classCourseId == classCourseId){
        courses[i].evaluated = true;
        break;
      }
    }
  }


  Future<Map<String, dynamic>> getEvaluationForCourse(int classCourseId) async {

    Response response = await connector.getRequest(endPoint: 'get-course-eval/$classCourseId');

    if(response.statusCode != 200) throw Exception('Could not retrieve data.');

    /*
      {
        eval_answers: [
            {
              cat_name: category_name,
              answers: [
                {
                  question: 'question',
                  answer: 'answer'
                },
              ],
            },
        ],
        suggestion: 'suggestion'
      }
    */

    String responseBody = response.body;

    return jsonDecode(responseBody);
  }

}


