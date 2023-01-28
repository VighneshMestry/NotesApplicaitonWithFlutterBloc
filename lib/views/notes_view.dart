import 'package:flutter/material.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/services/cloud/cloud_note.dart';
import 'package:learningdart/services/cloud/firebase_cloud_storage.dart';
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

   late final FirebaseCloudStorage _notesService;
   String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }
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
        body: StreamBuilder(
              stream: _notesService.allNotes(ownerUserId: userId),
              builder:(context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if(snapshot.hasData){
                      final allNotes = snapshot.data as Iterable<CloudNote>;
                      return NotesListView(
                        notes: allNotes,
                        onDeleteNote: (note) async{
                          await _notesService.deleteNote(documentId: note.documentId);
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
            ),
      );
  }
}