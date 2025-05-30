import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A bottom navigation bar with 4 tabs: Home, Alerts, Calendar, and Account.
class MainNavigationBar extends StatelessWidget {
  /// Current selected index of the navigation bar.
  final int currentIndex;
  
  /// Callback function when a navigation item is selected.
  final ValueChanged<int> onDestinationSelected;

  /// Creates a [MainNavigationBar] with the required parameters.
  const MainNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(color: Colors.white, fontSize: 13.0);
                }
                return const TextStyle(color: Colors.white60, fontSize: 13.0);
              }),
              iconTheme: MaterialStateProperty.all(
                const IconThemeData(color: Colors.white),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              height: 64,
              // Control the splash/ripple effect colors
              indicatorColor: Colors.white.withOpacity(0.15),
              // Add these properties to control tap effects
              surfaceTintColor: Colors.transparent,
            ),
            splashColor: Colors.transparent, // Remove splash globally
            highlightColor: Colors.transparent, // Remove highlight globally
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            height: 64,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: Colors.black,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            indicatorColor: Colors.white.withOpacity(0.15),
            // Control animation speed
            animationDuration: const Duration(milliseconds: 250),
            // No splashBehavior parameter in this Flutter version
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.home, color: Colors.white60, size: 21),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.home, color: Colors.white, size: 21),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.calendar, color: Colors.white60, size: 21),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.calendar, color: Colors.white, size: 21),
                ),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.bell, color: Colors.white60, size: 21),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.bell, color: Colors.white, size: 21),
                ),
                label: 'Alerts',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.user, color: Colors.white60, size: 21),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.user, color: Colors.white, size: 21),
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}