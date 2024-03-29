import 'package:flutter/material.dart';
import 'package:nubida_front/widgets/bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("Back"))),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}
