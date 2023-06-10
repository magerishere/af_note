import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Note {
  Note(this.text, {String? id}) : id = id ?? _uuid.v4();

  final String id;
  final String text;

  factory Note.fromDB(Map<String, Object?> note) {
    return Note(note['text'] as String, id: note['id'] as String);
  }
}
