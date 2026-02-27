import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/home/presentation/provider/saved_provider.dart';
import 'package:pinterest_clone/features/home/presentation/provider/search_provider.dart';
import 'package:pinterest_clone/features/home/presentation/screens/main_shell_screen.dart';
import 'package:pinterest_clone/features/home/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'features/home/presentation/provider/photo_provider.dart';

void main() {
  runApp(const PinterestCloneApp());
}

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PhotoProvider()..fetchInitialPhotos(),
        ),
        ChangeNotifierProvider(create: (_)=> SearchProvider(),),
        ChangeNotifierProvider(create: (_)=> SavedProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pinterest Clone',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}