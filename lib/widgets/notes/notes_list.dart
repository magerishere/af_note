import 'package:af_note/providers/note_provider.dart';
import 'package:af_note/widgets/notes/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void restoreNote(int id) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ref.read(noteProvider.notifier).restoreNote(id);
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
        ref.read(noteProvider.notifier).removeNote(id, forceDelete: true);
      });
      ref.read(noteProvider.notifier).removeNote(id);
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

    final asyncNotes = ref.watch(noteProvider);
    return asyncNotes.when(
      data: (notes) {
        return notes.isEmpty
            ? const Center(
                child: Text('You have no notes yet, add new one'),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteItem(
                  note: notes[index],
                  onDelete: (id) => deleteNote(id),
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
