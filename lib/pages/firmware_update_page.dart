import 'package:excavator/components/bottom_navbar.dart';
import 'package:flutter/material.dart';

class MyFirmwarePage extends StatefulWidget {
  const MyFirmwarePage({super.key});

  @override
  State<MyFirmwarePage> createState() => _MyFirmwarePage();
}

class _MyFirmwarePage extends State<MyFirmwarePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("This is Firmware Page!"),
        ),
      ),
    );
  }
}
