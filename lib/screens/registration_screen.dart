import 'package:email_validator/email_validator.dart';
import 'package:flash_chat_starting_project/components/rounded_button.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_starting_project/services/auth_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '/constants.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final GlobalKey<FormState> _formKey = GlobalKey<FormState> ();

 bool errorOccurred = false,    showSpinner= false;
 String errorMessage = ' ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall:showSpinner ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),),
              const SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                       controller: _emailController,

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email){
                        return email != null && EmailValidator.validate(email) ?
                        null : 'Pleas enter a valid email';
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your passsword',
                        labelText: 'password',
                      ),

                      obscureText: true,
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password){
                        return password != null && password.length > 5
                            ? null
                            : ' the password should be of 6 characters at least.';
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24.0,
              ),
              Visibility(
                visible: errorOccurred,
                child
                    : Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style:TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              RoundedBouton(
                  color: kRegisterButtonColor,
                  title: 'Register',
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                   try{
                     setState(( ){
                     errorOccurred =false;
                     showSpinner = true;
                     });


                   await  AuthService()
                       .createUserWithEmailAndPassword(
                         email: _emailController.text,
                         password: _passwordController.text)
                         .then((value) {
                           Navigator.pop(context);
                           Navigator.pushNamed(context, ChatScreen.id);
                         });
                   setState((){
                     showSpinner = false;
                   });
                    }catch(e){
                     print('ERROR ${e.toString()}');
                     setState((){
                       showSpinner = false;
                       errorOccurred = true;
                       errorMessage=e.toString().split('] ')[1];
                     });

                   }
                    }
                  },
              ),
              const SizedBox(height: 12),


              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
