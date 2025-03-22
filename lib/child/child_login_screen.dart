import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/child/register_child.dart';
import 'package:flutter_application_2/db/sp.dart';
import 'package:flutter_application_2/parent/parent_home_screen.dart';
import '../components/custom_textfield.dart';
import '../components/PrimaryButton.dart';
import '../../utils/constants.dart';
import '../components/SecondaryButton.dart';
import '../parent/parent_register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool isLoading = false;

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData['email']!,
        password: _formData['password']!,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          dialogueBox(context, "User data not found.");
          setState(() {
            isLoading = false;
          });
          return;
        }

        String userType = userDoc['type'];
        await MySharedPreference.saveUserType(userType);

        Widget nextScreen = (userType == 'parent') ? ParentHomeScreen() : Container();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      }
      dialogueBox(context, errorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // ✅ Used Stack to set background properly
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/login_page_background (2).jpg',  // ✅ Changed filename (removed spaces)
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (isLoading)
  Expanded(child: Center(child: progressIndicator(context)))
                  else
                  Expanded(child: 
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "USER LOGIN",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFECE1EE),
                                  ),
                                ),
                                Image.asset('assets/logo.png', height: 100, width: 100),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextField(
                                    hintText: 'Enter email',
                                    hintStyle: TextStyle(color: Color(0xFFE0435E)),
                                    style: TextStyle(color: Color(0xFFECE1EE) ),
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: const Icon(Icons.person, color:  Color(0xFFE0435E),),
                                    onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty || !email.contains("@")) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomTextField(
                                    hintText: 'Enter password',
                                    hintStyle: TextStyle(color: Color(0xFFE0435E)),
                                   // style: TextStyle(color: Color(0xFFECE1EE) ),
                                    isPassword: isPasswordShown,
                                    prefix: const Icon(Icons.vpn_key_rounded , color:  Color(0xFFE0435E),),
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                    validate: (password) {
                                      if (password!.isEmpty || password.length < 7) {
                                        return 'Enter a valid password';
                                      }
                                      return null;
                                    },
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordShown = !isPasswordShown;
                                        });
                                      },
                                      icon: isPasswordShown
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                          color:  Color(0xFFE0435E),
                                    ),
                                  ),
                                  PrimaryButton(
                                    title: 'LOGIN',
                                    onPressed: _onSubmit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Forgot Password", style: TextStyle(fontSize: 18,color:Color(0xFFE0435E))),
                              SecondaryButton(title: 'Click here', onPressed: () {}),
                            ],
                          ),
                          SecondaryButton(
                            title: 'Register as child',
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterChildScreen()));
                            },
                          ),
                          SecondaryButton(
                            title: 'Register as parent',
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterParentScreen()));
                            },
                          ),
                        ],
                      ),
                    ),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}