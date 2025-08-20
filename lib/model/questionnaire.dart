
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