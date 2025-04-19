import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    // Apply increased weight to all standard styles
    final heavierTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w600),
      displayMedium: baseTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
      displaySmall: baseTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: baseTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      labelMedium: baseTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      labelSmall: baseTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
    );

    return MaterialApp(
      title: 'bunkr',
      theme: ThemeData(
        textTheme: heavierTextTheme,
      ),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
