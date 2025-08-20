


/* 
This page loads the courses the student has registered in a particular semester in a particular academic year.
The information is loaded based on the student's information queried from the school's database.
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/alert_dialog.dart';
import 'package:selc_uenr/components/cells.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/pages/student_info_page.dart';
import 'package:selc_uenr/providers/selc_provider.dart';
import 'package:selc_uenr/pages/web_pages/web_dashboard.dart';


class MobileDashboardPage extends StatefulWidget {
  const MobileDashboardPage({super.key});

  @override
  State<MobileDashboardPage> createState() => _MobileDashboardPageState();
}

class _MobileDashboardPageState extends State<MobileDashboardPage> {


  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }


  void loadData() async {

   setState(() => isLoading = true);

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
        padding: EdgeInsets.all(12),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                HeaderText('Dashboard', textColor: Colors.green.shade400),

                Spacer(),


                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentInfoPage())),
                  icon: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green.shade300,
                    child: Icon(CupertinoIcons.person, size: 18, color: Colors.white,),
                  ),
                )
              ],
            ), 


            const SizedBox(height: 8,),


            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [


                    buildUserWelcomeText(context),

                    const SizedBox(height: 8,),

                    //display the dash cards.
                    // for(Widget dashboardCard in getDashboardCards(context)) dashboardCard,

                    buildDashboardCardsGrid(),


                    const SizedBox(height: 12,),


                    Container(  
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                      ),

                      child: Column(  
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          CustomText(
                            'My Coures', 
                            fontSize: 15, 
                            fontWeight: FontWeight.w600, 
                            textColor: Colors.green.shade300,
                          ), 


                          const SizedBox(height: 8,), 


                          if(!isLoading && Provider.of<SelcProvider>(context).courses.isEmpty) buildEmptyPlaceholder()
                          else ListView.separated(  
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: Provider.of<SelcProvider>(context).courses.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8,),
                            itemBuilder: (_, index){
                              RegisteredCourse course = Provider.of<SelcProvider>(context, listen: false).courses[index];
                              return CourseCell(course: course);
                            },
                          )
                        ],
                      )
                    )
                    

                  ],
                ),
              ),
            )
            
          ],
        ),
      )
    );
  }

  GridView buildDashboardCardsGrid() {

    List<Widget> dashboardCards = getDashboardCards(context, removeSizedBoxes: true);

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 100  
      ), 
      itemCount: dashboardCards.length,
      itemBuilder: (_, index) => dashboardCards[index]
    );
  }




  Widget buildEmptyPlaceholder(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.book, size: 100, color: Colors.green,),
          const CustomText('All your registered courses appear here', fontSize: 14,),
          const SizedBox(height: 8,),

          TextButton(
            onPressed: loadData,
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.refresh, color: Colors.green.shade400),
                const SizedBox(width: 3,),
                CustomText('Click to refresh', textColor: Colors.green.shade400,)
              ],
            ),
          )
        ],
      ),
    );
  }

  
  //this method applies a padding to a CourseCell based on its index in the list of courses.
  Widget buildCourseCell(int index){

    final CourseCell cell = CourseCell(course: Provider.of<SelcProvider>(context).courses[index]);

    const EdgeInsets topPadding = EdgeInsets.only(top: 8);
    const EdgeInsets bottomPadding = EdgeInsets.only(bottom: 8);
    
    bool isFirstIndex = index == 0;
    bool isLastIndex = index == Provider.of<SelcProvider>(context).courses.length - 1;
    bool isFirstOrLastIndex =  isFirstIndex || isLastIndex;

    if(isFirstOrLastIndex) {
      return Padding(
        padding: isFirstIndex ? topPadding : bottomPadding,
        child: cell,
      );
    }

    return cell; 

  }
}