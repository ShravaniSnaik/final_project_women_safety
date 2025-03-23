import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/chat_module/chat_screen.dart';

import 'package:flutter_application_2/child/child_login_screen.dart';
import 'package:flutter_application_2/parent/map_page1.dart';
import 'package:flutter_application_2/parent/profile_page1.dart';
import 'package:flutter_application_2/parent/review_page1.dart';
import 'package:flutter_application_2/utils/constants.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF43061E),
        title: Text(
          'Select Guardian',
          style: TextStyle(
            color: Color(0xFFECE1EE),
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      drawer: _buildDrawer(context), // Static Drawer
      body: _buildBody(),
    );
  }

  /// **Drawer Widget**
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF43061E)),
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          _buildDrawerItem(Icons.person, "Profile", () {
            _navigateToPage(context, ProfilePage1());
          }),
          _buildDrawerItem(Icons.rate_review, "Reviews", () {
            _navigateToPage(context, ReviewPage1());
          }),
          _buildDrawerItem(Icons.map, "Maps", () {
            _navigateToPage(context, DangerMapPage1());
          }),
          _buildDrawerItem(Icons.logout, "Sign Out", () async {
            await FirebaseAuth.instance.signOut();
            goTo(context, LoginScreen());
          }),
        ],
      ),
    );
  }

  /// **Reusable Drawer Item**
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close drawer before navigation
        onTap();
      },
    );
  }

  /// **Body Widget (Firestore Stream)**
  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/chat-page1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'child')
            .where('guardianEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: progressIndicator(context));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final d = snapshot.data!.docs[index];
              return _buildChildTile(d);
            },
          );
        },
      ),
    );
  }

  /// **Chat List Tile**
  Widget _buildChildTile(QueryDocumentSnapshot d) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Color(0xFF9F80A7),
        child: ListTile(
          onTap: () {
            goTo(
              context,
              ChatScreen(
                currentUserId: FirebaseAuth.instance.currentUser!.uid,
                friendId: d.id,
                friendName: d['name'],
              ),
            );
          },
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              d['name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w100,
                color: Color(0xFFECE1EE),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **Helper Function: Navigation**
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}