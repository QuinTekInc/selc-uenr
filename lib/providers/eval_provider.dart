
import 'package:flutter/material.dart';


class EvalProvider with ChangeNotifier{

  List<int> selectedIndices = []; //List of index of the selected checkbox in the questionnaire cell.
  List<dynamic> questionnaireIds; //ids of the questionnaires
  List<String> questionnaireAnswers = []; //List of Actual selected answers corresponding to a Questionnaire Answer Type in a questionnaire

  int rating = 0;
  String suggestion = '';

  EvalProvider(this.questionnaireIds){
    questionnaireAnswers = List.generate(questionnaireIds.length, (_) => 'No Answer');
    selectedIndices = List.generate(questionnaireIds.length, (_) => -1);
  }

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();

    selectedIndices.clear();
    questionnaireAnswers.clear();
    questionnaireIds.clear();
  }


  void updateAnswer(int index, int selectedIndex, String answer){
    selectedIndices[index] = selectedIndex;
    questionnaireAnswers[index] = answer;
    notifyListeners();
  }

  void updateRating(int newRating){
    rating  = newRating;
    notifyListeners();
  }


  void updateSuggestion(String newSuggestion){
    suggestion = newSuggestion;
    notifyListeners();
  }


  Map<String, dynamic> get submissionMap => {
    'answers': List<Map<String, dynamic>>.generate(
      questionnaireIds.length,
      (int index) => {
        'question_id': questionnaireIds[index],
        'answer': questionnaireAnswers[index]
      }
    ),
    'rating': rating,
    'suggestion': suggestion
  };
}