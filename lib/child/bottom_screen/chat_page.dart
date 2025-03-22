// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_demo/utils/constants.dart';

// class ChatPage extends StatelessWidget {
//   const ChatPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 246, 3, 84),
//         title: Text('Select Guardian'),
//       ),
//       body: StreamBuilder(
//       stream: FirebaseFirestore.instance
//       .collection('users')
//       .where('type',isEqualTo: 'parent')
//       .where('childEmail',isEqualTo: FirebaseAuth.instance.currentUser!.email)
//       .snapshots(),
//        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
//         if(!snapshot.hasData){
//           return Center(child: progressIndicator(context));
//         }
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (BuildContext context, int index){
//                 final d=snapshot.data!.docs[index];
//                 return Padding(padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   color: Color.fromARGB(255,250,163,192),
//                   child: ListTile(
//                     title: Padding(
//                       padding:const EdgeInsets.all(8.0),
//                      child: Text(d['name']),
//                      )
//                   ),
//                 ),);
//               },
//             );
//        }
//        )
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/chat_module/chat_screen.dart';
import 'package:flutter_application_2/utils/constants.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/chat-page1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .where('type', isEqualTo: 'parent')
                  .where(
                    'childEmail',
                    isEqualTo: FirebaseAuth.instance.currentUser!.email,
                  )
                  .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (!snapshot.hasData) {
              return Center(child: progressIndicator(context));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final d = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    // ✅ Makes it clickable
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                currentUserId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                friendId: d.id, // ✅ Parent's UID
                                friendName: d['name'],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      color: Color(0xFF9F80A7),
                      child: ListTile(
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
