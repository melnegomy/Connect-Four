import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const Connect4App());
}

class Connect4App extends StatelessWidget {
  const Connect4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect 4 AI',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const SplashScreen(),
    );
  }
}
