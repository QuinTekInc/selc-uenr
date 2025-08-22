
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/alert_dialog.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/pages/mobile_pages/mobile_evaluation_page.dart';
import 'package:selc_uenr/pages/shared_pages.dart';
import 'package:selc_uenr/pages/view_eval_page.dart';
import 'package:selc_uenr/providers/selc_provider.dart';
import '../model/questionnaire.dart';
import 'button.dart';
import 'ui_constants.dart' as uiConstants;






class CourseDetailSection extends StatelessWidget {

  final RegisteredCourse course;

  final bool showAvatar;

  const CourseDetailSection({super.key, required this.course, this.showAvatar=true});

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: isDesktop(context) ? 470 : double.infinity,
      padding: const EdgeInsets.all(12),  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100
      ),
    
    
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
    
          CustomText(
            'Course Information',
            fontWeight: FontWeight.w600,
            textColor: Colors.green.shade300,
          ),
    
    
          if(showAvatar) const SizedBox(height: 16,),
    
          if(showAvatar) Center(
            child: CircleAvatar(  
              radius: 80,
              backgroundColor: Colors.green.shade400,
              child: Icon(Icons.school, size: 80, color: Colors.white,),
            ),
          ),
    
          
          const SizedBox(height: 16),
    
    
          DetailContainer(title: 'Course Code', detail: course.courseCode),
          
          const SizedBox(height: 8,),
    
          DetailContainer(title: 'Course Title', detail: course.courseCode),
          
          const SizedBox(height: 8,),
    
  
          DetailContainer(title: 'Lecturer', detail: course.lecturer),
          
          const SizedBox(height: 8,),
    
    
          DetailContainer(title: 'Department', detail: course.department),
          
          const SizedBox(height: 8,),
    
          
        ],
      )
    );
  }
}




class CourseCell extends StatelessWidget {

  final RegisteredCourse course;

  const CourseCell({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: uiConstants.border,
      child: ListTile( 
        shape: uiConstants.border, 
        leading: Icon(CupertinoIcons.book, size: 40, color: Colors.green.shade400,),
        title: CustomText(
          '[${course.courseCode}] ${course.courseTitle}',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          maxLines: 2,
          overflow: TextOverflow.ellipsis
        ),
        subtitle: CustomText(course.lecturer, fontSize: 14,),

        trailing: course.evaluated ? const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green, size: 25,) :
                CustomText(course.creditHours.toString(), fontSize: 16, textColor: Colors.blue, fontWeight: FontWeight.w600,),

        onTap: () => SharedFunctions.handleCourseCellPressed(context, course),
      ),
    );
  }




}






class QuestionCell extends StatefulWidget {

  final QuestionCellController controller;
  final Questionnaire questionnaire;


  const QuestionCell({
    super.key,
    required this.questionnaire,
    required this.controller,
  });

  @override
  State<QuestionCell> createState() => _QuestionCellState();
}

class _QuestionCellState extends State<QuestionCell> {

  int? selectedIndex;

  int questionNumber = 0;

  @override
  void initState() {
    super.initState();

    questionNumber = Provider.of<SelcProvider>(context, listen:false)
                          .allQuestions.indexOf(widget.questionnaire) + 1;
   
    selectedIndex = widget.controller.selectedIndex;
    widget.controller.questionId = widget.questionnaire.questionId;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      shape: uiConstants.border,
      child: ListTile(
        tileColor: Colors.grey.shade300,
        shape: uiConstants.border,

        //the question number the question itself
        title: Row(
          children: [

            //question number
            CustomText(
              questionNumber.toString(), 
              fontSize: 20, fontWeight: FontWeight.w600, textAlignment: TextAlign.center,
            ),

            //the question
            Expanded(child: CustomText(widget.questionnaire.question, fontSize: 15, fontWeight: FontWeight.w500,)),
          ],
        ),

        //options
        subtitle: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),

            child: selectionBoxes(widget.questionnaire.possibleAnswers.answers)
        ),
      ),
    );
  }


  Widget selectionBoxes(List<String> possibleAnswers){

    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200
      ),

      child: isDesktop(context) ? Wrap(
        spacing: 5,
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        textDirection: TextDirection.ltr,
        children: buildCheckBoxes(possibleAnswers),
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildCheckBoxes(possibleAnswers),

      ),
    );
  }


  List<Widget> buildCheckBoxes(List<String> possibleAnswers) {
    return List.generate(
        possibleAnswers.length,
            (index){

          bool selected = false;
          String selectedAnswer = possibleAnswers[index];

          if(index == selectedIndex){
            selected = true;
          }


          return CustomCheckBox(
            value: selected,
            text: possibleAnswers[index],
            onChanged: (newValue) => setState((){
              selectedIndex = index;
              widget.controller.selectedIndex = index;
              widget.controller.selectedAnswer = selectedAnswer;
            }),
          );

        }
    );
  }
}







