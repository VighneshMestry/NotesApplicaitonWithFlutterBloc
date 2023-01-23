import 'package:flutter/material.dart';

import '../../services/crud/notes_service.dart';
import '../../utilities/dialogs/delete_dialog.dart';

/* Typedef in Dart is used to create a user-defined identity (alias) for a function, 
   and we can use that identity in place of the function in the program code. */
typedef DeleteNoteCallBack = Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  // In this class allNotes is written as notes
  final List<DatabaseNote> notes;
  final DeleteNoteCallBack oneDeleteNote;

  const NotesListView({super.key, required this.notes, required this.oneDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: notes.length,
          itemBuilder:(context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(
                note.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              // Trialing widget helps us to add any widget at the end of the tile which we have built. In this case the individual note is a built tile.
              trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if(shouldDelete){
                    oneDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            );
          },
        );
  }
}