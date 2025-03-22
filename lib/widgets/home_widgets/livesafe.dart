import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/home_widgets/live_safe_card/bus_station_card.dart';
import 'package:flutter_application_2/widgets/home_widgets/live_safe_card/hospital_card.dart';
import 'package:flutter_application_2/widgets/home_widgets/live_safe_card/pharmacy_card.dart';
import 'package:flutter_application_2/widgets/home_widgets/live_safe_card/police_station_card.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({super.key});
  static Future<void> openMap(String location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';
    final Uri url = Uri.parse(googleUrl);
    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'something went wrong! call emergency number',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStationCard(openMap),
          HospitalCard(openMap),
          PharmacyCard(openMap),
          BusStationCard(openMap),
        ],
      ),
    );
  }
}
