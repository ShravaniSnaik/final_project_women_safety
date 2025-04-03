// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/child/bottom_screen/contact_page.dart';
// import 'package:flutter_application_2/components/PrimaryButton2.dart';
// import 'package:flutter_application_2/db/db_services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:sqflite/sqflite.dart';
// import '../../../model/contactsm.dart';

// class AddContactsPage extends StatefulWidget {
//   const AddContactsPage({super.key});

//   @override
//   State<AddContactsPage> createState() => _AddContactsPageState();
// }

// class _AddContactsPageState extends State<AddContactsPage> {
//   DatabaseHelper databasehelper = DatabaseHelper();
//   List<TContact>? contactList;
//   int count = 0;

//   void showList() {
//     Future<Database> dbFuture = databasehelper.initializeDatabase();
//     dbFuture.then((database) {
//       Future<List<TContact>> contactListFuture =
//           databasehelper.getContactList();
//       contactListFuture.then((value) {
//         setState(() {
//           contactList = value;
//           count = value.length;
//         });
//       });
//     });
//   }

//   void deleteContact(TContact contact) async {
//     int result = await databasehelper.deleteContact(contact.id);
//     if (result != 0) {
//       Fluttertoast.showToast(msg: "contact removed succesfully");
//       showList();
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       showList();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     contactList ??= [];
//     return SafeArea(
//       child: Container(
//         color: Color(0xFFECE1EE),
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             PrimaryButton2(
//               title: "Add Trusted Contacts",
             
//               onPressed: () async {
//                 bool result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ContactPage()),
//                 );
//                 if (result == true) {
//                   showList();
//                 }
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: count,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     color:Color(0xFF9F80A7) ,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         textColor: Color(0xFFECE1EE),
//                         title: Text(contactList![index].name),
//                         trailing: SizedBox(
//                           width: 100,
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 onPressed: () async {
//                                   await FlutterPhoneDirectCaller.callNumber(
//                                     contactList![index].number,
//                                   );
//                                 },
//                                 icon: Icon(Icons.call, color: Color(0xFF43061E)),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   deleteContact(contactList![index]);
//                                 },
//                                 icon: Icon(Icons.delete, color: Color(0xFF43061E)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_2/child/bottom_screen/contact_page.dart';
import 'package:flutter_application_2/components/PrimaryButton2.dart';
import 'package:flutter_application_2/db/db_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

import '../../../model/contactsm.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databasehelper = DatabaseHelper();
  List<TContact>? contactList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showList();
    });
  }

  void showList() {
    Future<Database> dbFuture = databasehelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
          databasehelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
        });
      });
    });
  }

  void deleteContact(TContact contact) async {
    int result = await databasehelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed successfully");
      showList();
    }
  }

  @override
  Widget build(BuildContext context) {
    contactList ??= [];
    return SafeArea(
      child: Container(
        color: Color(0xFFECE1EE), // 🔥 Background Color Added
        child: Stack(
          children: [
            // Lottie Animation at Bottom Center
            Positioned(
              bottom: -10, // Adjust position
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  'assets/animations/contact-page.json', // 🔥 Your Lottie animation
                  width: 350, // Adjust width
                  height: 350, // Adjust height
                  repeat: true, // Loop animation
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // UI Content
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  PrimaryButton2(
                    title: ("Add Trusted Contacts"),
                    onPressed: () async {
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactPage()),
                      );
                      if (result == true) {
                        showList();
                      }
                    },
                  ),

                  // 🔥 Expanded List with Styled Text
                  Expanded(
                    child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Color(0xFF9F80A7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              textColor: Color(0xFFECE1EE),

                              // 🔥 Title Styling
                              title: Text(
                                contactList![index].name,
                                style: TextStyle(
                                  fontSize: 18, // Adjusted Font Size
                                  fontWeight: FontWeight.w500, // Font Weight
                                  color: Colors.white, // Text Color
                                ),
                              ),

                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await FlutterPhoneDirectCaller.callNumber(
                                          contactList![index].number,
                                        );
                                      },
                                      icon: Icon(Icons.call, color: Color(0xFF43061E)),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteContact(contactList![index]);
                                      },
                                      icon: Icon(Icons.delete, color: Color(0xFF43061E)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
