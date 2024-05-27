import 'package:flutter/material.dart';
import 'package:nubida_front/screens/home_screen.dart';
import 'package:nubida_front/screens/mypage_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;
  String role = '';

  Future<String> getUserRole() async {
    const storage = FlutterSecureStorage();
    String? role = await storage.read(key: 'role');

    if (role != null) {
      return role;
    } else {
      return '';
    }
  }

  Future<void> initUser() async {
    String curUser = await getUserRole();
    setState(() {
      role = curUser;
    });
  }

  Future<void> setPage() async {
    const storage = FlutterSecureStorage();
    String? page = await storage.read(key: 'page');
    if (page != null) {
      setState(() {
        selectedIndex = int.parse(page);
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    initUser();
    setPage();
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const Mypage(),
  ];

  void onItemTapped(int idx) {
    setState(() {
      selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: (role == 'ROLE_ADMIN') ? '관리자페이지' : '마이페이지',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: onItemTapped,
      ),
    );
  }
}
