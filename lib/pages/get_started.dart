
import 'package:flutter/material.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/components/image_view.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/pages/shared_pages.dart';
import  '../components/ui_constants.dart' show termsMessage, organisationName;


class GetStartedPage extends StatelessWidget {

  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade200,

      body: Center(
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
        
          children: [
        
            const Spacer(),
        
            //UENR LOGO
        
            const LogoCardImageView(),
        
            const SizedBox(height: 10,),
        
            //application title
            HeaderText(
              "Student's Evaluation of Lecturers and Courses(SELC)",
              textAlignment: TextAlign.center, 
              textColor: Colors.green.shade400
            ),
        
            const SizedBox(height: 10,),
        
            //notice text
            SizedBox(
              width: MediaQuery.of(context).size.width > 700 ? 470 : double.infinity,
              child: const CustomText(
                termsMessage,
                textAlignment: TextAlign.center,
                fontSize: 14,
                      
              ),
            ),
        
            const SizedBox(height: 15,),
        
            //get started button
            CustomButton.withIcon(
              'Get Started',
              icon: Icons.arrow_forward_ios, 
              onPressed: () => handleGetStarted(context)
            ),
        
            
        
            const Spacer(),
        
        
            //powered by Quality Assurance Control, UENR
            const CustomText(
              'Powered By: $organisationName',
              padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
              textAlignment: TextAlign.center,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            )
            
          ],
        
        ),
      ),

    );
  }


  void handleGetStarted(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginPage()
    )
  );
}