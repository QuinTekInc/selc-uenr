

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/alert_dialog.dart';
import 'package:selc_uenr/components/cells.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/pages/mobile_pages/mobile_evaluation_page.dart';
import 'package:selc_uenr/pages/get_started.dart';
import 'package:selc_uenr/pages/shared_pages.dart';
import 'package:selc_uenr/pages/student_info_page.dart';
import 'package:selc_uenr/providers/selc_provider.dart';


class WebDashboardPage extends StatefulWidget {

  const WebDashboardPage({super.key});

  @override
  State<WebDashboardPage> createState() => _WebDashboardPageState();
}


class _WebDashboardPageState extends State<WebDashboardPage> {


  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }


  void loadData() async {

    setState(() =>  isLoading = true);

    try{
      await Provider.of<SelcProvider>(context, listen: false).getRegisteredCourses();
    }on SocketException{
      showNoConnectionDialog(context);
    }on Error{
      
      showCustomAlertDialog(
        context, 
        alertType: AlertType.warning,
        title: 'Error', 
        contentText: 'An unexpected error occurred. Please try again.'
      );

    }



    setState(() => isLoading = false);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                HeaderText('Dashboard', textColor: Colors.green.shade400),

                const Spacer(), 


                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentInfoPage())), 
                  tooltip: 'View Profile',
                  icon: CircleAvatar(
                    backgroundColor: Colors.green.shade300,
                    child: Icon(CupertinoIcons.person, color: Colors.white,
                  ))
                ),

                const SizedBox(width: 8,),

                IconButton(
                  onPressed: () => SharedFunctions.handleLogout(context),
                  tooltip: 'Logout',
                  icon: Icon(Icons.logout, color: Colors.red.shade400,)
                ),
              ],
            ),

            const SizedBox(height: 12,),


            buildUserWelcomeText(context),



            const SizedBox(height: 12,),
            
            //todo: dashboard cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(  
                children: getDashboardCards(context),
              ),
            ),


            const SizedBox(height: 12,),


            Expanded(  
              child: buildCoursesTable()
            )
          ],
        ),
      ),
    );
  }






  Widget buildCoursesTable(){
    return Container(  
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),

      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8
      ),

      decoration: BoxDecoration(  
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),

      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [

          HeaderText(
            'My registered courses',
            fontSize: 16,
            textColor: Colors.green.shade400
          ),

          const SizedBox(height: 8,),


          //todo: table headers.

          Container(  
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200
            ),

            child: Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                //todo: blank space to store the book mark icons.
                const SizedBox(width: 120,),

                const Expanded(  
                  child: CustomText(  
                    'Course Code'
                  ),
                ),

                const Expanded(
                  flex: 2,  
                  child: CustomText('Course title'),
                ),

                const Expanded(
                  flex: 2,
                  child: CustomText(  
                    'Lecturer'
                  ),
                ),

                const SizedBox(  
                  width: 120,
                  child: CustomText(
                    'Cred. Hours',
                    textAlignment: TextAlign.center,
                  ),
                ),


                const Expanded(
                  child: CustomText(
                    'Evaluated',
                    textAlignment: TextAlign.center,
                  ),
                )

              ],
            ),
          ),


          const SizedBox(height: 12,),

          if(isLoading)Expanded(  
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
          else if(!isLoading && Provider.of<SelcProvider>(context).courses.isEmpty)Expanded(
            child: Container(  
              alignment: Alignment.center,
              child: Column(  
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(CupertinoIcons.book, size: 40, color: Colors.green.shade400,),

                  const SizedBox(height: 8,),

                  CustomText(
                    'No Data!',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    textAlignment: TextAlign.center,
                  ),

                  CustomText(
                    'All your registred coures for the semester appear here',
                    textAlignment: TextAlign.center,
                  ),


                  TextButton(  
                    onPressed: () => loadData(),
                    child: Row(  
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.refresh, color: Colors.green.shade300,),
                        const SizedBox(width: 3,),
                        CustomText( 
                          'Refresh',
                          textColor: Colors.green.shade300,
                        )
                      ],
                    ),
                  )
                  
                ],
              ),
            ),  

          )else Expanded(
            flex: 2,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: Provider.of<SelcProvider>(context).courses.length,  
              separatorBuilder: (_, __) => const SizedBox(height: 8,),
              itemBuilder: (_, index) {
                RegisteredCourse course = Provider.of<SelcProvider>(context, listen: false).courses[index];
                return WebCourseCell(course: course);
              }
            ),
          )

        ],
      )
    );
  }



}









class WebCourseCell extends StatefulWidget {

  final RegisteredCourse course;

  const WebCourseCell({super.key, required this.course});

  @override
  State<WebCourseCell> createState() => _WebCourseCellState();
}

class _WebCourseCellState extends State<WebCourseCell> {

  Color hoverColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(

      onHover: (_) => setState(() => hoverColor = Colors.green.shade100),

      onExit: (_) => setState(() => hoverColor = Colors.transparent),

      child: GestureDetector(
        onTap: () {

          if(widget.course.evaluated) {
            handleExtractEvaluationForCourse(context, widget.course);
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
              builder: (_) => EvaluationPage(course: widget.course)
            )
          );
        },

        child: Container(
          padding: const EdgeInsets.all(8),
        
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: hoverColor
          ),
        
          child: Row(  
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        
                //leading image icon
                SizedBox(
                  width: 120,
                  child: Icon(CupertinoIcons.book, color: Colors.green.shade400, size: 40,),
                ),
        
        
               Expanded(  
                child: CustomText(
                  widget.course.courseCode
                ),
              ),
        
              Expanded(
                flex: 2,
                child: CustomText(
                  widget.course.courseTitle
                ),
              ),

              Expanded(
                flex: 2,
                child: CustomText(
                  widget.course.lecturer
                ),
              ),

              SizedBox(
                width: 120,
                child: CustomText(
                  widget.course.creditHours.toString(),
                  textAlignment: TextAlign.center,
                ),
              ),


              Expanded(
                child: !widget.course.evaluated ? SizedBox() :  Center(
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green.shade400,
                    child: Icon(Icons.check, color: Colors.white, size: 12,),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

