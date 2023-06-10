import 'package:af_note/models/note.dart';
import 'package:af_note/screens/add_note_screen.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note, required this.onDelete});

  final Note note;
  final void Function(String id) onDelete;

  void _goToEditNoteScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddNoteScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.black),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.error,
              Theme.of(context).colorScheme.onError,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: const Alignment(0.75, 0),
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      key: ValueKey(note.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete(note.id);
        }
        if (direction == DismissDirection.startToEnd) {
          print('start');
        }
      },
      child: Card(
        child: ListTile(
          onTap: () {
            _goToEditNoteScreen(context);
          },
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            note.text,
          ),
        ),
      ),
    );
  }
}
