import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/home_widgets/CustomCarouel.dart';
import 'package:flutter_application_2/widgets/home_widgets/custom_appBar.dart';
import 'package:flutter_application_2/widgets/home_widgets/emergency.dart';
import 'package:flutter_application_2/widgets/home_widgets/livesafe.dart';
import 'package:flutter_application_2/widgets/home_widgets/safehome/SafeHome.dart';

// import 'package:flutter_demo/widgets/home_widgets/custom_appBar.dart';
// import 'package:flutter_demo/widgets/home_widgets/emergency.dart';
// import 'package:flutter_demo/widgets/home_widgets/livesafe.dart';
// import 'package:flutter_demo/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:lottie/lottie.dart';

import './Opportunity.dart';
// import '../../../db/db_services.dart';
// import '../../../model/contactsm.dart';
// import 'package:background_sms/background_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int qIndex = 0;
  //Position? _curentPosition;
  String? _curentAddress;
  //LocationPermission? permission;

  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  // _sendSms(String phoneNumber, String message, {int? simSlot}) async {
  //   await BackgroundSms.sendMessage(
  //     phoneNumber: phoneNumber,
  //     message: message,
  //     simSlot: simSlot,
  //   ).then((SmsStatus status) {
  //     if (status == SmsStatus.sent) {
  //       Fluttertoast.showToast(msg: "Message Sent");
  //     } else {
  //       Fluttertoast.showToast(msg: "Message Failed");
  //     }
  //   });
  // }

  // _getCurrentLocation() async {
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     Fluttertoast.showToast(msg: "Location permissions are denied");
  //     if (permission == LocationPermission.deniedForever) {
  //       Fluttertoast.showToast(
  //         msg: "Location permissions are permanently denied",
  //       );
  //     }
  //   }
  //   await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //         forceAndroidLocationManager: true,
  //       )
  //       .then((Position position) {
  //         setState(() {
  //           _curentPosition = position;
  //           _getAddressFromLatLon();
  //         });
  //       })
  //       .catchError((e) {
  //         Fluttertoast.showToast(msg: e.toString());
  //       });
  // }

  // _getAddressFromLatLon() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       _curentPosition!.latitude,
  //       _curentPosition!.longitude,
  //     );
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _curentAddress =
  //           "${place.locality}, ${place.postalCode}, ${place.street}";
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  void getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(12);
    });
  }

  // getAndSendSms() async {
  //   List<TContact> contactList = await DatabaseHelper().getContactList();
  //   String messageBody =
  //       "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";
  //   if (await _isPermissionGranted()) {
  //     for (var element in contactList) {
  //       _sendSms(
  //         "${element.number}",
  //         "I am in trouble: $messageBody",
  //         simSlot: 1,
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //   }
  // }

  _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Could not launch $url");
    }
  }

  @override
  void initState() {
    getRandomQuote();
    super.initState();
    _getPermission();
    // _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE1EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomAppbar(getRandomQuote, qIndex),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomCarouel(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Emergency",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF43061E),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Emergency(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Explore LiveSafe",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF43061E),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    LiveSafe(),
                    SafeHome(),

                    // Adding the "Opportunities" card
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpportunitiesScreen(),
                            ),
                          );
                        },
                        child: Card(
                          color: Color(0xFF9F80A7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  child: Lottie.asset(
                                    'assets/animations/oportunity.json', // Ensure the JSON file is added to assets
                                    width: 150, // Adjust size as needed
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    "Explore Opportunities",
                                    style: TextStyle(
                                      color: Color(0xFF43061E),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
