
// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/model/questionnaire.dart';
import 'package:selc_uenr/pages/verify_answers.dart';
import 'package:selc_uenr/providers/selc_provider.dart';

import '../../components/cells.dart';


class MobileEvaluationPage extends StatefulWidget {

  final RegisteredCourse course;

  const MobileEvaluationPage({
    super.key,
    required this.course
  });

  @override
  State<MobileEvaluationPage> createState() => _MobileEvaluationPageState();
}



class _MobileEvaluationPageState extends State<MobileEvaluationPage> {

  Map<String, List<Questionnaire>> questionnairesMap = {};
  
  List<Questionnaire> allQuestions = [];

  //list of controllers for question cells
  List<QuestionCellController> qCellControllers = [];

  //controller to handle the user suggesting how to improve upon the lessons taught in class.
  final _suggestionController = TextEditingController();
  final _ratingsController = RatingsController();

  List<Widget> categoryFragments = [];
  final _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    questionnairesMap = Provider.of<SelcProvider>(context, listen:false).questionnairesMap;
    
    allQuestions = Provider.of<SelcProvider>(context, listen: false).allQuestions;
    qCellControllers = List<QuestionCellController>.generate(allQuestions.length, (index) => QuestionCellController());

    setState(() {
      categoryFragments = initFragments();
      categoryFragments.add(buildSuggestionFragment());
    });
  }



  List<Widget> initFragments() => List.generate(
    questionnairesMap.length,
    (int index) {

      String categoryName = questionnairesMap.keys.elementAt(index);
      List<Questionnaire> catQuestions = questionnairesMap[categoryName] ?? [];
      
      return buildCategoryFragment(
        categoryName: categoryName,
        catQuestions: catQuestions,
      );
    }
  );






  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          if(currentPage > 0) FloatingActionButton(
              child: HeaderText('<', textColor: Colors.white),
              tooltip: 'Previous',
              backgroundColor: Colors.green.shade400,
              onPressed: (){
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 500), curve: Curves.easeIn
                );

              }
          ),

          const SizedBox(width: 5,),

          if(currentPage != categoryFragments.length - 1)FloatingActionButton(

              child: HeaderText('>', textColor: Colors.white),
              tooltip: 'Next',
              backgroundColor: Colors.green.shade400,
              onPressed: (){

                _pageController.nextPage(
                    duration: const Duration(milliseconds: 500), curve: Curves.easeIn
                );
              }
          )
        ],
      ),

      appBar: AppBar(
        titleSpacing: 0,
        title: HeaderText(
          '${widget.course.courseTitle} (${widget.course.courseCode})',
          fontSize: 16
        ),
        
        actions: [
          IconButton(
            onPressed: handleShowCourseInfo, 
            icon: Icon(CupertinoIcons.info_circle_fill, color: Colors.green.shade400, size: 30,)
          )
        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: PageView(
              controller: _pageController,
              children: categoryFragments,
              onPageChanged: (int? newPage) => setState(() {
                currentPage = newPage!;
              }),
            ),
          ),
        ],
      )
    );
  }



  Widget buildCategoryFragment({required String categoryName, required List<Questionnaire> catQuestions}){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        //the category name
        HeaderText(categoryName),

        const SizedBox(height: 8,),

        //list view for questions under a particular category
        Expanded(
          child: ListView.builder(
            itemCount: catQuestions.length,
            itemBuilder: (_, index) {
              Questionnaire question = catQuestions[index];
              //todo: fix this later.
              int qIndex = allQuestions.indexOf(question);
              return QuestionCell(
                controller: qCellControllers[qIndex],
                questionnaire: question,
              );
            }
          ),
        )
      ],
    );

  }


  Widget buildSuggestionFragment() => Column(

    crossAxisAlignment: CrossAxisAlignment.start,

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
          controller: _ratingsController
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
        controller: _suggestionController,
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
  );


  void handleShowCourseInfo(){

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, 
      isScrollControlled: true,

      builder: (_) => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(3),

        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1.5,
            color: Colors.green.shade200
          )
        ),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            HeaderText('Course Information'),

            const SizedBox(height: 12,),

            DetailContainer(title: 'Course', detail: '${widget.course.courseTitle} [${widget.course.courseCode}]'),

            const SizedBox(height: 8),
            
            DetailContainer(title: 'Lecturer', detail: widget.course.lecturer),

            const SizedBox(height: 8),

            DetailContainer(title: 'Department', detail: widget.course.department)

          ],
        ),
      )
    );

  }


  /*
  todo: collects the answers and takes them to a page where they cross-check their review and finally submit them.
  */
  void handleContinue(){

    String suggestion = _suggestionController.text;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerifyReviewAnswersPage(
          courseInfo: widget.course,
          answersMapList: qCellControllers.map((controller) => controller.toMap()).toList(),
          rating: _ratingsController.rating,
          suggestion: suggestion,
        )
      )
    );

  }

}


