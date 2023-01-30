import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_service.dart';


import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/notes/create_update_note_view.dart';
import 'package:learningdart/views/notes_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/verify_email_view.dart';

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
        createOrUpdateNoteRoute:(context) => const CreateOrUpdateNoteView(),
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

// Counter application code
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: ((context) => CounterBloc()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing Bloc'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: ((context, state) {
//             final invalidValue = (state is CounterStateInvalidNumber) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text('Current value => ${state.value}'),
//                 Visibility(
//                   visible: state is CounterStateInvalidNumber,
//                   child:  Text('Invalid input : $invalidValue'),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(hintText: 'Enter any number'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context.
//                           read<CounterBloc>().
//                           add(DecrementEvent(_controller.text));
//                       }, 
//                       child: const Text('-')
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.
//                           read<CounterBloc>().
//                           add(IncrementEvent(_controller.text));
//                       }, 
//                       child: const Text('-')
//                     ),
//                   ],
//                 )
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) :super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// abstract class CounterEvent {
//   final String value;

//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)){
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if(integer == null){
//         emit(
//           CounterStateInvalidNumber(invalidValue: event.value, previousValue: state.value)
//         );
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });

//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if(integer == null){
//         emit(
//           CounterStateInvalidNumber(invalidValue: event.value, previousValue: state.value)
//         );
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });

//   }
// }