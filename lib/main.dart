import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/screens/admin_view_country_screen.dart';
import 'package:nubida_front/screens/admin_view_travel_screen.dart';
import 'package:nubida_front/screens/admin_view_traveler_screen.dart';
import 'package:nubida_front/screens/all_review_screen.dart';
import 'package:nubida_front/screens/all_travel_screen.dart';
import 'package:nubida_front/screens/adminpage_screen.dart';
import 'package:nubida_front/screens/home_screen.dart';
import 'package:nubida_front/screens/login_screen.dart';
import 'package:nubida_front/screens/mypage_screen.dart';
import 'package:nubida_front/screens/register_screen.dart';
import 'package:nubida_front/widgets/bottom_bar.dart';
import 'package:nubida_front/screens/travel_create.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Nubida());
}

class Nubida extends StatelessWidget {
  const Nubida({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        dialogBackgroundColor: Colors.white,
      ),
      initialRoute: "/bab",
      routes: {
        "/login": (context) => const LoginForm(),
        "/home": (context) => const HomeScreen(),
        "/mypage": (context) => const Mypage(),
        "/bab": (context) => const BottomBar(),
        "/register": (context) => const RegisterForm(),
        "/adminpage": (context) => const AdminPage(),
        "/createTravel": (context) => const TravelCreate(),
        "/adminTravel": (context) => const AdminViewTravel(),
        "/adminTraveler": (context) => const AdminViewTraveler(),
        "/adminCountry": (context) => const AdminViewCountry(),
        "/allTravel": (context) => const AllTravel(),
        "/allReview": (context) => const AllReview(),
      },
      home: const LoginForm(),
    );
  }
}
