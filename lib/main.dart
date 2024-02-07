import 'package:chatx/screens/auth/login.dart';
import 'package:chatx/screens/auth/sign_up.dart';
import 'package:chatx/screens/chatting_screen.dart';
import 'package:chatx/screens/edit_profile.dart';
import 'package:chatx/screens/profile_page.dart';
import 'package:chatx/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatx/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(144, 24, 209, 1),
      statusBarIconBrightness: Brightness.light));
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const ChatX());
}

class ChatX extends StatelessWidget {
  const ChatX({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatX",
      initialRoute: "/splashScreen",
      routes: {
        "/splashScreen": (context) => const SplashScreen(),
        "/": (context) => Homepage(),
        "/login": (context) => Login(),
        "/sign_up": (context) => SignUp(),
        "/chatting_screen": (context) => const ChattingScreen(),
        "/account": (context) => const ProfilePage(),
        "/edit_profile": (context) => EditProfile(),
      },
    );
  }
}
