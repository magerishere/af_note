import "package:af_note/helpers/env.dart";
import "package:af_note/models/note.dart";
import "package:path_provider/path_provider.dart" as syspath;
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";

const dbName = 'af_notes.db';
const notesTableName = 'notes';
const columnId = 'id';
const columnText = 'text';
const columnDeleted = 'deleted';

class DB {
  Future<Database> _openDatabase() async {
    final appDocDirectory = await syspath.getApplicationDocumentsDirectory();
    final dbPath = path.join(appDocDirectory.path, dbName);
    final dbObj = await openDatabase(
      dbPath,
      version: Env.dbVersion,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $notesTableName($columnId TEXT PRIMARY KEY,$columnText TEXT,$columnDeleted BOOL DEFAULT 0)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (newVersion == 3) {
          await db
              .execute('DELETE FROM $notesTableName WHERE $columnDeleted = 1');
        }
      },
    );

    return dbObj;
  }

  Future<List<Map<String, Object?>>> allNotes() async {
    final db = await _openDatabase();
    final notes = await db
        .query(notesTableName, where: '$columnDeleted = ?', whereArgs: ['0']);
    return notes;
  }

  Future<void> insertNote(Note note) async {
    final db = await _openDatabase();
    await db.insert(
      notesTableName,
      {
        columnId: note.id,
        columnText: note.text,
      },
    );
  }

  Future<void> updateNote(Note note) async {
    final db = await _openDatabase();
    await db.update(
      notesTableName,
      {
        columnText: note.text,
      },
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await _openDatabase();
    await db.update(
      notesTableName,
      {
        columnDeleted: '1',
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> restoreNote(String id) async {
    final db = await _openDatabase();
    await db.update(
      notesTableName,
      {
        columnDeleted: '0',
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> forceDelete(String id) async {
    final db = await _openDatabase();
    await db.delete(
      notesTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
