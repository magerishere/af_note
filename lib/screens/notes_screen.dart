import 'package:af_note/enums/note_status.dart';
import 'package:af_note/providers/theme_provider.dart';
import 'package:af_note/screens/add_note_screen.dart';
import 'package:af_note/widgets/notes/notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NotesScreenState();
  }
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  int _activeTabIndex = 0;

  void _goToAddNoteScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddNoteScreen(),
      ),
    );
  }

  void _setIndexOfActiveTab(int index) {
    setState(() {
      _activeTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: NotesList(
          _activeTabIndex == 0 ? NoteStatus.active : NoteStatus.archive),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Active'),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: 'Archive',
          ),
        ],
        currentIndex: _activeTabIndex,
        onTap: (value) => _setIndexOfActiveTab(value),
      ),
    );
  }
}
