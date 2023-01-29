import 'package:flutter/material.dart';
import 'package:learningdart/services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

/* Typedef in Dart is used to create a user-defined identity (alias) for a function, 
   and we can use that identity in place of the function in the program code. */
typedef NoteCallBack = Function(CloudNote note);

class NotesListView extends StatelessWidget {
  // In this class allNotes is written as notes
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({Key? key, required this.notes, required this.onDeleteNote, required this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: notes.length,
          itemBuilder:(context, index) {
            final note = notes.elementAt(index);
            return ListTile(
              onTap: () {
                onTap(note);
              },
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
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            );
          },
        );
  }
}