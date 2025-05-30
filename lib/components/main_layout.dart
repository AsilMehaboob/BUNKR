import 'package:flutter/material.dart';
import '../components/main_navigation_bar.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/calendar_screen.dart';

/// Main layout that contains the bottom navigation bar and displays the appropriate screen.
class MainLayout extends StatefulWidget {
  /// Creates a [MainLayout] widget.
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentPageIndex = 0;

  // Fix: Remove const from ProfileScreen if it doesn't have a const constructor
  final List<Widget> _screens = [
    const HomeScreen(),
    const AlertsScreen(),
    const CalendarScreen(),
    ProfileScreen(), // Removed const since it doesn't have a const constructor
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentPageIndex],
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