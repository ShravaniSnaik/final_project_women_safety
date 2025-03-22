import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/home_widgets/emergencies/ambulance.dart';
import 'package:flutter_application_2/widgets/home_widgets/emergencies/army.dart';
import 'package:flutter_application_2/widgets/home_widgets/emergencies/firebrigade.dart';
import 'package:flutter_application_2/widgets/home_widgets/emergencies/police.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          AmbulanceEmergency(),
          FirebrigadeEmergency(),
          ArmyEmergency(),
        ],
      ),
    );
  }
}
