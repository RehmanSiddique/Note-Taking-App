 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // --- Sophisticated Color Palette ---
  static const Color primarySlateBlue = Color(0xFF546E7A); // Muted Blue Grey
  static const Color accentCoral = Color(0xFFFF7F50); // Vibrant Coral
  static const Color lightBg = Color(0xFFECEFF1); // Light Blue Grey Tint
  static const Color lightSurface = Colors.white;
  static const Color darkBg = Color(0xFF263238); // Dark Blue Grey
  static const Color darkSurface = Color(0xFF37474F); // Slightly lighter dark

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pro Notes',
        themeMode: ThemeMode.system,
        theme: _buildTheme(context, Brightness.light),
        darkTheme: _buildTheme(context, Brightness.dark),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context, Brightness brightness) {
    var baseTheme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primarySlateBlue, // Base color for generation
      brightness: brightness,
      // --- Overrides for Specific Palette ---
      primary: primarySlateBlue,
      secondary: accentCoral, // Action/Accent color
      background: brightness == Brightness.dark ? darkBg : lightBg,
      surface: brightness == Brightness.dark ? darkSurface : lightSurface,
      surfaceTint: Colors.transparent, // Disable M3 surface tint if not desired
      onPrimary: Colors.white,
      onSecondary: Colors.white, // Coral is bright enough for white text
      onError: Colors.white,
      error: const Color(0xFFD32F2F), // Standard Material Red
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      // --- Component Themes ---
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface, // Use surface for a flatter look
        foregroundColor: colorScheme.onSurface, // Text color on surface
        elevation: 0.5, // Very subtle elevation
        scrolledUnderElevation: 1.0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600, // Semi-bold
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface.withOpacity(0.8)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary, // Accent color FAB
        foregroundColor: colorScheme.onSecondary,
        elevation: 4.0,
        shape: const CircleBorder(), // Classic circular FAB
      ),
      cardTheme: CardTheme(
        elevation: brightness == Brightness.dark ? 2.0 : 1.5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: colorScheme.surface,
        margin: EdgeInsets.zero, // Grid handles spacing
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.4), // Subtle fill
        hintStyle:
            TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          // Subtle focus border matching primary
          borderSide: BorderSide(
              color: colorScheme.primary.withOpacity(0.7), width: 1.5),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)), // Softer dialog corners
        backgroundColor: colorScheme.surface,
        titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18.0, // Slightly smaller dialog title
            fontWeight: FontWeight.bold),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          // Use primary color for standard filled buttons by default
          // Background/Foreground derived from colorScheme.primary/onPrimary
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          foregroundColor:
              colorScheme.secondary, // Accent color for text buttons
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
            color: colorScheme.onInverseSurface, fontWeight: FontWeight.w500),
        actionTextColor: colorScheme.inversePrimary,
        elevation: 3.0,
        width: MediaQuery.of(context).size.width > 600
            ? 400
            : null, // Responsive width
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      ),
      iconTheme: baseTheme.iconTheme.copyWith(
        color: colorScheme.onSurfaceVariant, // Default icon color
        size: 22.0, // Slightly smaller default icon size
      ),
      // Refine Text Styles
      textTheme: baseTheme.textTheme
          .apply(
            displayColor: colorScheme.onBackground,
            bodyColor: colorScheme.onSurfaceVariant, // Default text color
          )
          .copyWith(
            // Example: Make titles slightly bolder
            titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            // Example: Slightly larger body text
            bodyLarge: baseTheme.textTheme.bodyLarge
                ?.copyWith(fontSize: 16.0, height: 1.5),
            bodyMedium: baseTheme.textTheme.bodyMedium
                ?.copyWith(fontSize: 14.0, height: 1.4),
          ),
    );
  }
}
