// lib/providers/note_provider.dart
import 'package:flutter/material.dart';
import 'dart:collection';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [
    // Some rich sample data
    Note(
      title: 'Meeting Prep',
      content:
          'Review project proposal slides.\nPrepare Q&A points.\nConfirm attendees.',
      createdDate: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Note(
      title: 'Grocery List',
      content:
          '- Avocados\n- Sourdough Bread\n- Olive Oil\n- Salmon Fillets\n- Dark Chocolate',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Note(
      title: 'Book Ideas',
      content:
          'Explore themes of time travel paradoxes. Character arc for protagonist needs strengthening.',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Note(
      title: 'Workout Plan',
      content:
          'Monday: Chest & Triceps\nWednesday: Back & Biceps\nFriday: Legs & Shoulders\nFocus on compound lifts.',
      createdDate: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes
    ..sort((a, b) =>
        b.createdDate.compareTo(a.createdDate))); // Sort by date descending

  void addNote(String title, String content) {
    final newNote = Note(
      title: title.isEmpty ? 'Untitled Note' : title,
      content: content,
      createdDate: DateTime.now(),
    );
    _notes.add(newNote);
    notifyListeners();
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote.copyWith(
          title:
              updatedNote.title.isEmpty ? 'Untitled Note' : updatedNote.title);
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Note? findById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }
}
