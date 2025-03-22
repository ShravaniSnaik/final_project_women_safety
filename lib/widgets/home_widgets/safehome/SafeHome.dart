// import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
// import '../../../db/db_services.dart';
// import '../../../model/contactsm.dart';

class SafeHome extends StatefulWidget {
  const SafeHome({super.key});

  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
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
  //     if (status == "sent") {
  //       Fluttertoast.showToast(msg: "send");
  //     } else {
  //       Fluttertoast.showToast(msg: "failed");
  //     }
  //   });
  // }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Location services are disabled. Please enable the services',
  //         ),
  //       ),
  //     );
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Location permissions are denied')),
  //       );
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Location permissions are permanently denied, we cannot request permissions.',
  //         ),
  //       ),
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  // _getCurrentLocation() async {
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     Fluttertoast.showToast(msg: "Location permissions are deneid");
  //     if (permission == LocationPermission.deniedForever) {
  //       Fluttertoast.showToast(
  //         msg: "Location permissions are permanently deneid",
  //       );
  //     }
  //   }
  //   Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //         forceAndroidLocationManager: true,
  //       )
  //       .then((Position position) {
  //         setState(() {
  //           _curentPosition = position;
  //           print(_curentPosition!.latitude);
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
  //           "${place.locality},${place.postalCode},${place.street},";
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();

    //_getCurrentLocation();
  }

  // showModelSafeHome(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height / 1.4,

  //         child: Padding(
  //           padding: const EdgeInsets.all(14.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "SEND YOUR CUURENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 20),
  //               ),
  //               SizedBox(height: 10),
  //               if (_curentPosition != null) Text(_curentAddress!),
  //               PrimaryButton(
  //                 title: "GET LOCATION",
  //                 onPressed: () {
  //                   _getCurrentLocation();
  //                 },
  //               ),
  //               SizedBox(height: 10),
  //               PrimaryButton(
  //                 title: "SEND ALERT",
  //                 onPressed: () async {
  //                   String recipients = "";
  //                   List<TContact> contactList =
  //                       await DatabaseHelper().getContactList();

  //                   String messageBody =
  //                       "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";
  //                   if (await _isPermissionGranted()) {
  //                     contactList.forEach((element) {
  //                       _sendSms(
  //                         "${element.number}",
  //                         "i am in trouble $messageBody",
  //                         simSlot: 1,
  //                       );
  //                     });
  //                   } else {
  //                     Fluttertoast.showToast(msg: "something wrong");
  //                   }
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         decoration: BoxDecoration(
  //           color: Color(0xFF9F80A7),
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(30),
  //             topRight: Radius.circular(30),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => showModelSafeHome(context),
      child: Card(
        color: Color(0xFF9F80A7),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height:
              MediaQuery.of(context).size.height * 0.22, // Responsive height
          width: MediaQuery.of(context).size.width * 0.9, // Responsive width
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ), // Add padding for better spacing
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  children: [
                    ListTile(
                      title: Text(
                        "Send Location",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width *
                              0.05, // Responsive font size
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF43061E),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Let quickly know your guardian your current location",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width *
                                0.04, // Responsive font size
                            color: Color(0xFFECE1EE),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      0.3, // Responsive width
                  height:
                      MediaQuery.of(context).size.height *
                      0.15, // Responsive height
                  child: Lottie.asset(
                    'assets/animations/location.json',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
