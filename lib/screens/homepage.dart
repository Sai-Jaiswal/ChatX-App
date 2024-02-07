import 'package:chatx/screens/archived_page.dart';
import 'package:chatx/screens/messages_page.dart';
import 'package:chatx/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homepage extends StatefulWidget {

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> pages = [
    const MessagePage(),
    const ArchivedPage(),
    const ProfilePage()
  ];

  late int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        color: Colors.purple,
        items: [
          Icon(Icons.home, color: Colors.white, size: 26,),
          Icon(Icons.archive_outlined, color: Colors.white, size: 26,),
          Icon(Icons.account_circle_outlined, color: Colors.white, size: 26,)
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        index: 0,
      ),
    );
  }
}
