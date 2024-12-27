import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensures text is always visible
      currentIndex: selectedTabIndex,
      onTap: onTabSelected,
      backgroundColor: Colors.white,
      items: const [
        // "Connects" Tab (Only one with color)
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Connects',
        ),
        // "Dialpad" Tab (No color)
        BottomNavigationBarItem(
          icon: Icon(Icons.dialpad),
          label: 'Dialpad',
        ),
        // "Reachouts" Tab (No color)
        BottomNavigationBarItem(
          icon: Icon(Icons.send),
          label: 'Reachouts',
        ),
        // "Profile" Tab (No color)
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: selectedTabIndex == 0
          ? const Color(0xFF5864F8)
          : Colors.grey, // Only color "Connects" tab
      unselectedItemColor: Colors.grey, // Grey color for all unselected tabs
    );
  }
}
