import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class DatabaseUser{
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email,});

  DatabaseUser.fromRow(Map<String, Object?> map) 
  : id = map[idColumn] as int,
   email = map[emailColumn] as String;
}

const idColumn = 'id';
const emailColumn = 'email';