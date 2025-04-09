import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_screen.dart';
import '../models/note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notes = noteProvider.notes;
    final theme = Theme.of(context);

    return Scaffold(
      // Use Scaffold background from theme
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true, // Center title for a clean look
        // Theme applied from main.dart
      ),
      body: notes.isEmpty
          ? _buildEmptyView(context)
          : _buildNotesGrid(context, notes),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditScreen(context), // Add new note
        tooltip: 'Add Note',
        child: const Icon(Icons.add_rounded, size: 28),
        // Theme applied from main.dart
      ),
    );
  }

  // --- Empty State Widget ---
  Widget _buildEmptyView(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 70,
            color: theme.colorScheme.secondary
                .withOpacity(0.6), // Use accent color subtly
          ),
          const SizedBox(height: 20),
          Text(
            'No Notes Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first note.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- Notes Grid Widget ---
  Widget _buildNotesGrid(BuildContext context, List<Note> notes) {
    return AnimationLimiter(
      child: MasonryGridView.count(
        padding: const EdgeInsets.fromLTRB(
            12.0, 16.0, 12.0, 80.0), // Padding bottom for FAB
        crossAxisCount: 2, // Adjust based on screen size if needed
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 450), // Animation duration
            columnCount: 2,
            child: SlideAnimation(
              // Slide in from bottom
              verticalOffset: 50.0,
              curve: Curves.easeInOutQuart, // Smoother curve
              child: FadeInAnimation(
                // Fade in as it slides
                curve: Curves.easeIn,
                child: _buildNoteCardItem(context, note),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Note Card Item Helper ---
  Widget _buildNoteCardItem(BuildContext context, Note note) {
    return NoteCard(
      note: note,
      onTap: () => _navigateToEditScreen(context, note: note),
      onEditPressed: () => _navigateToEditScreen(context, note: note),
      onDeletePressed: () => _showDeleteConfirmationDialog(context, note),
    );
  }

  // --- Navigation Helper (Using PageRouteBuilder for Hero) ---

  void _navigateToEditScreen(BuildContext context, {Note? note}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        // The Hero animation handles the primary visual transition
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddEditNoteScreen(note: note),
        // Use fade for elements NOT part of the Hero (like AppBar)
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration:
            const Duration(milliseconds: 350), // Control duration
      ),
    );
  }

  // --- Delete Confirmation Dialog Helper ---
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Note note) async {
    final theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Use theme's dialog shape
          title: const Text('Delete Note?'),
          content: Text(
            'Are you sure you want to permanently delete "${note.title.isNotEmpty ? note.title : 'this note'}"?',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'), // Uses theme's TextButton style
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            // Use FilledButton for destructive action, style from theme
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.error, // Error color for delete
                foregroundColor: theme.colorScheme.onError,
              ),
              child: const Text('Delete'),
              onPressed: () {
                context.read<NoteProvider>().deleteNote(note.id);
                Navigator.of(dialogContext).pop();
                _showDeletionSnackbar(context, note);
              },
            ),
          ],
        );
      },
    );
  }

  // --- Deletion Snackbar Helper ---
  void _showDeletionSnackbar(BuildContext context, Note note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Note "${note.title.isNotEmpty ? note.title : 'Untitled Note'}" deleted.'),
        // Style from theme
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
