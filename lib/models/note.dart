import 'package:af_note/enums/note_status.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Note {
  Note(this.id, this.text, {required this.status});

  final int id;
  final String text;
  final NoteStatus status;

  factory Note.fromJson(Map<String, dynamic> data) {
    final NoteStatus status = data['status'] == NoteStatus.active.name
        ? NoteStatus.active
        : NoteStatus.archive;
    return Note(data['id'], data['content'], status: status);
  }

  bool get isActive {
    return status == NoteStatus.active;
  }
}
