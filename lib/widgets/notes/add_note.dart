import 'package:af_note/models/note.dart';
import 'package:af_note/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNote extends ConsumerStatefulWidget {
  const AddNote({super.key, this.note});

  final Note? note;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddNote();
  }
}

class _AddNote extends ConsumerState<AddNote> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredNote;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _enteredNote = widget.note!.text;
    }
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (widget.note == null) {
      ref.read(noteProvider.notifier).addNote(_enteredNote!);
    } else {
      ref
          .read(noteProvider.notifier)
          .updateNote(widget.note!.id, _enteredNote!);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Add your note',
              ),
              initialValue: _enteredNote,
              autofocus: true,
              onSaved: (newValue) {
                _enteredNote = newValue!.trim();
              },
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  return null;
                }

                return 'this field is required';
              },
            ),
            const SizedBox(
              height: 26,
            ),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
