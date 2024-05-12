import 'package:flutter/material.dart';
import 'package:flutter_google_map_location_marker/presentation/controllers/map_screen_controller.dart';
import 'package:flutter_google_map_location_marker/presentation/widget/create_appbar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapScreenController = Get.find<MapScreenController>();

  @override
  void initState() {
    super.initState();
    _mapScreenController.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppbar("Real-Time Location Tracker"),
      body: SafeArea(
        child: GetBuilder<MapScreenController>(builder: (_) {
          return Visibility(
            visible: _mapScreenController.screenShouldLoad &&
                _mapScreenController.currentPos != const LatLng(0, 0),
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapScreenController.googleMapController = controller;
                _mapScreenController.getUpdatedLocation();
              },
              initialCameraPosition: CameraPosition(
                target: _mapScreenController.currentPos,
                zoom: 17,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("currentPosition"),
                  position: _mapScreenController.currentPos,
                  infoWindow: InfoWindow(
                      title: "My current location",
                      snippet:
                          "${_mapScreenController.currentPos.latitude} , ${_mapScreenController.currentPos.longitude}"),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("currentPosition"),
                  color: Colors.blue,
                  width: 5,
                  points: _mapScreenController.allLocationTraveled,
                )
              },
            ),
          );
        }),
      ),
    );
  }
}
