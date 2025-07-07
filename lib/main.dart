import 'package:flutter/material.dart';
import './services/auth_service.dart';
import 'screens/login_screen.dart';
import 'widgets/navbar/main_layout.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import './services/config_service.dart';
import './services/settings_service.dart';
import './services/notification_service.dart';
import './helpers/push_notification.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await ConfigService.init();

  final authService = AuthService();
  await authService.init();


  final String? token = await authService.getToken();
  if (token != null && token.isNotEmpty) {
    try {
      await SupabaseService(authService).fetchUserData({});
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  await PushNotificationService.initialize();
  await NotificationService.initialize();

  final settingsService = SettingsService();

  runApp(ShadAppWrapper(
    isLoggedIn: token != null && token.isNotEmpty,
    settingsService: settingsService,
  ));
}

class ShadAppWrapper extends StatelessWidget {
  final bool isLoggedIn;
  final SettingsService settingsService;

  const ShadAppWrapper({
    super.key,
    required this.isLoggedIn,
    required this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme:
            ShadColorScheme.fromName('neutral', brightness: Brightness.dark),
      ),
      appBuilder: (context) {
        return MaterialApp(
          title: 'Bunkr',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "Manrope"),
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
          home: isLoggedIn
              ? MainLayout(settingsService: settingsService)
              : const LoginScreen(),
          routes: {
            '/home': (context) => MainLayout(settingsService: settingsService),
            '/login': (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}