import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateRegistering){
          if(state.exception is WeakPasswordAuthException){
            await showErrorDialog(context, 'Wrong Password');
          } else if (state.exception is EmailAlreadyInUseAuthException){
            await showErrorDialog(context, 'Email is already in use');
          } else if(state.exception is GenericAuthException){
            await showErrorDialog(context, 'Failure');
          } else if (state.exception is InvalidEmailAuthException){
            await showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
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
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventRegister(email , password));
                // try {
                //   await AuthService.firebase()
                //       .createUser(email: email, password: password);
                //   AuthService.firebase().sendEmailVerification();
                //   Navigator.of(context).pushNamed(verifyEmail);
                // } on WeakPasswordAuthException {
                //   await showErrorDialog(context, 'Weak Password');
                // } on InvalidEmailAuthException {
                //   await showErrorDialog(context, 'Invalid Email Entered');
                // } on EmailAlreadyInUseAuthException {
                //   await showErrorDialog(context, 'Email is already in use');
                // } on GenericAuthException {
                //   await showErrorDialog(context, 'Failed to Register');
                // }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Login')),
        ]),
      ),
    );
  }
}
