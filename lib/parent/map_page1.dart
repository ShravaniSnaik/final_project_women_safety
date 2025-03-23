// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';

// const String tomtomApiKey =
//     "FCEkDNPLpD00ZQ4tFGlltWswGcJselVf"; // Replace with your API Key

// class DangerMapPage extends StatefulWidget {
//   @override
//   _DangerMapPageState createState() => _DangerMapPageState();
// }

// class _DangerMapPageState extends State<DangerMapPage> {
//   final MapController _mapController = MapController();
//   LatLng? _currentLocation;
//   double _currentZoom = 12.0;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enable location services.")),
//       );
//       return;
//     }

//     // Check and request permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Location permission denied.")));
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Location permission permanently denied.")),
//       );
//       return;
//     }

//     // Get current position
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//       _mapController.move(_currentLocation!, _currentZoom);
//     });
//   }

//   void _zoomIn() {
//     setState(() {
//       _currentZoom += 1;
//       _mapController.move(_mapController.camera.center, _currentZoom);
//     });
//   }

//   void _zoomOut() {
//     setState(() {
//       _currentZoom -= 1;
//       _mapController.move(_mapController.camera.center, _currentZoom);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Danger Zone Map")),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter:
//                   _currentLocation ??
//                   LatLng(28.6139, 77.2090), // Default to New Delhi
//               initialZoom: _currentZoom,
//               interactionOptions: const InteractionOptions(
//                 flags: InteractiveFlag.all, // Enables zooming and panning
//               ),
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$tomtomApiKey",
//                 userAgentPackageName: 'com.example.app',
//               ),
//               if (_currentLocation != null)
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       width: 40,
//                       height: 40,
//                       point: _currentLocation!,
//                       child: Icon(
//                         Icons.my_location,
//                         color: Colors.blue,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               CircleLayer(
//                 circles: [
//                   CircleMarker(
//                     point: LatLng(28.7041, 77.1025),
//                     color: Colors.red.withOpacity(0.5),
//                     radius: 500,
//                     useRadiusInMeter: true,
//                   ),
//                   CircleMarker(
//                     point: LatLng(28.5355, 77.3910),
//                     color: Colors.red.withOpacity(0.5),
//                     radius: 800,
//                     useRadiusInMeter: true,
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           // Zoom Controls
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   heroTag: "zoomIn",
//                   mini: true,
//                   child: Icon(Icons.add),
//                   onPressed: _zoomIn,
//                 ),
//                 SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: "zoomOut",
//                   mini: true,
//                   child: Icon(Icons.remove),
//                   onPressed: _zoomOut,
//                 ),
//               ],
//             ),
//           ),

//           // Center to Current Location Button
//           Positioned(
//             bottom: 150,
//             right: 20,
//             child: FloatingActionButton(
//               heroTag: "location",
//               mini: true,
//               child: Icon(Icons.my_location),
//               onPressed: _getCurrentLocation,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_2/parent/my_drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

const String tomtomApiKey =
    "FCEkDNPLpD00ZQ4tFGlltWswGcJselVf"; // Replace with your API Key

class DangerMapPage1 extends StatefulWidget {
  const DangerMapPage1({super.key});

  @override
  _DangerMapPage1State createState() => _DangerMapPage1State();
}

class _DangerMapPage1State extends State<DangerMapPage1> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  double _currentZoom = 12.0;
  final List<CircleMarker> _dangerZones = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchDangerZones();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enable location services.")),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location permission denied.")));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission permanently denied.")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, _currentZoom);
    });
  }

  Future<void> _fetchDangerZones() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('location').get();

      for (var doc in querySnapshot.docs) {
        String locationName = doc['name'];
        double averageRating = doc['average'];

        debugPrint(
          "Fetched location: $locationName, Average rating: $averageRating",
        );

        if (averageRating < 3) {
          try {
            List<Location> locations = await locationFromAddress(locationName);
            if (locations.isNotEmpty) {
              LatLng position = LatLng(
                locations.first.latitude,
                locations.first.longitude,
              );

              setState(() {
                _dangerZones.add(
                  CircleMarker(
                    point: position,
                    color: Colors.red.withOpacity(0.5),
                    radius: 500,
                    useRadiusInMeter: true,
                  ),
                );
              });
            }
          } catch (e) {
            debugPrint("Error getting location for $locationName: $e");
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching danger zones: $e");
    }
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Color(0xFF43061E),
        title: Text(
          'Danger Zone Maps',
          style: TextStyle(
            color: Color(0xFFECE1EE),
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _currentLocation ??
                  LatLng(28.6139, 77.2090), // Default to New Delhi
              initialZoom: _currentZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all, // Enables zooming and panning
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$tomtomApiKey",
                userAgentPackageName: 'com.example.app',
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: _currentLocation!,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              CircleLayer(circles: _dangerZones),
            ],
          ),

          // Zoom Controls
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  mini: true,
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  mini: true,
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),

          // Center to Current Location Button
          Positioned(
            bottom: 150,
            right: 20,
            child: FloatingActionButton(
              heroTag: "location",
              mini: true,
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
