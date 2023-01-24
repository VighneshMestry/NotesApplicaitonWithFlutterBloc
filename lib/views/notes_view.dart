import 'package:flutter/material.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/services/crud/notes_service.dart';
import 'package:learningdart/views/notes/notes_list_view.dart';

import '../enum/menu_action.dart';
import '../constants/routes.dart';
import '../utilities/dialogs/log_out.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {

   final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
  }

  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            }, icon: const Icon(Icons.add)
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
              switch(value){
                case MenuAction.logout:
                  final showLogout = await showLogOutDialog(context);
                  if(showLogout){
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
          itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value : MenuAction.logout,
                child:  Text('My Accout'),
              ),
              PopupMenuItem<MenuAction>(
                value : MenuAction.logout,
                child:  Text('Log out'),
              )
            ];
          },)
        ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.done:
              // StreamBuilder helps to display allNotes on the UI screen from the database table
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder:(context, snapshot) {
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if(snapshot.hasData){
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          return NotesListView(
                            notes: allNotes,
                            onDeleteNote: (note) async{
                              await _notesService.deleteNote(id: note.id);
                            },
                            onTap: (note) {
                              Navigator.of(context).pushNamed(createOrUpdateNoteRoute, arguments : note);
                            },
                          );
                        }else{
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default :
                return const CircularProgressIndicator();
            }
          }
        ),
    );
  }
}