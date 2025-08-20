
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/model/questionnaire.dart';
import 'package:selc_uenr/pages/verify_answers.dart';
import 'package:selc_uenr/providers/selc_provider.dart';
import 'package:selc_uenr/components/cells.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/model/course_info.dart';



class WebEvaluationPage extends StatefulWidget {

  final RegisteredCourse course;

  const WebEvaluationPage({super.key, required this.course});

  @override
  State<WebEvaluationPage> createState() => _WebEvaluationPageState();
}

class _WebEvaluationPageState extends State<WebEvaluationPage> {


  final ratingsController = RatingsController();
  final suggestionController = TextEditingController();


  List<Questionnaire> allQuestions = [];
  List<QuestionCellController> cellControllers = [];

  @override
  void initState() {
    super.initState();


    allQuestions = Provider.of<SelcProvider>(context, listen: false).allQuestions;

    
    //todo: initialize the cell controllers.
    cellControllers = List<QuestionCellController>.generate(  
      allQuestions.length,
      (int index) => QuestionCellController()
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: Colors.grey.shade200,

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                HeaderText(
                  'Evaluation for ${widget.course.courseTitle}[${widget.course.courseCode}]',
                  textColor: Colors.green.shade400
                ),
                Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(CupertinoIcons.xmark, color: Colors.red.shade400,))
              ],
            ),

            const SizedBox(height: 12,),


            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  
                  CourseDetailSection(course: widget.course),


                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView( 

                        child: FractionallySizedBox(
                          widthFactor: 0.7,


                          child: Column(   
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: List<Widget>.generate(  
                              Provider.of<SelcProvider>(context).questionnairesMap.length,
                              (int index) {

                                //get the category name at the current iteration
                                String categoryName = Provider.of<SelcProvider>(context, listen: false).questionnairesMap.keys.toList()[index];

                                List<Questionnaire> questions = Provider.of<SelcProvider>(context, listen: false).questionnairesMap[categoryName]!;

                                return Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Column(  
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                  
                                    children: [
                                  
                                      CustomText(  
                                        categoryName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),

                                  
                                      for(Questionnaire question in questions) Padding(  
                                        padding: EdgeInsets.only(top: 8),
                                        child: QuestionCell(
                                          questionnaire: question, 
                                          controller: cellControllers[allQuestions.indexOf(question)]
                                        ),
                                      )
                                      
                                    ],
                                  ),
                                );
                              }
                            ) + [
                              const SizedBox(height: 12,),

                              buildSuggestionFragment()
                            ],
                          )
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),

    );
  }







  Widget buildSuggestionFragment() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12)
    ),
    child: Column(
    
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
    
      children: [
    
        HeaderText('SECTION B'),
    
        const SizedBox(height: 8,),
    
        const CustomText(
          'What is your general impression of the lecturer?',
          textAlignment: TextAlign.center,
          fontSize: 15,
        ),
    
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RatingRegulator(
            controller: ratingsController
          ),
        ),
        
    
        const CustomText(
          'What do you suggest could make to improve the overall performance of the lecturer and the class ?',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          textAlignment: TextAlign.center,
        ),
    
        const SizedBox(height: 5),
    
        //suggestions text area
        CustomTextArea(
          controller: suggestionController,
          maxLength: 300,
          hintText: 'Write your suggestions here',
          
        ),
    
        const SizedBox(height: 15,),
    
        //continue button
        CustomButton.withText(
          'Continue',
          width: double.infinity,
          onPressed: handleContinue
        )
      ],
    ),
  );


  void handleContinue() => Navigator.push(  
    context, 
    MaterialPageRoute(
      builder: (_) => VerifyReviewAnswersPage(
        courseInfo: widget.course, 
        answersMapList: cellControllers.map((controller) => controller.toMap()).toList(), 
        rating: ratingsController.rating, 
        suggestion: suggestionController.text
      )
    )
  );
}