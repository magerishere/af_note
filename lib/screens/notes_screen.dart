import 'package:af_note/providers/theme_provider.dart';
import 'package:af_note/screens/add_note_screen.dart';
import 'package:af_note/widgets/notes/notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  void _goToAddNoteScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddNoteScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeProvider);
    Widget toggleModeIcon = const Icon(Icons.sunny);
    if (appThemeMode == Brightness.light.index) {
      toggleModeIcon = const Icon(Icons.shield_moon);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes list'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).toggleMode();
            },
            icon: toggleModeIcon,
          ),
          IconButton(
            onPressed: () {
              _goToAddNoteScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const NotesList(),
    );
  }
}
