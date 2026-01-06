
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
      
        children: [
      
          //show the UENR Image view.
          const LogoCardImageView(),
      
          const SizedBox(height: 10),
          
          //sign in text
          HeaderText('Sign In'),
      
          const SizedBox(height: 20,),
          
          //username field
          CustomTextField(
            controller: usernameController,
            hintText: 'Username',
            useLabel: true,
            leadingIcon: CupertinoIcons.person,
            onChanged: (newValue) => checkFields(),
          ),
      
          const SizedBox(height: 15,),
      
          //password field
          CustomPasswordField(
            controller: passwordController,
            hintText: 'Password',
            onChanged: (newValue) => checkFields()
          ),
      
          const SizedBox(height: 5,),
      
          //text button for forgot password.
          TextButton(
            child: const CustomText(
              'Forgot Password', 
              textColor: Colors.green,
              fontSize: 14,
            ),
            onPressed: () => SharedFunctions.handleForgotPassword(context),
          ),
      
          const SizedBox(height: 15,),
      
          //login button
          CustomButton.withText(
            'Login',
            disable: disableButton,
            width: double.infinity,
            onPressed: () => SharedFunctions.handleLogin(context, usernameController.text, passwordController.text),
          )
        ],
      ),
    );
  }



  void checkFields() => setState(() => disableButton =  usernameController.text.isEmpty || passwordController.text.isEmpty);

}