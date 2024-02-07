import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      if (auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, "/");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
      // Navigator.pushReplacementNamed(context, "/login");
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/images/app_logo.png",
                width: 100,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "ChatX",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
