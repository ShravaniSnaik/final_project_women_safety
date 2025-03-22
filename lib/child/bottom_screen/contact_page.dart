// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../db/db_services.dart';
// import '../../../model/contactsm.dart';
// import '../../../utils/constants.dart';

// class ContactPage extends StatefulWidget {
//   const ContactPage({super.key});

//   @override
//   State<ContactPage> createState() => _ContactPageState();
// }

// class _ContactPageState extends State<ContactPage> {
//   List<Contact> contacts = [];
//   List<Contact> contactsFiltered = [];
//   final DatabaseHelper _databaseHelper = DatabaseHelper();

//   TextEditingController searchController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     askPermissions();
//   }

//   String flattenPhoneNumber(String phoneStr) {
//     return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
//       return m[0] == "+" ? "+" : "";
//     });
//   }

//   filterContact() {
//     List<Contact> contacts = [];
//     contacts.addAll(contacts);
//     if (searchController.text.isNotEmpty) {
//       contacts.retainWhere((element) {
//         String searchTerm = searchController.text.toLowerCase();
//         String searchTermFlattren = flattenPhoneNumber(searchTerm);
//         String contactName = element.displayName!.toLowerCase();
//         bool nameMatch = contactName.contains(searchTerm);
//         if (nameMatch == true) {
//           return true;
//         }
//         if (searchTermFlattren.isEmpty) {
//           return false;
//         }
//         var phone = element.phones!.firstWhere((p) {
//           String phnFLattered = flattenPhoneNumber(p.value!);
//           return phnFLattered.contains(searchTermFlattren);
//         });
//         return phone.value != null;
//       });
//     }
//     setState(() {
//       contactsFiltered = contacts;
//     });
//   }

//   Future<void> askPermissions() async {
//     PermissionStatus permissionStatus = await getContactsPermissions();
//     if (permissionStatus == PermissionStatus.granted) {
//       getAllContacts();

//       searchController.addListener(() {
//         filterContact();
//       });
//     } else {
//       handInvaliedPermissions(permissionStatus);
//     }
//   }

//   handInvaliedPermissions(PermissionStatus permissionStatus) {
//     if (permissionStatus == PermissionStatus.denied) {
//       dialogueBox(context, "Access to the contacts denied by the user");
//     } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
//       dialogueBox(context, "May contact does not exist in this device");
//     }
//   }

//   Future<PermissionStatus> getContactsPermissions() async {
//     PermissionStatus permission = await Permission.contacts.status;
//     if (permission != PermissionStatus.granted &&
//         permission != PermissionStatus.permanentlyDenied) {
//       PermissionStatus permissionStatus = await Permission.contacts.request();
//       return permissionStatus;
//     } else {
//       return permission;
//     }
//   }

//   getAllContacts() async {
//     List<Contact> contacts = await ContactsService.getContacts(
//       withThumbnails: false,
//     );
//     setState(() {
//       contacts = contacts;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isSearchIng = searchController.text.isNotEmpty;
//     bool listItemExit = (contactsFiltered.isNotEmpty || contacts.isNotEmpty);
//     return Scaffold(
//       body:
//           contacts.isEmpty
//               ? Center(child: CircularProgressIndicator())
//               : SafeArea(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         autofocus: true,
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           labelText: "search contact",
//                           prefixIcon: Icon(Icons.search),
//                         ),
//                       ),
//                     ),
//                     listItemExit == true
//                         ? Expanded(
//                           child: ListView.builder(
//                             itemCount:
//                                 isSearchIng == true
//                                     ? contactsFiltered.length
//                                     : contacts.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               Contact contact =
//                                   isSearchIng == true
//                                       ? contactsFiltered[index]
//                                       : contacts[index];
//                               return ListTile(
//                                 title: Text(contact.displayName!),
//                                 // subtitle:Text(contact.phones!.elementAt(0)
//                                 // .value!) ,
//                                 leading:
//                                     contact.avatar != null &&
//                                             contact.avatar!.isNotEmpty
//                                         ? CircleAvatar(
//                                           backgroundColor: primaryColor,
//                                           backgroundImage: MemoryImage(
//                                             contact.avatar!,
//                                           ),
//                                         )
//                                         : CircleAvatar(
//                                           backgroundColor: primaryColor,
//                                           child: Text(contact.initials()),
//                                         ),
//                                 onTap: () {
//                                   if (contact.phones!.isNotEmpty) {
//                                     final String phoneNum =
//                                         contact.phones!.elementAt(0).value!;
//                                     final String name = contact.displayName!;
//                                     _addContact(TContact(phoneNum, name));
//                                   } else {
//                                     Fluttertoast.showToast(
//                                       msg:
//                                           "Oops! phone number of this contact does not exist",
//                                     );
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         )
//                         : Container(child: Text("searching")),
//                   ],
//                 ),
//               ),
//     );
//   }

//   void _addContact(TContact newContact) async {
//     int result = await _databaseHelper.insertContact(newContact);
//     if (result != 0) {
//       Fluttertoast.showToast(msg: "contact added successfully");
//     } else {
//       Fluttertoast.showToast(msg: "Failed to add contacts");
//     }
//     Navigator.of(context).pop(true);
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../db/db_services.dart';
import '../../../model/contactsm.dart';
import '../../../utils/constants.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  void filterContact() {
    List<Contact> filtered = [];
    filtered.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      filtered.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlattren = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName.toLowerCase();
        bool nameMatch = contactName.contains(searchTerm);
        if (nameMatch) return true;

        if (searchTermFlattren.isEmpty) return false;

        bool phoneMatch = element.phones.any((p) {
          String phnFLattered = flattenPhoneNumber(p.number);
          return phnFLattered.contains(searchTermFlattren);
        });

        return phoneMatch;
      });
    }

    setState(() {
      contactsFiltered = filtered;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "May contact does not exist in this device");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> getAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contactList = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );

      setState(() {
        contacts = contactList;
      });
    } else {
      dialogueBox(context, "Permission to access contacts denied");
    }
  }

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(" ");
    if (nameParts.isEmpty) return "";
    String initials =
        nameParts.map((e) => e.isNotEmpty ? e[0] : "").take(2).join();
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExists = contactsFiltered.isNotEmpty || contacts.isNotEmpty;

    return Scaffold(
      body:
          contacts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: "Search contact",
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    listItemExists
                        ? Expanded(
                          child: ListView.builder(
                            itemCount:
                                isSearching
                                    ? contactsFiltered.length
                                    : contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact =
                                  isSearching
                                      ? contactsFiltered[index]
                                      : contacts[index];

                              return ListTile(
                                title: Text(contact.displayName),
                                leading:
                                    contact.thumbnail != null &&
                                            contact.thumbnail!.isNotEmpty
                                        ? CircleAvatar(
                                          backgroundColor: primaryColor,
                                          backgroundImage: MemoryImage(
                                            contact.thumbnail!,
                                          ),
                                        )
                                        : CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Text(
                                            _getInitials(contact.displayName),
                                          ),
                                        ),
                                onTap: () {
                                  if (contact.phones.isNotEmpty) {
                                    final String phoneNum =
                                        contact.phones.first.number;
                                    final String name = contact.displayName;
                                    _addContact(TContact(phoneNum, name));
                                  } else {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Oops! Phone number for this contact does not exist",
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        )
                        : const Center(child: Text("Searching...")),
                  ],
                ),
              ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}
