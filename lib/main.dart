import 'package:flutter/material.dart';
import 'package:nubida_front/screens/home_screen.dart';
import 'package:nubida_front/screens/login_screen.dart';
import 'package:nubida_front/screens/mypage_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginForm(),
        "/home": (context) => const HomeScreen(),
        "/mypage": (context) => const Mypage()
      },
      home: const LoginForm(),
    );
  }
}
