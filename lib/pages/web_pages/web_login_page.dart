

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';


class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool disableButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: Colors.grey.shade200,

      body: Container(
        alignment: Alignment.center,


        decoration: const BoxDecoration( 
          image: DecorationImage(
            image: AssetImage('lib/assets/UENR-Logo.png'),
            opacity: 0.4
          ),
        ),
        

        child: Opacity(
          opacity: 0.9,

          child: Container(
            width: 470,
            padding: const EdgeInsets.all(16),


            decoration: BoxDecoration(  
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)
            ),
          
          
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            
              children: [
            
                CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  radius: 80,
                  child: const  Icon(CupertinoIcons.person, color: Colors.white, size: 80,),
                ),
            
                HeaderText('Sign In', textColor: Colors.green.shade400),
            
            
                const SizedBox(height: 12,),
            
            
                CustomTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  leadingIcon: CupertinoIcons.person,
                  onChanged: (newValue) => checkFields(),
                ),
            
            
                const SizedBox(height: 8,),
            
            
                CustomPasswordField(
                  controller: passwordController,
                  hintText: 'Password',
                  onChanged: (newValue) => checkFields(),
                ),
            
            
                const SizedBox(height: 8,),
            
            
                TextButton(
                  onPressed: () => SharedFunctions.handleForgotPassword(context),
                  child: CustomText('Forgot Password ?', textColor: Colors.green.shade400,)
                ),
            
            
                const SizedBox(height: 12,),
            
                CustomButton.withText(
                  'Login', 
                  disable: disableButton,
                  width: double.infinity,
                  onPressed: () => SharedFunctions.handleLogin(context, usernameController.text, passwordController.text),
                )
            
                
              ],
            
            ),
          ),
        ),
      ),
    );
  }



  void checkFields() => setState(() => disableButton = usernameController.text.isEmpty || passwordController.text.isEmpty);


}