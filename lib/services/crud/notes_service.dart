import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'crud_exception.dart';

 
class NotesService{
  Database? _db;  
  
  List<DatabaseNote> _notes = [];

  //Creating NotesService Singleton
  NotesService._sharedInstance();
  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;

  final _notesStreamController =  StreamController<List<DatabaseNote>>.broadcast();
  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;
  
Future<DatabaseUser> getOrCreateUser ({required String email}) async {
  try{
    final user = await getUser(email: email);
    return user;
  } on CouldNotFindUser {
    final createdUser = await createUser(email: email);
    return createdUser;
  } catch(e) {
    rethrow;
  }
}
  //Because sometimes the list can be of million entries caching technique is used in which the list is already stored in a variable and used whenever needed
  Future<void> _cacheNotes() async {

    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  } 
  
  // Underscore says that the function is private

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email : owner.email);

    if(dbUser != owner){
      throw CouldNotFindUser();
    }
    const text = '';
    int noteId = await db.insert(noteTable, {
      userIdColumn : owner.id, textColumn : text, isSyncedWithCloudColumn : 1,
    });

    final note = DatabaseNote(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote ({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deleteCount = await db.delete(userTable, where: 'id = ?', whereArgs: [id]);

    if(deleteCount != 1) {
      throw CouldNotDeleteNote();
    }
    else{
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes () async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    _notes = [];
    _notesStreamController.add(_notes);
    return await db.delete(noteTable);  // check for the where = null condition with the output.
  }

  Future<DatabaseNote> getNote ({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final notes = await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);

    if(notes.isEmpty) throw CouldNotFindNote();

    final note =  DatabaseNote.fromRow(notes.first);
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note; 
  }

  Future<Iterable<DatabaseNote>> getAllNotes () async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote ({required DatabaseNote note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // make sure if the note exists.
    await getNote(id : note.id);

    final updateCount = await db.update(noteTable, {
      textColumn : text,
      isSyncedWithCloudColumn : 0,
    });
    
    if(updateCount == 0) {
      throw CouldNotUpdateNote();
    }
    else {
      final updatedNote =  await getNote(id : note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Database _getDatabaseOrThrow () {
    final db = _db;
    if(db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close () async {
    Database? db = _db;
    if(db == null) {
      throw DatabaseIsNotOpen();
    }else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen () async {
    try{
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open () async {
    if(_db != null) throw DatabaseAlreadyOpenException();

    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final path = join(docsPath.path, dbName);
      final db = await openDatabase(path);
      _db = db;
      
      await db.execute(createUserTable);
      await db.execute(createNotesTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentDirectory();
    }
  }

  Future<DatabaseUser> createUser ({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase]);

    if(results.isNotEmpty) throw UserAlreadyExists();

    final userId = await db.insert(userTable, {
      emailColumn : email,
    });

    return DatabaseUser(id: userId, email: email,);
  }

  Future<void> deleteUser ({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      userTable, 
      where: 'email = ?', 
      whereArgs: [email.toLowerCase()],
      );
    if(deleteCount != 1) throw CouldNotDeleteUser();
  }

  Future<DatabaseUser> getUser ({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable, limit: 1, where: 'email = ?', whereArgs : [email.toLowerCase]);

    if(results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

}

class DatabaseUser{
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email,});

  DatabaseUser.fromRow(Map<String, Object?> map) 
  : id = map[idColumn] as int,
   email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({required this.id, required this.userId, required this.text, required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map) : 
  id = map[idColumn] as int, 
  userId = map[userIdColumn] as int, 
  text = map[textColumn] as String, 
  isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false ;

  @override
  String toString() => 'Note, ID = $id, userId = $userId, isSyncWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;

}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_sync_with_cloud';
const createUserTable = '''
        CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email_id"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';
const createNotesTable = '''
        CREATE TABLE "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_sync_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "note"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';