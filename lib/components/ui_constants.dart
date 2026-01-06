
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/providers/selc_provider.dart';

import '../model/course_info.dart';
import '../pages/get_started.dart';
import '../pages/shared_pages.dart';
import '../pages/view_eval_page.dart';
import 'alert_dialog.dart';




const String organisationName = "Quality Assurance and Academic Planning Directorate";

const String termsMessage = "Dear Student, As UENR seeks to enhance the quality of teaching and "
    "learning of its students, your honest assessment of your lecturer and course"
    "is imperative to achieve to this goal."
    "\nPlease provide your feedback to your lecturer and"
    " management by responding to the items below to assist in improving teaching and learning."
    "\nNOTE THAT: your anonymity is assured.";


const String forgotCredentialsAlertContent = "Open the school's website and navigate to the student's portal login page,\n'https://sis.uenr.edu.gh/'"
    "\nClick on the 'Forgot password' button and follow the prompts to reset your credentials.";



final border = RoundedRectangleBorder(
  borderRadius:  BorderRadius.circular(12)
);



RichText buildUserWelcomeText(BuildContext context){
  return RichText(
    text: TextSpan(
      text: 'Welcome,\n',
      style: TextStyle(  
        color: Colors.black87,
        fontFamily: 'Poppins'
      ),


      children: [
        TextSpan(
          text: Provider.of<SelcProvider>(context).studentInfo.fullName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        ), 

        TextSpan(
          text: '\nto your SELC portal'
        )
      ]
    ),
  );
}



List<Widget> getDashboardCards(BuildContext context, {removeSizedBoxes = false}){


  SizedBox separator;

  if(isDesktop(context)){
    separator = SizedBox(width: 12,);
  }else{
    separator = SizedBox(height: 8,);
  }



  List<Widget> dashboardCards = [

    buildDashboardCard( 
      context, 
      title: 'Current Semester',
      detail: '1',
      icon: Icons.school,
      backgroundColor: Colors.grey.shade400
    ),

    separator,


    buildDashboardCard(
      context,  
      title: 'Registered Courses',
      detail: Provider.of<SelcProvider>(context).courses.length.toString(),
      icon: Icons.book,
    ),

    separator,

    buildDashboardCard(
      context,  
      title: 'Total Credit Hours',
      detail: Provider.of<SelcProvider>(context, listen: false).calculateTotalCreditHours().toString(),
      icon: CupertinoIcons.time,
      backgroundColor: Colors.red.shade400
    ),

    separator,

    buildDashboardCard(
      context,  
      title: 'Evaluated Courses',
      detail: Provider.of<SelcProvider>(context).computeEvaluatedCourses(),
      icon: Icons.check,
      backgroundColor: Colors.blue.shade400
    ),
  ];

  if(!removeSizedBoxes) return dashboardCards;

  return dashboardCards.where((widget) => widget.runtimeType != SizedBox().runtimeType).toList();
}



Widget buildDashboardCard(BuildContext context, {required IconData icon, required String title, required String detail, Color? backgroundColor}){

  double radius = 30;
  double iconSize = 35;

  if(!isDesktop(context)){
    radius = 25;
    iconSize = 30;
  }

  return Container(  
    padding: const EdgeInsets.all(8),
    alignment: Alignment.topLeft,
    constraints: BoxConstraints(
      maxWidth: isDesktop(context) ? 300 : double.infinity
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: backgroundColor ?? Colors.green.shade400,
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Color.lerp(backgroundColor ?? Colors.green.shade400, Colors.white, 0.4),
          radius: radius,
          child: Icon(icon, color: Colors.white, size: iconSize,),
        ),

        const SizedBox(width: 12,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                detail,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                textColor: Colors.white,
              ),
              
              const SizedBox(height: 3,),
          
              CustomText(
                title,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ]
    )
  );
}







bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 700;



//some functions are shared across widgets with the same code.

class SharedFunctions{

  static void handleLogin(BuildContext context, String username, String password) async {
    showDialog(
        context: context,
        builder: (_) => const LoadingDialog(
            message: 'Signing in. Please wait'
        )
    );

    try{

      await Provider.of<SelcProvider>(context, listen: false).login(username, password);

      Navigator.pop(context); //closes the loading dialog.

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage())
      );


    }on SocketException{

      Navigator.pop(context); //closes the loading dialog.
      showNoConnectionDialog(context);

    }on Exception catch(exception){

      Navigator.pop(context); //closes the loading dialog
      showCustomAlertDialog(
          context,
          title: 'Login Error',
          contentText: exception.toString()
      );

    }on Error{

      Navigator.pop(context); //closes the loading dialog

      showCustomAlertDialog(
        context,
        title: 'Error',
        contentText: 'An unexpected error occurred. Please try again.'
      );

      // debugPrint(e.toString());
      // debugPrint(e.stackTrace.toString());
    }
  }




  static void handleForgotPassword(BuildContext context){
    showCustomAlertDialog(
        context,
        alertType: AlertType.info,
        title: 'Forgot Password',
        contentText: forgotCredentialsAlertContent
    );
  }



  static void handleLogout(BuildContext context) async {

    showDialog(
        context: context,
        builder: (_) => LoadingDialog(message: 'Logging out please wait')
    );

    try{

      await Provider.of<SelcProvider>(context, listen: false).logout();
      Navigator.pop(context); //close the loading dialog


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => GetStartedPage(),
        ),
        (route) => false
      );


      Provider.of<SelcProvider>(context, listen: false).flushData();

    }on SocketException{

      Navigator.pop(context); //close the loading dialog.
      showNoConnectionDialog(context);

    }on Exception{
      Navigator.pop(context); //closes the loading dialog.
      showCustomAlertDialog(context, alertType: AlertType.warning, title: 'Logout Error', contentText: 'An unexpected error occurred.');
    }

  }





  static void handleCourseCellPressed(BuildContext context, RegisteredCourse course) {


    if(course.evaluated){
      handleExtractEvaluationForCourse(context, course);
      return;
    }
    
    
    if(course.isAcceptingResponse){
    
    	showToastMessage(
        context,
        alertType: AlertType.warning,
        details: 'No longer accepting evaluation response for this course'
      );


      return;
    
    }



    if(!Provider.of<SelcProvider>(context, listen: false).enableEvaluations){

      showToastMessage(
          context,
          alertType: AlertType.warning,
          details: 'Course evaluations has been disabled.'
      );

      return;
    }


    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>  EvaluationPage(course: course,)
        )
    );
  }



  static void handleExtractEvaluationForCourse(BuildContext context, RegisteredCourse course) async {

    showDialog(
        context: context,
        builder: (_) => const LoadingDialog(
            message: 'Retrieving information. Please wait'
        )
    );

    try{

      Map<String, dynamic> answersMap = await Provider.of<SelcProvider>(context, listen: false).getEvaluationForCourse(course.classCourseId!);

      Navigator.pop(context); //close the alert dialog.

      Navigator.push(context, MaterialPageRoute(
          builder: (_) => ViewEvaluationForCourse(courseInfo: course, answersMap: answersMap,)
      ));

    }on SocketException{
      Navigator.pop(context); //close the loading dialog.

      showNoConnectionDialog(context);
    }
    catch(error){

      Navigator.pop(context); //close the loading alert dialog.;

      showCustomAlertDialog(
          context,
          alertType: AlertType.warning,
          title: 'Error',
          contentText: 'There was error retrieving the information for course, ${course.courseTitle}[${course.courseCode}]. Please try again'
      );

    }

  }

}



