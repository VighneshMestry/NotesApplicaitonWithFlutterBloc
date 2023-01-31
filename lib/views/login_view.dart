import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/bloc/auth_event.dart';
import 'package:learningdart/services/auth/bloc/auth_state.dart';

import '../services/auth/bloc/auth_bloc.dart';
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
      appBar: AppBar(title: const Text('Login')),
      body: Column(children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        TextField(
          controller: _password,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Enter your password'),
        ),
        BlocListener<AuthBloc, AuthState> (
          listener: (context, state) async {
            //This BlocListener only handles all the exception which are thrown by our application.
            //As the Bloc works in form of states and events the state has been read and the exception stored in the state 
            //is called and checked if the exception is already handled or not.
            if(state is AuthStateLoggedOut){
              if(state.exception is UserNotFoundAuthException){
                await showErrorDialog(context, 'User Not Found');
              } else if (state.exception is WrongPasswordAuthException){
                await showErrorDialog(context, 'Wrong Credentials');
              } else if (state.exception is GenericAuthException){
                await showErrorDialog(context, 'Authentication Error');
              }
            }
          },
          child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                        AuthEventLogIn(email, password),
                      );
                // try {
                  // await AuthService.firebase().logIn(email: email, password: password);
                  // final user = AuthService.firebase().currentUser;
                  // if(user?.isEmailVerified ?? false){
                  //   Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,);
                  // }else{
                  //   Navigator.of(context).pushNamedAndRemoveUntil(verifyEmail, (route) => false,);
                  // }
                // } on UserNotFoundAuthException {
                //   await showErrorDialog(context, 'User not found!');
                // } on WrongPasswordAuthException {
                //   await showErrorDialog(context, 'Wrong Password');
                // } on GenericAuthException {
                //   await showErrorDialog(context, 'Authentication Error');
                // }
              },
              child: const Text('Login')),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not Registered yet?  Register here'))
      ]),
    );
  }
}
