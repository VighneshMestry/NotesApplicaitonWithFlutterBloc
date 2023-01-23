import 'package:flutter/material.dart';

import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';

import '../utilities/dialogs/error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
    late final TextEditingController _email;
    late final TextEditingController _password;

    @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(title : const Text('Login')),
      body: Column(
                  children: [
                    TextField(
                      controller: _email, 
                      keyboardType: TextInputType.emailAddress, 
                      autocorrect: false, 
                      enableSuggestions: false, 
                      decoration: const InputDecoration(hintText: 'Enter your email'),),
                    TextField(
                      controller: _password, 
                      autocorrect: false,
                      enableSuggestions: false, 
                      obscureText: true, 
                      decoration : const InputDecoration(hintText: 'Enter your password'),),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try{
                          
                          await AuthService.firebase().logIn(email: email, password: password);
                          final user = AuthService.firebase().currentUser;
                          if(user?.isEmailVerified ?? false){
                            Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,);
                          }else{
                            Navigator.of(context).pushNamedAndRemoveUntil(verifyEmail, (route) => false,);
                          }
                        } 
                        on UserNotFoundAuthException{
                          await showErrorDialog(context, 'User not found!');
                        }
                        on WrongPasswordAuthException{
                          await showErrorDialog(context, 'Wrong Password');
                        }
                        on GenericAuthException{
                          await showErrorDialog(context, 'Authentication Error');
                        }
                      }, 
                      child : const Text('Login')
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                      },
                     child: const Text('Not Registered yet?  Register here'))
                  ]
                ),
    );
  }
}