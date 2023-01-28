import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learningdart/services/cloud/cloud_note.dart';
import 'package:learningdart/services/cloud/cloud_storage_constants.dart';
import 'package:learningdart/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCLoudStorage {
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

  Stream<Iterable<CloudNote>> getAllNote ({required String ownerUserId}) {
    return notes.snapshots().map((event) => event.docs
      .map((doc) => CloudNote.fromsnapshot(doc))
      .where((note) => note.ownerUserId == ownerUserId)
    );
  }

  Future<Iterable<CloudNote>> getNotes ({required String ownerUserId}) async {
    try {
      return await notes
      .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .get()
      .then((value) => value.docs.map(
        (doc) {
          return CloudNote(
            documentId: doc.id, 
            ownerUserId: doc.data()[ownerUserIdFieldName] as String, 
            text: doc.data()[textFieldName] as String
            );
          },
        ),
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> createNewNote ({required String ownerUserId}) async {
    await notes.add({ownerUserIdFieldName : ownerUserId, textFieldName : ''});
  }


  static final FirebaseCLoudStorage _shared = FirebaseCLoudStorage._sharedInstance();
  FirebaseCLoudStorage._sharedInstance();
  factory FirebaseCLoudStorage() => _shared; 
}