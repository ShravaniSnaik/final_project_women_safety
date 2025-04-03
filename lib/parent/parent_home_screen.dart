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
        backgroundColor: const Color(0xFF43061E),
        title: const Text(
          'Select Child',
          style: TextStyle(
            color: Color(0xFFECE1EE),
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF43061E)),
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          _buildDrawerItem(Icons.person, "Profile", () {
            _navigateToPage(context, const ProfilePage1());
          }),
          _buildDrawerItem(Icons.rate_review, "Reviews", () {
            _navigateToPage(context, const ReviewPage1());
          }),
          _buildDrawerItem(Icons.map, "Maps", () {
            _navigateToPage(context, const DangerMapPage1());
          }),
          _buildDrawerItem(Icons.logout, "Sign Out", () async {
            await FirebaseAuth.instance.signOut();
            goTo(context, const LoginScreen());
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon,color: Colors.white,),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildBody() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      return const Center(child: Text("Error: User not logged in"));
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/chat-page1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .where('type', isEqualTo: 'child')
                .where('guardianEmail', isEqualTo: currentUser.email)
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: progressIndicator(context));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No children assigned to this guardian."),
            );
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

  Widget _buildChildTile(QueryDocumentSnapshot d) {
    final childName = d['name'] ?? 'Unknown';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color(0xFF9F80A7),
        child: ListTile(
          onTap: () {
            goTo(
              context,
              ChatScreen(
                currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
                friendId: d.id,
                friendName: childName,
              ),
            );
          },
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              childName,
              style: const TextStyle(
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}