import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ArmyEmergency extends StatelessWidget {
  const ArmyEmergency({super.key});

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () => _callNumber('1078'),
          child: IntrinsicHeight(
            // Adjusts height dynamically
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1000, // Prevents extreme width expansion
                minWidth: 250, // Ensures it doesn’t become too small
              ),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0C0000),
                    Color(0xFF43061E),
                    Color(0xFF9F80A7),
                    Color(0xFFECE1EE),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevents extra space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF9F80A7).withOpacity(0.5),
                    child: Image.asset(
                      'assets/army.png',
                      width: 40, // Increase width
                      height: 40, // Increase height
                      fit: BoxFit.contain, // Ensures it doesn't get cropped
                    ),
                  ),
                  SizedBox(height: 10),

                  Flexible(
                    // Prevents overflow
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          // Ensures text resizes
                          child: Text(
                            'NATIONAL DISASTER (NDRF)',
                            style: TextStyle(
                              color: Color(0xFFECE1EE),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        FittedBox(
                          child: Text(
                            'Call 1-0-7-8 for NDRF',
                            style: TextStyle(
                              color: Color(0xFFECE1EE),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Container(
                          height: 20,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFECE1EE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '1-0-7-8',
                              style: TextStyle(
                                color: Color(0xFF43061E),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
        ),
      ),
    );
  }
}
