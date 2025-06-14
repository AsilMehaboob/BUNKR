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
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2), // Subtle top border
            width: 1.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.5),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(
                    color: Colors.white, 
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600, // Semi-bold for selected
                  );
                }
                return const TextStyle(
                  color: Colors.white60, 
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600, // Semi-bold for unselected
                );
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
            indicatorColor: Colors.white.withOpacity(0.2),
            // Control animation speed
            animationDuration: const Duration(milliseconds: 300),
            // No splashBehavior parameter in this Flutter version
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.home, color: Colors.white60, size: 20),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.home, color: Colors.white, size: 20),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.bell, color: Colors.white60, size: 20),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.bell, color: Colors.white, size: 20),
                ),
                label: 'Alerts',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.calendar, color: Colors.white60, size: 20),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.calendar, color: Colors.white, size: 20),
                ),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.user, color: Colors.white60, size: 20),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5),
                  child: Icon(LucideIcons.user, color: Colors.white, size: 20),
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
