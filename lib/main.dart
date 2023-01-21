import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_service.dart';


import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/notes/new_note_view.dart';
import 'package:learningdart/views/notes_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/verify_email_view.dart';

// import 'package:learningdart/views/login_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute :(context) =>  const LoginView(),
        registerRoute :(context) =>  const RegisterView(),
        notesRoute :(context) {return const NotesView();},
        verifyEmail :(context) => const VerifyEmailView(),
        newNoteRoute:(context) => const NewNoteView(),
      },
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

    @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if(user != null){
                if(user.isEmailVerified){
                  return const NotesView();
                }else {
                  return const VerifyEmailView();
                }
              }else{
                return const LoginView();
              }
              // if(user?.emailVerified ?? false){
              //   print('User is already registered');
              // }else {
              //   Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const VerifyEmailView())));
              // }
              default: 
                return const CircularProgressIndicator();
          }
        }, 
      );
  }
}




// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Null;
//   }
// }



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), 
//     );
//   }
// }
