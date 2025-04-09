import 'package:flutter/material.dart';
import '../models/note.dart';
// import 'package:intl/intl.dart'; // For better date formatting if needed

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardTheme.color ?? colorScheme.surface;
    final subtleTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7);
    final defaultIconColor = colorScheme.onSurfaceVariant.withOpacity(0.8);

    // Hero requires a Material ancestor for shape/elevation animations during flight
    return Hero(
      tag: 'note_hero_${note.id}', // Unique tag for the Hero animation
      // Use a Material widget as the child for smoother transitions
      child: Material(
        type: MaterialType.transparency, // Avoid double background colors
        child: Card(
          // Use CardTheme defined in main.dart
          clipBehavior:
              Clip.antiAlias, // Ensures inkwell respects border radius
          child: InkWell(
            onTap: onTap,
            splashColor: colorScheme.primary.withOpacity(0.1),
            highlightColor: colorScheme.primary.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  16.0, 16.0, 8.0, 8.0), // Adjust padding slightly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Note Title ---
                  if (note.title.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0), // Padding for title near icons
                      child: Text(
                        note.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                  // --- Note Content ---
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0), // Padding for content near icons
                      child: Text(
                        note.content.isEmpty && note.title.isEmpty
                            ? '(Empty Note)'
                            : note.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: note.content.isEmpty && note.title.isEmpty
                              ? subtleTextColor
                              : colorScheme.onSurfaceVariant,
                          height: 1.4, // Improve line spacing
                        ),
                        maxLines: 8, // Adjust as needed for grid density
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // --- Footer Row ---
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          // DateFormat.yMMMd().format(note.createdDate), // Use intl for better format
                          '${note.createdDate.day}/${note.createdDate.month}/${note.createdDate.year}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: subtleTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEditPressed != null)
                        _buildActionButton(
                          context: context,
                          icon: Icons.edit_outlined,
                          tooltip: 'Edit',
                          onPressed: onEditPressed!,
                          color: defaultIconColor,
                        ),
                      if (onDeletePressed != null)
                        _buildActionButton(
                          context: context,
                          icon: Icons.delete_outline,
                          tooltip: 'Delete',
                          onPressed: onDeletePressed!,
                          color: colorScheme.error.withOpacity(0.8),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 20.0,
      tooltip: tooltip,
      onPressed: onPressed,
      color: color ?? Theme.of(context).iconTheme.color?.withOpacity(0.7),
      splashRadius: 20.0,
      padding: const EdgeInsets.all(6.0), // Slightly tighter padding
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
    );
  }
}
