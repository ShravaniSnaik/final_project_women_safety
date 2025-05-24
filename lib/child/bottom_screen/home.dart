import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/ai_chatbot/bot_screen.dart';
import 'package:flutter_application_2/widgets/home_widgets/CustomCarouel.dart';
import 'package:flutter_application_2/widgets/home_widgets/custom_appBar.dart';
import 'package:flutter_application_2/widgets/home_widgets/emergency.dart';
import 'package:flutter_application_2/widgets/home_widgets/livesafe.dart';
import 'package:flutter_application_2/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:lottie/lottie.dart';
import 'package:shake/shake.dart';
import './Opportunity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../../../db/db_services.dart';
import '../../../model/contactsm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int qIndex = 0;
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;

  _getPermission() async =>
      await [Permission.sms, Permission.location].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  _sendSms(String phoneNumber, String message) async {
    try {
      String result = await sendSMS(
        message: message,
        recipients: [phoneNumber],
        sendDirect: true,
      );
      Fluttertoast.showToast(msg: "Message Sent: $result");
    } catch (error) {
      Fluttertoast.showToast(msg: "Message Failed: $error");
    }
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are denied");
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg: "Location permissions are permanently denied",
        );
      }
    }
    await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true,
        )
        .then((Position position) {
          setState(() {
            _curentPosition = position;
            _getAddressFromLatLon();
          });
        })
        .catchError((e) {
          Fluttertoast.showToast(msg: e.toString());
        });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _curentPosition!.latitude,
        _curentPosition!.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";
    if (await _isPermissionGranted()) {
       Future.forEach(contactList, (TContact contact) async {
      await _sendSms(contact.number, "I am in trouble: $messageBody");
    });

    Fluttertoast.showToast(msg: "Messages sent to all contacts!");
  } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

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
    _getCurrentLocation();

    //shake//
      ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shake!'),
          ),
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
  
    _getPermission();
  }

  void getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(12);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE1EE),
      body: Stack(
      children:[
      SafeArea(
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
  elevation: 5,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  child: Container(
    padding: EdgeInsets.all(10), // Increased padding to make the card bigger
    width: double.infinity, // Make card take full width
    height: 180,
   
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1), // Space from left edge
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15), // Rounded edges
            child: Lottie.asset(
              'assets/animations/oportunity.json',
              width: 165, // Keeping animation size same
              height: 165, // Keeping animation size same
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 6), // Increased spacing between animation and text
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
            children: [
              Text(
                "Explore Opportunities",
                style: TextStyle(
                  fontSize: 16, // Slightly bigger text
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF43061E),
                ),
              ),
              SizedBox(height: 8), // Space between title and subtitle
              Text(
                "Find various opportunities suited for you",
                style: TextStyle(
                  fontSize: 14, // Slightly bigger text
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFECE1EE),
                ),
              ),
            ],
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
      DraggableFloatingActionButton(),

    ]));
  }
}

class DraggableFloatingActionButton extends StatefulWidget {
  const DraggableFloatingActionButton({super.key});

  @override
  _DraggableFloatingActionButtonState createState() => _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState extends State<DraggableFloatingActionButton> {
  double posX = 250;
  double posY = 600;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: posX,
      top: posY,
      child: Draggable(
        feedback: _buildButton(),
        childWhenDragging: Container(),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            posX = offset.dx;
            posY = offset.dy;
          });
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AutoCounselorChatScreen()),
            );
          },
          child: _buildButton(),
        ),
      ),
    );
  }

 Widget _buildButton() {
  return Container(
    width: 120, // Increase width
    height: 120, // Increase height
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.transparent,
    ),
    child: ClipOval(
      child: Lottie.asset(
        'assets/animations/ai-bot.json',
        fit: BoxFit.cover,
      ),
    ),
  );
}

}
