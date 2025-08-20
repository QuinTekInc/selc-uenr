
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/course_info.dart';



class ViewEvaluationForCourse extends StatelessWidget {
  
  final RegisteredCourse courseInfo;
  final Map<String, dynamic> answersMap;
  
  const ViewEvaluationForCourse({super.key, required this.courseInfo, required this.answersMap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: isDesktop(context) ? null : AppBar(
        titleSpacing: 0,
        title: HeaderText(courseInfo.courseCode, fontSize: 17),
      ),

      body: LayoutBuilder(  
        builder: (_, constraints){
          
          if(isDesktop(context)){
            return buildDesktopView(context);
          }

          return buildMobileView(context);

        }
      )
    );
  }


  Widget buildMobileView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          buildCourseSection(context),

          for(Widget categoryCell in buildCategories()) categoryCell,
          

          buildRatingCell(),

          buildSuggestionCell(),

          const SizedBox(height: 12)
        ],
      ),
    );
  }




  Widget buildDesktopView(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(   
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Row(
            children: [
              HeaderText('View Evaluation for ${courseInfo.courseCode}'),
              Spacer(),
              IconButton(  
                onPressed: () => Navigator.pop(context),
                icon: Icon(CupertinoIcons.xmark, color: Colors.red.shade400,),
              )
            ],
          ),
      
          const SizedBox(height: 12),
      
          Expanded(  
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
      
                SizedBox(  
                  width: 470,
                  child: buildCourseSection(context),
                ),
      
                const SizedBox(width: 12,),
      
      
                Expanded(  
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildCategories() + [
                        
                        buildRatingCell(),
      
                        buildSuggestionCell()
      
                      ],
                    ),
                  ),
                )
      
              ]
            ),
          )
        ],
      ),
    );
  }


  Widget buildCourseSection(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12)
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          Row(
            children: [
              Expanded(
                  child: buildCourseInfoDetailCell(
                      icon: CupertinoIcons.book,
                      title: 'Course',
                      useTextFlow: true,
                      //detail: //'${courseInfo.courseTitle}[${courseInfo.courseCode}]\nCred. Hours: ${courseInfo.creditHours}',
                      textFlow: RichText(
                        text: TextSpan(
                          text: '${courseInfo.courseTitle} [${courseInfo.courseCode}]\n',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Credits: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            TextSpan(
                              text: courseInfo.creditHours.toString()
                            )
                          ]
                        ),
                      )
                  )
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(color: Colors.black45, thickness: 0.5,),
          ),

          buildCourseInfoDetailCell(icon: CupertinoIcons.person, title: 'Lecturer', detail: courseInfo.lecturer),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(color: Colors.black45, thickness: 0.5,),
          ),

          buildCourseInfoDetailCell(icon: Icons.school_outlined, title: 'Deptartment', detail: courseInfo.department)
        ],
      ),
    );
  }


  ListTile buildCourseInfoDetailCell({required IconData icon, required String title, String? detail, useTextFlow=false, Widget? textFlow}){
    return ListTile(
      leading: Icon(icon, size: 25, color: Colors.green,),
      title: CustomText(title, fontWeight: FontWeight.w600, fontSize: 15,),
      subtitle: !useTextFlow ? CustomText(detail ?? '', fontSize: 13,) : textFlow!,
    );
  }


  List<Widget> buildCategories(){

    List<Widget> categoryWidgets = [];

    //List<Map<String, dynamic>>
    dynamic evalAnswersMap = answersMap['eval_answers'];

    for(Map<String, dynamic> categoryMap in evalAnswersMap){

      categoryWidgets.add(buildCategoryCell(categoryMap));
    }

    return categoryWidgets;
  }
  
  
  Widget buildCategoryCell(Map<String, dynamic> categoryMap){

    //List<Map<String, dynamic>>
    List<dynamic> catQuestionAnswers = categoryMap['answers'];
    
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        
        children: [
          HeaderText(categoryMap['cat_name']),

          for(Map<String, dynamic> answerMap in catQuestionAnswers) ListTile(
            leading: const Icon(Icons.question_mark, color: Colors.green,),
            title: CustomText(answerMap['question'], fontWeight: FontWeight.w600, fontSize: 14,),
            subtitle: answerColorText(answerMap['answer']),
          ),
        ],
      ),
    );
    
  }


  Widget buildRatingCell(){
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300
      ),

      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.green, size: 30,),
        title: HeaderText('Rating', fontSize: 16),
        subtitle: CustomText(answersMap['rating'].toString(), fontSize: 14, fontWeight: FontWeight.w500, textColor: Colors.green,),
      ),
    );
  }


  Widget buildSuggestionCell(){
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300
      ),

      child: ListTile(
        leading: const Icon(Icons.chat, color: Colors.green, size: 25,),
        title: HeaderText('Suggestion', fontSize: 16),
        subtitle: CustomText(answersMap['suggestion'], fontSize: 14, fontWeight: FontWeight.w500, textColor: Colors.green,),
      ),
    );
  }
}
