import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/child/child_login_screen.dart';
import 'package:flutter_application_2/components/PrimaryButton1.dart';
import 'package:flutter_application_2/components/custom_textfield.dart';
import 'package:flutter_application_2/parent/my_drawer.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({super.key});

  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  TextEditingController nameC = TextEditingController();
  TextEditingController child_emailC = TextEditingController();
  TextEditingController parent_emailC = TextEditingController();
  TextEditingController phone_C = TextEditingController();
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;
  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          setState(() {
            nameC.text = value.docs.first['name'];
            child_emailC.text = value.docs.first['childEmail'];
            parent_emailC.text = value.docs.first['guardianEmail'];
            phone_C.text = value.docs.first['phone'];
            id = value.docs.first.id;
            profilePic = value.docs.first['profilePic'];
          });
        });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE1EE),
     appBar: AppBar(
        backgroundColor: Color(0xFF43061E),
        title: Text(
          'Know Yourself',
          style: TextStyle(
            color: Color(0xFFECE1EE),
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body:
          isSaving == true
              ? Center(
                child: CircularProgressIndicator(backgroundColor: Colors.pink),
              )
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Center(
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final XFile? pickImage = await ImagePicker()
                                  .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50,
                                  );
                              if (pickImage != null) {
                                setState(() {
                                  profilePic = pickImage.path;
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                //background image
                                Container(
                                  alignment: Alignment.center,
                                  height: 200, // Reduced height slightly
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ), // Rounded corners
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/profile_background.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Text(
                                    "UPDATE YOUR PROFILE",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w100,
                                      color: Color(0xFF43061E),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: -45,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    child:
                                        profilePic == null
                                            ? CircleAvatar(
                                              backgroundColor: Color(
                                                0xFF9F80A7,
                                              ),
                                              radius: 55,
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/profile.png',
                                                  height: 150,
                                                  width: 150,
                                                ),
                                              ),
                                            )
                                            : profilePic!.contains('http')
                                            ? CircleAvatar(
                                              backgroundColor: Color(
                                                0xFF9F80A7,
                                              ),
                                              radius: 80,
                                              backgroundImage: NetworkImage(
                                                profilePic!,
                                              ),
                                            )
                                            : CircleAvatar(
                                              backgroundColor: Color(
                                                0xFF9F80A7,
                                              ),
                                              radius: 80,
                                              backgroundImage: FileImage(
                                                File(profilePic!),
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 35),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: nameC,
                                  hintText: "Enter your name",
                                  validate:
                                      (v) =>
                                          v!.isEmpty
                                              ? 'Please enter your updated name'
                                              : null,
                                ),
                                SizedBox(height: 10),
                                CustomTextField(
                                  controller: child_emailC,
                                  hintText: "Enter child email",
                                  validate:
                                      (v) =>
                                          v!.isEmpty
                                              ? 'Please enter updated email'
                                              : null,
                                ),
                                SizedBox(height: 10),
                                CustomTextField(
                                  controller: parent_emailC,
                                  hintText: "Enter parent email",
                                  validate:
                                      (v) =>
                                          v!.isEmpty
                                              ? 'Please enter updated email'
                                              : null,
                                ),
                                SizedBox(height: 10),
                                CustomTextField(
                                  controller: phone_C,
                                  hintText: "Enter phone number",
                                  validate:
                                      (v) =>
                                          v!.isEmpty
                                              ? 'Please enter phone number'
                                              : null,
                                ),
                              ],
                            ),
                          ),

                          PrimaryButton1(
                            title: "UPDATE",
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                SystemChannels.textInput.invokeMethod(
                                  'TextInput.hide',
                                );
                                profilePic == null
                                    ? Fluttertoast.showToast(
                                      msg: 'please select profile picture',
                                    )
                                    : update();
                              }
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(id)
                                  .update({
                                    'name': nameC.text,
                                    'childEmail': child_emailC,
                                    'parentEmail': parent_emailC,
                                    'phone': phone_C,
                                  })
                                  .then(
                                    (value) => {
                                      Fluttertoast.showToast(
                                        msg: 'name updated successfully',
                                      ),
                                    },
                                  );
                            },
                          ),
                          PrimaryButton1(
                            title: "SIGN OUT",
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .signOut(); // Sign out the user
                              Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final fileName = Uuid().v4();
      final Reference fbStorage = FirebaseStorage.instance
          .ref('profile')
          .child(fileName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  update() async {
    setState(() {
      isSaving = true;
    });

    uploadImage(profilePic!).then((value) {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'childEmail': child_emailC,
        'parentEmail': parent_emailC,
        'phone': phone_C,
        'propfilePic': downloadUrl,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
    });
    setState(() {
      isSaving = false;
    });
  }
}
