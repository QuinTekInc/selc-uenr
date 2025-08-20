
import 'package:flutter/material.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/course_info.dart';
import 'package:selc_uenr/pages/mobile_pages/mobile_evaluation_page.dart';
import 'package:selc_uenr/pages/web_pages/web_dashboard.dart';
import 'package:selc_uenr/pages/web_pages/web_evaluation_page.dart';
import 'package:selc_uenr/pages/web_pages/web_login_page.dart';

import 'mobile_pages/mobile_dashboard.dart';
import 'mobile_pages/mobile_login.dart';



class LoginPage extends StatelessWidget {
  
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(  
      builder: (_, __){
        
        if(isDesktop(context)) return WebLoginPage();
        
        return MobileLoginPage();
      }
    );
  }
}




class DashboardPage extends StatelessWidget {
  
  const DashboardPage({super.key});


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(  
      builder: (_, __){
        
        if(isDesktop(context)) return WebDashboardPage();
        
        return MobileDashboardPage();
      }
    );
  }
}




class EvaluationPage extends StatelessWidget{
  
  final RegisteredCourse course;

  const EvaluationPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, __){
        
        if(isDesktop(context)) return WebEvaluationPage(course: course);
        
        return MobileEvaluationPage(course: course);
        
      }
    );
  }
}

