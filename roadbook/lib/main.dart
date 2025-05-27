import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rally Roadbook',
      navigatorKey: navigatorKey,
      home: const StartScreen(),
    );
  }
}
