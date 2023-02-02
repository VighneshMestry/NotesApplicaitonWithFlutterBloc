import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learningdart/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}
class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verify')),
      body: Column(
        children: [
          const Text("We've sent you and email verification. Please open it to verify your account."),
          const Text("If you haven't received a verificaction email yet, press the button below"),
          const Text('Please Verify your email address'),
          TextButton(onPressed: () async {
            context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
          }, 
          child: const Text('Send Email Verification')),
          TextButton(onPressed: () {
            context.read<AuthBloc>().add(const AuthEventLogOut());
          }, child: const Text('Return to Register page?')),
        ]
      ),
    );
  }
}