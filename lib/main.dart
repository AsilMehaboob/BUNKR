import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './services/auth_service.dart';
import 'screens/login_screen.dart';
import 'widgets/navbar/main_layout.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import './services/config_service.dart';
import './services/settings_service.dart';
import './services/notification_service.dart';
import './services/tracking_service.dart';
import './helpers/push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigService.init();
  await PushNotificationService.initialize();
  await NotificationService.initialize();

  final authService = AuthService();
  await authService.init();
  
  final settingsService = SettingsService();
  await settingsService.loadSettings();

  final trackingService = TrackingService(
    baseUrl: 'https://qsjknoryykjilolbhxos.supabase.co/functions/v1',
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<SettingsService>.value(value: settingsService),
        Provider<TrackingService>.value(value: trackingService),
      ],
      child: const RootApp(),
    ),
  );
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

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
          title: 'Bunkr',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "Manrope"),
          home: const AuthWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<String?>(
      future: authService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoggedIn = snapshot.hasData && snapshot.data != null;
        final settingsService = Provider.of<SettingsService>(context, listen: false);
        return isLoggedIn ? MainLayout(settingsService: settingsService) : const LoginScreen();
      },
    );
  }
}