import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';

import '../utilities/dialogs/error_dialog.dart';

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
                          await AuthService.firebase().createUser(email: email, password: password);
                          AuthService.firebase().sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyEmail);
                        }
                        on WeakPasswordAuthException{
                          await showErrorDialog(context, 'Weak Password');
                        }
                        on InvalidEmailAuthException{
                          await showErrorDialog(context, 'Invalid Email Entered');
                        }
                        on EmailAlreadyInUseAuthException{
                          await showErrorDialog(context, 'Email is already in use');
                        }
                        on GenericAuthException{
                          await showErrorDialog(context, 'Failed to Register');
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
