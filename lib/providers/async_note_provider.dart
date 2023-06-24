import 'dart:async';
import 'dart:convert';

import 'package:af_note/enums/note_status.dart';
import 'package:af_note/helpers/db.dart';
import 'package:af_note/helpers/http.dart';
import 'package:af_note/helpers/prefs.dart';
import 'package:af_note/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncNotes extends AsyncNotifier<List<Note>> {
  AsyncNotes();

  Future<List<Note>> _fetchNotes() async {
    final isRecoveredDatabase =
        await Prefs().getRecoveryOldDataInSqfliteToNewDatabaseMySql();
    if (!isRecoveredDatabase) {
      final oldNotes = await DB().allNotes();

      for (final oldNote in oldNotes) {
        await Http('notes').withBody({
          'content': oldNote['text'],
        }).post();
      }
      await Prefs().setRecoveryOldDataInSqfliteToNewDatabaseMySql(true);
    }
    final response = await Http('notes').get();
    final List<dynamic> resData = jsonDecode(response.body)['data'];
    return resData.map((item) => Note.fromJson(item)).toList();
  }

  @override
  FutureOr<List<Note>> build() {
    return _fetchNotes();
  }

  Future<void> addNote(String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await Http('notes').withBody({
          'content': text,
        }).post();
        return _fetchNotes();
      },
    );
  }

  Future<void> updateNote(int id, String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Http('notes/$id').withBody({
        'content': text,
      }).patch();
      return _fetchNotes();
    });
  }

  Future<void> updateNoteStatus(int id, NoteStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Http('notes/$id').withBody({
        "status": status.name,
      }).patch();
      return _fetchNotes();
    });
  }

  Future<void> removeNote(int id, {bool forceDelete = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (forceDelete) {
        await Http('notes/trashed/$id').delete();
      } else {
        await Http('notes/$id').delete();
      }
      return _fetchNotes();
    });
  }

  Future<void> restoreNote(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Http('notes/trashed/$id').patch();
      return _fetchNotes();
    });
  }
}

final asyncNoteProvider = AsyncNotifierProvider<AsyncNotes, List<Note>>(
  () => AsyncNotes(),
);
