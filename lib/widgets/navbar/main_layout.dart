import 'package:flutter/material.dart';
import 'main_navigation_bar.dart';
import '../../screens/home_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/alerts_screen.dart';
import '../../screens/calendar_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentPageIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AlertsScreen(),
    const CalendarScreen(),
    ProfileScreen(),
  ];

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
}}