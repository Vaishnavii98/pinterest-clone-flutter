import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/home/presentation/screens/main_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShellScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ClipOval(
          child: Image.asset(
            "lib/assets/images/pinterest_logo.jpeg",
            width: 120,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}