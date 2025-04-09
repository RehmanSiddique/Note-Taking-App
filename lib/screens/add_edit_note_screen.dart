// lib/screens/add_edit_note_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _appBarTitle;
  late String _heroTag;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null;
    _appBarTitle = _isEditing ? 'Edit Note' : 'Add Note';
    _heroTag =
        'note_hero_${widget.note?.id ?? 'new'}'; // Use existing or 'new' tag

    _titleController =
        TextEditingController(text: _isEditing ? widget.note!.title : '');
    _contentController =
        TextEditingController(text: _isEditing ? widget.note!.content : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    // Optional: Add form validation
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final title = _titleController.text;
    final content = _contentController.text;
    final noteProvider = context.read<NoteProvider>();

    if (_isEditing) {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
      );
      noteProvider.updateNote(updatedNote);
    } else {
      noteProvider.addNote(title, content);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Hero(
      tag: _heroTag, // Match the tag from NoteCard or use 'new'
      // Wrap with Material for smooth transition of shape/color
      child: Material(
        type: MaterialType.transparency, // Avoid double background
        child: Scaffold(
          appBar: AppBar(
            title: Text(_appBarTitle),
            // AppBar theme is applied from main.dart
            leading: IconButton(
              // Explicit back button for clarity
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            ),
            actions: [
              // Animated Save Button (Optional subtle animation)
              TweenAnimationBuilder<double>(
                tween: Tween(
                    begin: 1.0,
                    end: (_titleController.text.isNotEmpty ||
                            _contentController.text.isNotEmpty)
                        ? 1.0
                        : 0.7),
                duration: const Duration(milliseconds: 200),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: IconButton(
                      icon: const Icon(Icons.save_outlined),
                      tooltip: 'Save Note',
                      onPressed: _saveNote,
                      // Fade slightly if no content?
                      color: (_titleController.text.isNotEmpty ||
                              _contentController.text.isNotEmpty)
                          ? null // Default color
                          : theme.appBarTheme.foregroundColor?.withOpacity(0.0),
                    ),
                  );
                },
              ),
               
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter note title...',
                    ),
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.colorScheme.onSurface),
                    textInputAction: TextInputAction.next,
                    // Rebuild save button appearance on change
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        // Remove label if you prefer just hint
                        // labelText: 'Content',
                        hintText: 'Start writing your note here...',
                        alignLabelWithHint: true,
                        // Use border defined in theme, but remove underline maybe
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        // Use filled=false if you want transparent bg
                        // filled: false,
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5, // More line spacing for content
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      // Rebuild save button appearance on change
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
