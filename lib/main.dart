import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

import 'features/home/presentation/provider/photo_provider.dart';
import 'features/home/presentation/provider/search_provider.dart';
import 'features/home/presentation/provider/saved_provider.dart';
import 'features/home/presentation/screens/main_shell_screen.dart';

void main() {
  runApp(
    ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: 'pk_test_c3RpbGwtcmFtLTY3LmNsZXJrLmFjY291bnRzLmRldiQ',
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PhotoProvider()..fetchInitialPhotos(),
        ),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ClerkAuthBuilder(
          builder: (context, authState) {

            if (authState.session != null) {
              return const MainShellScreen();
            }

            return const Scaffold(
              body: SafeArea(
                child: ClerkAuthentication(),
              ),
            );
          },
        ),
      ),
    );
  }
}