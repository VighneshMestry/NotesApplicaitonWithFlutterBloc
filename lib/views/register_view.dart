import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                        
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email, 
                              password: password);
                      }, 
                      child : const Text('Register')
                    ),
                    TextButton(onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                    }, 
                    child: const Text('Already have an account? Login')),
                  ]
                ),
    );
  }
}
