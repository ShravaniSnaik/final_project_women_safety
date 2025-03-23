import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/child/bottom_screen/map_page.dart';
import 'package:flutter_application_2/child/bottom_screen/profile_page.dart';
import 'package:flutter_application_2/child/bottom_screen/review_page.dart';
import 'package:flutter_application_2/child/child_login_screen.dart';
import 'package:flutter_application_2/utils/constants.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF43061E)),
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          _buildDrawerItem(context, Icons.person, "Profile", ProfilePage()),
          _buildDrawerItem(context, Icons.rate_review, "Reviews", ReviewPage()),
          _buildDrawerItem(context, Icons.map, "Maps", DangerMapPage()),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              goTo(context, LoginScreen());
            },
          ),
        ],
      ),
    );
  }

  /// **Reusable Drawer Item Function**
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close drawer before navigating
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}