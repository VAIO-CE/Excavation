import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:go_router/go_router.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade600,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade200,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        onTabChange: (value) {
          onTabChange!(value);
          // switch (value) {
          //   case 0:
          //     context.go('/');
          //     break;
          //   case 1:
          //     context.go('/controller');
          //     break;
          //   case 2:
          //     context.go('/firmware');
          //     break;
          // }
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.sports_esports,
            text: "Gamepad",
          ),
          GButton(
            icon: Icons.upgrade,
            text: "Firmware",
          ),
        ],
      ),
    );
  }
}
