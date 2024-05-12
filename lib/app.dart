import 'package:flutter/material.dart';
import 'package:flutter_google_map_location_marker/controller_binder.dart';
import 'package:flutter_google_map_location_marker/presentation/screens/map_screen.dart';
import 'package:get/get.dart';

class GoogleMapLocationMarker extends StatelessWidget {
  const GoogleMapLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinder(),
      home: const MapScreen(),
    );
  }
}
