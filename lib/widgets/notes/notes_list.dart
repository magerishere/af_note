import 'package:af_note/enums/note_status.dart';
import 'package:af_note/models/note.dart';
import 'package:af_note/providers/async_note_provider.dart';
import 'package:af_note/widgets/notes/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesList extends ConsumerWidget {
  const NotesList(this.status, {super.key});

  final NoteStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void restoreNote(int id) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ref.read(asyncNoteProvider.notifier).restoreNote(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note item was restored'),
        ),
      );
    }

    void deleteNote(int id) {
      final forceDeleteFuture = Future.delayed(
        const Duration(seconds: 5),
      );
      final forceDeleteAction = forceDeleteFuture.asStream().listen((event) {
        ref.read(asyncNoteProvider.notifier).removeNote(id, forceDelete: true);
      });
      ref.read(asyncNoteProvider.notifier).removeNote(id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note was removed'),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Theme.of(context).colorScheme.background,
            onPressed: () {
              forceDeleteAction.cancel();
              restoreNote(id);
            },
          ),
        ),
      );
    }

    void addTo(int id, NoteStatus status) {
      ref.read(asyncNoteProvider.notifier).updateNoteStatus(
            id,
            status,
          );
      ScaffoldMessenger.of(context).clearSnackBars();

      if (status == NoteStatus.archive) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Note archived.'),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Theme.of(context).colorScheme.background,
              onPressed: () {
                addTo(id, NoteStatus.active);
              },
            ),
          ),
        );
        return;
      }
      // active -> undo archived
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note in activate notes.'),
        ),
      );
    }

    final asyncNotes = ref.watch(asyncNoteProvider);
    return asyncNotes.when(
      data: (notes) {
        final List<Note> filteredNotes =
            notes.where((note) => note.status == status).toList();
        return filteredNotes.isEmpty
            ? const Center(
                child: Text('You have no notes yet, add new one'),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) => NoteItem(
                  note: filteredNotes[index],
                  onDelete: (id) => deleteNote(id),
                  onAddTo: (id, status) => addTo(id, status),
                ),
              );
      },
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
