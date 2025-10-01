

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/components/cells.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';
import 'package:selc_uenr/model/student_info.dart';
import 'package:selc_uenr/providers/selc_provider.dart';


class StudentInfoPage extends StatelessWidget {
  const StudentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: HeaderText('Student Info')
      ),


      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: isDesktop(context) ? Container(  
              width: 470,
              child: buildDetailsBody(context),
            ) : buildDetailsBody(context)
          ),
        ),
      ),
    );
  }




  Column buildDetailsBody(BuildContext context) {

    StudentInfo studentInfo = Provider.of<SelcProvider>(context, listen: false).studentInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20),
          child: CircleAvatar(
            backgroundColor: Colors.green.shade400,
            radius: 60,
            child: const Icon(CupertinoIcons.person, size: 60, color: Colors.white),
          ),
        ),
            
        const SizedBox(height: 16,),
    
    
        DetailContainer(title: 'Full Name', detail: studentInfo.fullName!),
    
        const SizedBox(height: 8,),
            
            
        DetailContainer(title: 'Reference Number: ', detail: studentInfo.referenceNumber!),
            
        const SizedBox(height: 8,),
            
            
        //TODO: Uncomment the line below, when the index number becomes relevant
        //DetailContainer(title: 'Index Number: ', detail: studentInfo.indexNumber!),
            
        DetailContainer(title: 'Age:', detail: studentInfo.age!.toString()),
            
        const SizedBox(height: 8),
            
        DetailContainer(title: 'Department: ', detail: studentInfo.department!),
            
        const SizedBox(height: 8),
            
        DetailContainer(title: 'Program: ', detail: studentInfo.program!),
            
        const SizedBox(height: 8),
            
        DetailContainer(title: 'Campus of study:', detail: studentInfo.campus!),
            
        const SizedBox(height: 8),
            
        DetailContainer(title: 'Status:', detail: studentInfo.status!),
            
        const SizedBox(height: 8),
            
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Divider(),
        ),
            
        CustomButton.withText(
          'Logout',
          onPressed: () => SharedFunctions.handleLogout(context),
          width: double.infinity,
            
        ),
            
        const SizedBox(height: 8,),
            
      ],
    );
  }

}
