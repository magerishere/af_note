import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Note {
  Note(this.id, this.text);

  final int id;
  final String text;

  factory Note.fromJson(Map<String, dynamic> data) {
    return Note(data['id'], data['content']);
  }
}
