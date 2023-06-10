import 'package:af_note/models/note.dart';
import 'package:af_note/widgets/notes/add_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNoteScreen extends ConsumerWidget {
  const AddNoteScreen({super.key, this.note});
  final Note? note;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note'),
      ),
      body: AddNote(
        note: note,
      ),
    );
  }
}
