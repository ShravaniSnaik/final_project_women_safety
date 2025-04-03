import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../db/db_services.dart';
import '../../../model/contactsm.dart';
import '../../../components/PrimaryButton.dart';

class SafeHome extends StatefulWidget {
  const SafeHome({super.key});

  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;

  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  _sendSms(String phoneNumber, String message) async {
    try {
      if (await _isPermissionGranted()) {
        await sendSMS(message: message, recipients: [phoneNumber]);
        Fluttertoast.showToast(msg: "Message sent");
      } else {
        Fluttertoast.showToast(msg: "SMS permission denied");
      }
    } catch (e) {
      if (e.toString().contains("device not capable")) {
        Fluttertoast.showToast(msg: "Device cannot send SMS");
      } else {
        Fluttertoast.showToast(msg: "Failed to send message");
      }
    }
  }

//   _sendSms(String phoneNumber, String message) async {
//   try {
//     if (!(await canSendSMS())) {
//       Fluttertoast.showToast(msg: "This device cannot send SMS.");
//       return;
//     }

//     await sendSMS(message: message, recipients: [phoneNumber]);
//     Fluttertoast.showToast(msg: "Message sent");
//   } catch (e) {
//     Fluttertoast.showToast(msg: "Failed to send message: ${e.toString()}");
//   }
// }

// Future<bool> canSendSMS() async {
//   try {
//     String result = await sendSMS(message: "Test", recipients: ["12345"]);
//     return result.isNotEmpty;
//   } catch (e) {
//     return false;
//   }
// }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them'),
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    if (await _handleLocationPermission()) {
      Geolocator.getCurrentPosition(
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
  }

  _getAddressFromLatLon() async {
    try {
      if (_curentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude,
          _curentPosition!.longitude,
        );

        Placemark place = placemarks[0];
        setState(() {
          _curentAddress =
              "${place.locality}, ${place.postalCode}, ${place.street}";
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          decoration: BoxDecoration(
            color: Color(0xFF9F80A7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                if (_curentAddress != null) Text(_curentAddress!),
                PrimaryButton(
                  title: "GET LOCATION",
                  onPressed: _getCurrentLocation,
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  title: "SEND ALERT",
                  onPressed: () async {
                    if (_curentPosition != null) {
                      List<TContact> contactList =
                          await DatabaseHelper().getContactList();

                      String messageBody =
                          "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude},${_curentPosition!.longitude}. $_curentAddress";

                      for (var contact in contactList) {
                        _sendSms(
                          contact.number,
                          "I am in trouble: $messageBody",
                        );
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Location not available");
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Card(
        color: Color(0xFF9F80A7),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
               
                title: Text(
                  "Send Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF43061E),
                  ),
                ),

                subtitle: Padding(
      padding: EdgeInsets.only(top: 5), // Adjust the top padding
      child: Text(
        "Let your guardian know your current location quickly",
        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Color(0xFFECE1EE)),
      ),
    ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Lottie.asset(
                'assets/animations/location.json',
                width: 170,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}