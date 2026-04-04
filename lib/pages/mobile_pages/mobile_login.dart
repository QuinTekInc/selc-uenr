
// ignore_for_file: sort_child_properties_last
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selc_uenr/components/button.dart';
import 'package:selc_uenr/components/image_view.dart';
import 'package:selc_uenr/components/text.dart';
import 'package:selc_uenr/components/ui_constants.dart';


class MobileLoginPage extends StatefulWidget {
  
  const MobileLoginPage({super.key});

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  bool disableButton = true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade200,

      //todo: fix the UI space overflow when the keyboard is invoked

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
      
          //show the UENR Image view.
          const LogoCardImageView(),
          
          //sign in text
          HeaderText('Sign In'),
      
          const SizedBox.shrink(),
          
          //username field
          CustomTextField(
            controller: usernameController,
            hintText: 'Username',
            useLabel: true,
            leadingIcon: CupertinoIcons.person,
            onChanged: (newValue) => checkFields(),
          ),
      
          //password field
          CustomPasswordField(
            controller: passwordController,
            hintText: 'Password',
            onChanged: (newValue) => checkFields()
          ),
      
          //text button for forgot password.
          TextButton(
            child: const CustomText(
              'Forgot Password', 
              textColor: Colors.green,
              fontSize: 14,
            ),
            onPressed: () => SharedFunctions.handleForgotPassword(context),
          ),
      
          //login button
          CustomButton.withText(
            'Login',
            disable: disableButton,
            width: double.infinity,
            onPressed: () => SharedFunctions.handleLogin(context, usernameController.text, passwordController.text),
          ),


          //todo: this button will be removed
          CustomButton.withText(
            "Sign In with credentials",
            onPressed: ()  => SharedFunctions.handleOAuthLogin(context),
            backgroundColor: Colors.blue.shade400,
          )
        ],
      ),
    );
  }



  void checkFields() => setState(() => disableButton =  usernameController.text.isEmpty || passwordController.text.isEmpty);

}