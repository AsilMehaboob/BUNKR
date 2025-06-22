import 'package:flutter/material.dart';
import './services/auth_service.dart';
import 'screens/login_screen.dart';
import 'widgets/navbar/main_layout.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import './services/config_service.dart';
import './services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigService.init();

  final settingsService = SettingsService();

  final authService = AuthService();
  await authService.init();

  final String? token = await authService.getToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(ShadAppWrapper(
    isLoggedIn: isLoggedIn,
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
