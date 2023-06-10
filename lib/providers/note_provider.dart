import 'dart:async';

import 'package:af_note/helpers/db.dart';
import 'package:af_note/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncNotes extends AsyncNotifier<List<Note>> {
  Future<List<Note>> _fetchNotes() async {
    final notes = await DB().allNotes();
    return notes.map((note) => Note.fromDB(note)).toList();
  }

  @override
  FutureOr<List<Note>> build() {
    return _fetchNotes();
  }

  Future<void> addNote(String text, {String? id}) async {
    final note = Note(text, id: id);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        if (id == null) {
          await DB().insertNote(note);
        } else {
          await DB().updateNote(note);
        }
        return _fetchNotes();
      },
    );
  }

  Future<void> removeNote(String id, {bool forceDelete = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (forceDelete) {
        await DB().forceDelete(id);
      } else {
        await DB().deleteNote(id);
      }
      return _fetchNotes();
    });
  }

  Future<void> restoreNote(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await DB().restoreNote(id);
      return _fetchNotes();
    });
  }
}

final noteProvider = AsyncNotifierProvider<AsyncNotes, List<Note>>(
  () => AsyncNotes(),
);
