import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/child/child_login_screen.dart';
import 'package:flutter_application_2/model/user_model.dart';


import '../../utils/constants.dart';
import '../components/SecondaryButton.dart';
import '../components/PrimaryButton.dart';
import '../components/custom_textfield.dart';

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({super.key});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool isLoading=false;


  _onSubmit() async{
    _formKey.currentState!.save();
    if(_formData['password']!=_formData['rpassword']){
      dialogueBox(context, 'password and retype password should be equal');
    }
    else {
      progressIndicator(context);
      try {
        setState(() {
        isLoading =true;
      });
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
     email:_formData['cemail'].toString(),
         password: _formData['password'].toString()
  );
  if(userCredential.user!=null)
  {
    setState(() {
        isLoading =true;
      });
    final v=userCredential.user!.uid;
    DocumentReference<Map<String,dynamic>> db=
            FirebaseFirestore.instance.collection('users').doc(v);
            final user=UserModel(
              name:_formData['name'].toString(),
              phone:_formData['phone'].toString(),
              childEmail: _formData['cemail'].toString(),
              guardianEmail: _formData['gemail'].toString(),
              id:v,
              type:'child',
            );
            final jsonData=user.toJson();
            await db.set(jsonData).whenComplete((){
              goTo(context, LoginScreen());
              setState(() {
        isLoading =false;
      });
            });
            
  }
} on FirebaseAuthException catch (e) {
  setState(() {
        isLoading =false;
      });
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
    dialogueBox(context, 'The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
    dialogueBox(context, 'The account already exists for that email.');
  }
} catch (e) {
  setState(() {
        isLoading =false;
      });
  print(e);
  dialogueBox(context, e.toString());
}
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF50046C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
         children: [
           isLoading
                ? progressIndicator(context)
             :
           SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REGISTER AS CHILD",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFECE1EE) 
                        ),
                      ),

                      
                    ],
                  ),
                ),
              
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextField(
                          hintText: 'Enter name',
                           hintStyle: TextStyle(color: Color(0xFFE0435E)),
                                    style: TextStyle(color: Color(0xFFECE1EE) ),
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.name,
                          prefix: Icon(Icons.person,
                          color: Color(0xFFECE1EE),),
                          onsave: (name) {
                            _formData['name'] = name ?? "";
                          },
                          validate: (email) {
                            if (email!.isEmpty || email.length < 3) {
                              return 'enter correct name';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Enter phone',
                          hintStyle: TextStyle(color: Color(0xFFE0435E)),
                          style: TextStyle(color: Color(0xFFECE1EE) ),
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.phone,
                          prefix: Icon(Icons.phone,
                          color: Color(0xFFECE1EE),),
                          onsave: (phone) {
                            _formData['phone'] = phone ?? "";
                          },
                          validate: (email) {
                            if (email!.isEmpty || email.length < 10) {
                              return 'enter correct phone';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Enter email',
                          hintStyle: TextStyle(color: Color(0xFFE0435E)),
                          style: TextStyle(color: Color(0xFFECE1EE) ),
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.emailAddress,
                          prefix: const Icon(Icons.person,
                          color: Color(0xFFECE1EE),),
                          onsave: (email) {
                            _formData['cemail'] = email ?? "";
                          },
                          validate: (email) {
                            if (email!.isEmpty ||
                                email.length < 3 ||
                                !email.contains("@")) {
                              return 'enter correct email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Enter guardian email',
                         hintStyle: TextStyle(color: Color(0xFFE0435E)),
                          style: TextStyle(color: Color(0xFFECE1EE) ),
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.emailAddress,
                          prefix: Icon(Icons.person,
                          color: Color(0xFFECE1EE),),
                          onsave: (gemail) {
                            _formData['gemail'] = gemail ?? "";
                          },
                          validate: (email) {
                            if (email!.isEmpty ||
                                email.length < 3 ||
                                !email.contains("@")) {
                              return 'enter correct email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Enter password',
                         hintStyle: TextStyle(color: Color(0xFFE0435E)),
                          style: TextStyle(color: Color(0xFFECE1EE) ),
                          isPassword: isPasswordShown,
                          prefix: Icon(Icons.vpn_key_rounded,
                          color: Color(0xFFECE1EE),),
                          onsave: (password) {
                            _formData['password'] = password ?? "";
                          },
                          validate: (password) {
                            if (password!.isEmpty || password.length < 7) {
                              return 'enter correct password';
                            }
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordShown = !isPasswordShown;
                              });
                            },
                            icon:
                                isPasswordShown
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                    color: Color(0xFFECE1EE),
                          ),
                        ),

                        CustomTextField(
                          hintText: ' retype password',
                         hintStyle: TextStyle(color: Color(0xFFE0435E)),
                          style: TextStyle(color: Color(0xFFECE1EE) ),
                          isPassword: isRetypePasswordShown,
                          prefix: Icon(Icons.vpn_key_rounded,
                          color: Color(0xFFECE1EE),),
                          onsave: (password) {
                            _formData['rpassword'] = password ?? "";
                          },
                          validate: (password) {
                            if (password!.isEmpty || password.length < 7) {
                              return 'enter correct password';
                            }
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isRetypePasswordShown = !isRetypePasswordShown;
                              });
                            },
                            icon:
                                isRetypePasswordShown
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                    color: Color(0xFFECE1EE),
                          ),
                        ),

                        PrimaryButton(
                          title: 'REGISTER',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _onSubmit();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SecondaryButton(
                  title: 'Login with your account',
                  onPressed: () {
                    goTo(context, LoginScreen());
                  },
                ),
              ],
            ),
          ),
          ]
          ),
        ),
      ),
    );
  }
}
