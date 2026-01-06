
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/alert_dialog.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/components/cells.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/model/questionnaire.dart';

import '../providers/selc_provider.dart';


class VerifyReviewAnswersPage extends StatefulWidget {

  final RegisteredCourse courseInfo;
  final List<Map<String, dynamic>> answersMapList;
  final int rating;
  final String suggestion;

  const VerifyReviewAnswersPage({
    super.key,
    required this.courseInfo,
    required this.answersMapList,
    required this.rating,
    required this.suggestion,
  });

  @override
  State<VerifyReviewAnswersPage> createState() => _VerifyReviewAnswersPageState();
}

class _VerifyReviewAnswersPageState extends State<VerifyReviewAnswersPage> {

  bool disableSubmitButton = true;
  List<Questionnaire> allQuestions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    allQuestions = Provider.of<SelcProvider>(context, listen: false).allQuestions;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: isDesktop(context) ? null : AppBar(  
        title: HeaderText('Verify Your review.', fontSize: 18),
      ),

      body: LayoutBuilder(  
        builder: (_, constraint){

          if(isDesktop(context)) return buildDesktopView();


          return buildMobileView();

        },
      ),
    );
  }



  Widget buildMobileView(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: SingleChildScrollView(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 12,),
      
            CourseDetailSection(course: widget.courseInfo, showAvatar: false,),
      
            const SizedBox(height: 12,),
      
      
            buildQuestionCells(),

            const SizedBox(height: 12,),


            buildSuggestionSection(),


            Divider(),
      
            buildControlSection(),
      
          ],
        ),
      ),
    );
  }




  Widget buildDesktopView(){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              HeaderText(
                'Verify Evaluation for ${widget.courseInfo.courseCode}', 
                textColor: Colors.green.shade300
              ),


              Spacer(),

              IconButton(
                onPressed: () => 
                Navigator.pop(context), icon: Icon(CupertinoIcons.xmark, color: Colors.red,)
              )

            ],
          ),

          const SizedBox(height: 12,),

          Expanded(
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CourseDetailSection(course: widget.courseInfo),

                const SizedBox(width: 12,),


                Expanded(  
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(  
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        buildQuestionCells(),

                        const SizedBox(height: 8,),

                        buildSuggestionSection(),


                        const SizedBox(height: 8,),

                        Divider(),

                        const SizedBox(height: 8,),

                        buildControlSection()
                      ],
                    )
                  ),
                )
              ],
            ),
          )

          
        ],
      ),
    );
  }




  Widget buildDetails() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          
          //course information
          CustomText('Course Information', fontSize: 15, fontWeight: FontWeight.w600),

          const SizedBox(height: 8,),
          
          DetailContainer(title: 'Title [Course Code]', detail: '${widget.courseInfo.courseTitle} [${widget.courseInfo.courseCode}]'),
          
          const SizedBox(height: 8,),
          
          DetailContainer(title: 'Credit Hours', detail: widget.courseInfo.creditHours.toString()),

          const SizedBox(height: 8,),
          
          DetailContainer(title: 'Lecturer', detail: widget.courseInfo.lecturer),
          
          const SizedBox(height: 8,),
          
          DetailContainer(title: 'Department', detail: widget.courseInfo.department),
        ],
      ),
    );
  }





  Widget buildQuestionCells(){
    return Column(  
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderText('Questionnaire Response'),

        const SizedBox(height: 8,),

        for(int i = 0; i < allQuestions.length; i++) buildResponseCell(
          questionNumber: i+1, 
          question: allQuestions[i].question, 
          answer: widget.answersMapList[i]['answer']
        )

      ],
    );
  }


  Widget buildResponseCell({required int questionNumber, required String question, required String answer}){

    return ListTile(
      leading: HeaderText(questionNumber.toString(), fontSize: 18),
      title: CustomText(question, fontSize: 15,),
      subtitle: answerColorText(answer),
    );

  }



  Widget buildSuggestionSection(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        
        children: [
          CustomText('Rating', textColor: Colors.green.shade300, fontWeight: FontWeight.w600, fontSize: 15,),
          CustomText(widget.rating.toString(), fontSize: 14, fontWeight: FontWeight.w600,),
      
          const SizedBox(height: 12,),
      
          CustomText('Suggestion Made', textColor: Colors.green.shade300, fontWeight: FontWeight.w600, fontSize: 15,),
          CustomText(widget.suggestion, fontSize: 14, ),
        ],
      ),
    );      
  }




  Widget buildControlSection(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        CustomCheckBox(
          value: !disableSubmitButton, 
          text: 'I have reviewed my answers.',
          alignment: MainAxisAlignment.center,
          onChanged: (newValue) => setState(() => disableSubmitButton = !disableSubmitButton),
        ), 
        

        const SizedBox(height: 5,),
        
        //submit button
        CustomButton.withText(
          'Submit Review',
          width: double.infinity,
          disable: disableSubmitButton,
          onPressed: handleSubmit
        ),
      ],
    );
  }


  void handleSubmit() async {

    showDialog(
        context: context,
        builder: (_) => LoadingDialog(message: 'Submitting your review please wait')
    );

    try{

      await Provider.of<SelcProvider>(context, listen: false).submitQuestionnaire(widget.courseInfo.classCourseId!, widget.answersMapList, widget.rating, widget.suggestion);
      Navigator.pop(context); //close the loading animation window.

      showCustomAlertDialog(
          context,
          alertType: AlertType.success,
          title: 'Submit Report',
          contentText: 'You course review for "${widget.courseInfo.courseTitle}" has been submitted.',
          onDismiss: () => Navigator.popUntil(context, (route) => route.isFirst)
      );

    }on SocketException catch(_){
      Navigator.pop(context); //close the loading animation window.
      showToastMessage(context, details:'You are not connected to the internet. Check your internet connection and try again.');
      return;
    }on Error catch(exception){
      Navigator.pop(context); //close the loading alert window.
      showToastMessage(
        context,
        alertType: AlertType.warning, 
        details: 'An unexcepted error occurred. Please try again later.'
      );
      debugPrint(exception.toString());
      debugPrint(exception.stackTrace.toString());
      return;
    }

  }
}