import 'package:flutter/material.dart';

class PoliceStationCard extends StatelessWidget {
  final Function? onMapFunction;
  const PoliceStationCard(this.onMapFunction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onMapFunction!('police stations near me');
              },

              child: Card(
                elevation: 10,
                shadowColor: Color(0xFF43061E),
                surfaceTintColor: Color(0xFF43061E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 50,
                  width: 50,

                  child: Center(
                    child: Image.asset(
                      'assets/police_icon.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Police Stations',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF43061E),
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
