import 'package:flutter/material.dart';
import 'main_navigation_bar.dart';
import '../../screens/home_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/alerts_screen.dart';
import '../../screens/calendar_screen.dart';
import '../../services/settings_service.dart';
import '../../screens/tracking_screen.dart';

class MainLayout extends StatefulWidget {
  final SettingsService settingsService;

  const MainLayout({super.key, required this.settingsService});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentPageIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(settingsService: widget.settingsService),
      const AlertsScreen(),
      const TrackingScreen(),
      const CalendarScreen(),
      ProfileScreen(settingsService: widget.settingsService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: _screens,
      ),
      bottomNavigationBar: MainNavigationBar(
        currentIndex: _currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
