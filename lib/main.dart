import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './services/auth_service.dart'; 
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService(); 
  await authService.init(); 


  final String? token = await authService.getToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

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
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : const LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
