import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learningdart/services/cloud/cloud_note.dart';
import 'package:learningdart/services/cloud/cloud_storage_constants.dart';
import 'package:learningdart/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote ({required String documentId}) async {
    try{
      await notes.doc(documentId).delete();
    } catch(e) {
      throw CouldNoteDeleteNoteException();
    }
  }

  Future<void> updateNote({required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName : text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes ({required String ownerUserId}) {
    final allNotes = notes
      .where(ownerUserIdFieldName, isEqualTo:ownerUserId)
      .snapshots()
      .map((event) => event.docs
        .map((doc) => CloudNote.fromsnapshot(doc)));
    return allNotes;
  }

  // Future<Iterable<CloudNote>> getNotes ({required String ownerUserId}) async {
  //   try {
  //     return await notes
  //     .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
  //     .get()
  //     .then((value) => value.docs.map(
  //       (doc) => CloudNote.fromsnapshot(doc),

  //       // {
  //       //   return CloudNote(
  //       //     documentId: doc.id, 
  //       //     ownerUserId: doc.data()[ownerUserIdFieldName] as String, 
  //       //     text: doc.data()[textFieldName] as String
  //       //     );
  //       //   },
         
  //       ),
  //     );
  //   } catch (e) {
  //     throw CouldNotGetAllNotesException();
  //   }
  // }

  Future<CloudNote> createNewNote ({required String ownerUserId}) async {
    // Here only the reference is stored inside the documentNote hover over it to read documentation.
    final documentNote = await notes.add({ownerUserIdFieldName : ownerUserId, textFieldName : ''});
    // Now the newNote stores the actual snapshot of the new note which is created by the user.
    final newNote = await documentNote.get();
    return CloudNote(documentId: newNote.id, ownerUserId: ownerUserId, text: '');
  }


  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared; 
}