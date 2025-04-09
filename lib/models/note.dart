// lib/models/note.dart
import 'package:uuid/uuid.dart';

const _uuid = Uuid(); // Instance for generating IDs

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdDate;

  Note({
    String? id, // Allow passing ID, generate if null
    required this.title,
    required this.content,
    required this.createdDate,
  }) : id = id ?? _uuid.v4(); // Generate v4 UUID if id is not provided

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdDate,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
