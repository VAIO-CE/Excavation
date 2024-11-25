import 'package:excavator/components/bottom_navbar.dart';
import 'package:excavator/pages/controller_change_page.dart';
import 'package:excavator/pages/firmware_update_page.dart';
import 'package:excavator/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyAppInstance extends StatefulWidget {
  const MyAppInstance({super.key});

  @override
  State<MyAppInstance> createState() => _MyAppInstanceState();
}

class _MyAppInstanceState extends State<MyAppInstance> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyHomePage(),
    MyControllerChangePage(),
    MyFirmwarePage(),
  ];

  void navigateBottomBar(int menuIndex) {
    setState(() {
      _selectedIndex = menuIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
