import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_service.dart';

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
            // AuthService.firebase().sendEmailVerification();
            final tempUser = FirebaseAuth.instance.currentUser;
            if(tempUser!=null && !tempUser.emailVerified){
            await tempUser.sendEmailVerification();
            }
          }, 
          child: const Text('Send Email Verification')),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
          }, child: const Text('Return to Register page?')),
        ]
      ),
    );
  }
}