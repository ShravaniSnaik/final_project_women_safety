// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_demo/chat_module/message_text_field.dart';
// import 'package:flutter_demo/chat_module/singleMessage.dart';
// import 'package:flutter_demo/child/child_login_screen.dart';
// import 'package:flutter_demo/utils/constants.dart';

// class ChatScreen extends StatefulWidget {
//   final String currentUserId;
//   final String friendId;
//   final String friendName;

//   const ChatScreen({
//     super.key,
//     required this.currentUserId,
//     required this.friendId,
//     required this.friendName,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   String? type;
//   String? myname;
//   getStatus() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.currentUserId)
//         .get()
//         .then((value) {
//           setState(() {
//             type = value.data()!['type'];
//             myname = value.data()!['name'];
//           });
//         });
//   }

//   @override
//   void initState() {
//     getStatus();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink,
//         title: Text(widget.friendName),
//       ),
//       body: Column(
//         children: [
//           Expanded(

//             child: StreamBuilder(
//               stream:
//                   FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(widget.currentUserId)
//                       .collection('messages')
//                       .doc(widget.friendId)
//                       .collection('chats')
//                       .snapshots(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data!.docs.length < 1) {
//                     return Center(
//                       child: Text(
//                         type == 'parent'
//                             ? "Talk with child"
//                             : "Talk with parent",
//                         style: TextStyle(fontSize: 30),
//                       ),
//                     );
//                   }
//                     return Container(
//                   child: ListView.builder(
//                     reverse: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       bool isMe =
//                           snapshot.data!.docs[index]['senderId'] ==
//                           widget.currentUserId;
//                       final data = snapshot.data!.docs[index];
//                       return SingleMessage(
//                         message: data['message'],
//                         date: data['date'],
//                         isMe: isMe,
//                         friendName: widget.friendName,
//                         myName: myname,
//                          type: data['type'],
//                       );
//                     },
//                   ),
//                 );

//                 }
//                 return progressIndicator(context);
//   },
//             ),
//           ),

//         MessageTextField(
//           currentId: widget.currentUserId,
//           friendId: widget.friendId,
//         ),

//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/chat_module/message_text_field.dart';
import 'package:flutter_application_2/chat_module/singleMessage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.friendId,
    required this.friendName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? type;
  String? myname;

  Future<void> getStatus() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUserId)
              .get();

      if (userDoc.exists) {
        setState(() {
          type = userDoc.data() != null ? userDoc.get('type') : 'Unknown';
          myname = userDoc.data() != null ? userDoc.get('name') : 'Unknown';
        });
      } else {
        print("User document not found for ID: ${widget.currentUserId}");
      }
    } catch (e) {
      print("Error fetching user status: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFECE1EE)),
        backgroundColor: Color(0xFF43061E),
        title: Text(
          widget.friendName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w100,
            color: Color(0xFFECE1EE),
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
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.currentUserId)
                        .collection('messages')
                        .doc(widget.friendId)
                        .collection('chats')
                        .orderBy(
                          'date',
                          descending: true,
                        ) // ✅ Fix: Order messages
                        .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading messages"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        type == 'parent'
                            ? "Talk with child"
                            : "Talk with parent",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF43061E),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = snapshot.data!.docs[index];
                      bool isMe = data['senderId'] == widget.currentUserId;

                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.currentUserId)
                              .collection('messages')
                              .doc(widget.friendId)
                              .collection('chats')
                              .doc(data.id)
                              .delete();

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.friendId)
                              .collection('messages')
                              .doc(widget.currentUserId)
                              .collection('chats')
                              .doc(data.id)
                              .delete()
                              .then(
                                (value) => Fluttertoast.showToast(
                                  msg: 'message deleted successfully',
                                ),
                              );
                        },
                        child: SingleMessage(
                          message: data['message'],
                          date: data['date'],
                          isMe: isMe,
                          friendName: widget.friendName,
                          myName: myname,
                          type: data['type'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            MessageTextField(
              currentId: widget.currentUserId,
              friendId: widget.friendId,
            ),
          ],
        ),
      ),
    );
  }
}
