import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                          final user = FirebaseAuth.instance.currentUser;

                          await user?.sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyEmail);
                        } on FirebaseAuthException catch(e){
                          if(e.code == 'weak-password') {
                            await showErrorDialog(context, 'Weak Password');
                          }else if(e.code == 'invalid-email'){
                            await showErrorDialog(context, 'Invalid Email Entered');
                          } else if(e.code == 'email-already-in-use') {
                            await showErrorDialog(context, 'Email is already in use');
                          }else {
                            await showErrorDialog(context, 'Error ${e.code}');
                          }
                        } catch(e){
                          await showErrorDialog(context, e.toString());
                        }
                      }, 
                      child : const Text('Register')
                    ),
                    TextButton(onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    }, 
                    child: const Text('Already have an account? Login')),
                  ]
                ),
    );
  }
}
