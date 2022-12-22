import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
    return Column(
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
                        final userCredential = 
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, 
                            password: password);
                      print(userCredential);
                      } 
                      on FirebaseAuthException catch(e){
                        if(e.code == 'user-not-found') {print('User not found in the database');}
                        else if(e.code == 'wrong-code') {print('Wrong Password entered');}
                      }
                      
                    }, 
                    child : const Text('Login')
                  )
                ]
              );
  }
}