class QuestionCellController{

  String selectedAnswer;
  int questionId;
  int selectedIndex;

  QuestionCellController({
    this.selectedIndex = -1,
    this.questionId = -1,
    this.selectedAnswer = "No Answer"
  });


  Map<String, dynamic> toMap() => {
    'question_id': questionId,
    'answer': selectedAnswer,
  };

}




//todo: THE REGULATOR FOR RATING A PRODUCT or the application.
class RatingRegulator extends StatefulWidget {


  final RatingsController controller;
  final bool showTextField;

  const RatingRegulator({super.key, required this.controller, this.showTextField = false});

  @override
  State<RatingRegulator> createState() => _RatingRegulatorState();
}

class _RatingRegulatorState extends State<RatingRegulator> {

  final Map<int, String> ratingMap = {
    5: 'Excellent',
    4: 'Very Good',
    3: 'Good',
    2: 'Average',
    1: 'Poor',
    0: 'Please click on the star above to rate the lecturer'
  };

  @override
  Widget build(BuildContext context) {
    return Container(

      width: MediaQuery.of(context).size.width,

      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300
      ),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 2.5,
            children: List.generate(5, (index) => buildStars(index))
          ),

          const SizedBox(height: 8,),


          CustomText(
            ratingMap[widget.controller.rating]!,
            textAlignment: TextAlign.center,
          )
        ],
      ),
    );

  }


  Widget buildStars(int index){

    bool needColoring = false;
    IconData icon = Icons.star_outline;

    if(index+1 <=  widget.controller.rating){
      needColoring = true;
      icon = Icons.star;
    }


    return GestureDetector(
      child: Icon(  
        icon,
        color: needColoring ? Colors.green.shade400 : null,
        size: 35,
      ),

      //when the star is pressed, the rating of the product increases
      onTap: () => setState(() {
        widget.controller.rating = index+1;
      }),
    );


  }

}


//todo: controller for the rating star widget.
class RatingsController{

  int rating;

  RatingsController({this.rating = 0});

}

//todo: a static rating star widget 
Widget ratingStars(BuildContext context, double rate, {double? iconSize, EdgeInsets? padding}){

  int iRate = rate.round();

  List<Widget> icons = List.generate(5, (index){


    if(iRate < 1 && index == 0) return Icon(Icons.star_half, color: Colors.pink.shade400, size: 18,);
    
    IconData iconData;
    bool needsColoring = false;

    if(index+1 <= iRate){

      needsColoring = true;
      iconData = Icons.star;

      if(index+1 == iRate){
        double rem = iRate - rate;

        if(rem >= 0.5){
          iconData = Icons.star_half;
        }
      }
      

    }else{
      iconData = Icons.star_outlined;
    }

    return Icon(iconData, color: needsColoring ? Colors.pink.shade400 : null, size: iconSize ?? 18,);
  });

  return Container(

    padding: padding ?? const EdgeInsets.all(8),

    decoration: BoxDecoration(  
      color: Colors.green.shade100,
      borderRadius: BorderRadius.circular(12)
    ),

    child: Row( 
      mainAxisSize: MainAxisSize.min, 
      children: icons,
    ),
  );
}





class DetailContainer extends StatelessWidget {

  final String title;
  final String detail;

  const DetailContainer({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38)
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      
        children: [
      
          CustomText(
            title,
            fontWeight: FontWeight.w600
          ),
      
          const SizedBox(height: 3),
      
          CustomText(
            detail,
            softwrap: true,
          )
        ],
      ),
    );
  }
}


