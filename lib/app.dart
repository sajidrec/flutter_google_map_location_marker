import 'package:flutter/material.dart';
import 'package:flutter_google_map_location_marker/presentation/screens/map_screen.dart';

class GoogleMapLocationMarker extends StatelessWidget {
  const GoogleMapLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: MapScreen(),
    );
  }
}
