import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
        border: Border(
          top: BorderSide(
            color: Colors.white12,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              iconTheme: WidgetStateProperty.all(
                const IconThemeData(color: Colors.white),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              height: 56,
              indicatorColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Stack(
            children: [
              NavigationBar(
                selectedIndex: currentIndex,
                height: 62,
                onDestinationSelected: onDestinationSelected,
                backgroundColor: const Color(0xFF1F1F1F),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                labelTextStyle: WidgetStateProperty.all(
                  const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                indicatorColor: Colors.transparent,
                animationDuration: const Duration(milliseconds: 300),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(LucideIcons.home, color: Colors.white38, size: 20),
                    selectedIcon: Icon(LucideIcons.home, color: Colors.white, size: 20),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.bell, color: Colors.white38, size: 20),
                    selectedIcon: Icon(LucideIcons.bell, color: Colors.white, size: 20),
                    label: 'Alerts',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.target, color: Colors.white38, size: 20),
                    selectedIcon: Icon(LucideIcons.target, color: Colors.white, size: 20),
                    label: 'Tracking',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.calendar, color: Colors.white38, size: 18),
                    selectedIcon: Icon(LucideIcons.calendar, color: Colors.white, size: 18),
                    label: 'Calendar',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.user, color: Colors.white38, size: 20),
                    selectedIcon: Icon(LucideIcons.user, color: Colors.white, size: 20),
                    label: 'Profile',
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      5,
                      (index) => Container(
                        width: MediaQuery.of(context).size.width / 7,
                        height: 2,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
