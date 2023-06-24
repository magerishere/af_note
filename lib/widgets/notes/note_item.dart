import 'package:af_note/enums/note_status.dart';
import 'package:af_note/models/note.dart';
import 'package:af_note/screens/add_note_screen.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onAddTo,
  });

  final Note note;
  final void Function(int id) onDelete;
  final void Function(int id, NoteStatus status) onAddTo;

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
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.onPrimary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: const Alignment(-0.75, 0),
        child: Icon(
          note.isActive ? Icons.archive : Icons.folder,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
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
          onAddTo(
              note.id, note.isActive ? NoteStatus.archive : NoteStatus.active);
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
