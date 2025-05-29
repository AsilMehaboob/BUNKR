import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './services/auth_service.dart'; 
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService(); 
  await authService.init(); 

  final String? token = await authService.getToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(ShadAppWrapper(isLoggedIn: isLoggedIn));
}

/// Wraps your app inside [ShadApp.custom] and applies the custom [ShadTheme].
class ShadAppWrapper extends StatelessWidget {
  final bool isLoggedIn;
  const ShadAppWrapper({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: ShadColorScheme.fromName('neutral', brightness: Brightness.dark),
    ),
      appBuilder: (context) {
        return MaterialApp(
          title: 'bunkr',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: _buildTextTheme(context),
          ),
          builder: (context, child) {
            return ShadAppBuilder(child: child!); // Important to inject Shad theme
          },
          home: isLoggedIn ? HomeScreen() : const LoginScreen(),
          routes: {
            '/home': (context) => HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/profile': (context) => ProfileScreen(),
          },
        );
      },
    );
  }

  TextTheme _buildTextTheme(BuildContext context) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return baseTextTheme.copyWith(
      displayLarge: const TextStyle(fontFamily: 'Klick'),
      displayMedium: const TextStyle(fontFamily: 'Klick'),
      displaySmall: const TextStyle(fontFamily: 'Klick'),
      headlineLarge: const TextStyle(fontFamily: 'Klick'),
      headlineMedium: const TextStyle(fontFamily: 'Klick'),
      headlineSmall: const TextStyle(fontFamily: 'Klick'),
      titleLarge: const TextStyle(fontFamily: 'Klick'),
      titleMedium: const TextStyle(fontFamily: 'Klick'),
      titleSmall: const TextStyle(fontFamily: 'Klick'),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      labelMedium: baseTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      labelSmall: baseTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
