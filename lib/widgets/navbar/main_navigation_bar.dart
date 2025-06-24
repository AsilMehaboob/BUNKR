import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const MainNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              iconTheme: WidgetStateProperty.all(
                const IconThemeData(color: Colors.white),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              height: 56,
              indicatorColor: Colors.transparent, // Remove indicator background
              surfaceTintColor: Colors.transparent,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            height: 56,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: Colors.black,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: Colors.transparent, // Remove indicator background
            animationDuration: const Duration(milliseconds: 300),
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child:
                      Icon(Icons.home_rounded, color: Colors.white60, size: 29),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child:
                      Icon(Icons.home_rounded, color: Colors.white, size: 29),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.notifications_rounded,
                      color: Colors.white60, size: 27),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 27),
                ),
                label: 'Alerts',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.track_changes_rounded,
                      color: Colors.white60, size: 27),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.track_changes_rounded,
                      color: Colors.white, size: 27),
                ),
                label: 'Tracking',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.calendar_month,
                      color: Colors.white60, size: 24),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child:
                      Icon(Icons.calendar_month, color: Colors.white, size: 24),
                ),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.person, color: Colors.white60, size: 30),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
