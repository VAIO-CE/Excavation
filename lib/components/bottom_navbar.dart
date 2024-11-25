import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade600,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        onTabChange: (index) {},
        tabs: const [
          GButton(
            icon: Icons.mode,
            text: "Mode",
          ),
          GButton(
            icon: Icons.gamepad,
            text: "DualShock",
          ),
          GButton(
            icon: Icons.upgrade,
            text: "Firmware OTA",
          ),
        ],
      ),
    );
  }
}
