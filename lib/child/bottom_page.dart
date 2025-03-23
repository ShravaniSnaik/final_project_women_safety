import 'package:flutter/material.dart';
import 'package:flutter_application_2/child/bottom_screen/chat_page.dart';
import 'package:flutter_application_2/child/bottom_screen/home.dart';
import 'package:flutter_application_2/child/bottom_screen/map_page.dart';
import 'package:flutter_application_2/child/bottom_screen/profile_page.dart';
import 'package:flutter_application_2/child/bottom_screen/review_page.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  // const MyWidget({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomePage(),
  //  AddContactsPage(),
    ChatPage(),
    DangerMapPage(),
    ReviewPage(),
    ProfilePage(),
  ];

  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(label: 'home', icon: Icon(Icons.home)),
          // BottomNavigationBarItem(
          //   label: 'contacts',
          //   icon: Icon(Icons.contacts),
          // ),
          BottomNavigationBarItem(label: 'chats', icon: Icon(Icons.chat)),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(label: 'Reviews', icon: Icon(Icons.reviews)),
          BottomNavigationBarItem(label: 'profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
