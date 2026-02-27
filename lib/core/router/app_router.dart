import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainShellScreen(),
    );
  }
}