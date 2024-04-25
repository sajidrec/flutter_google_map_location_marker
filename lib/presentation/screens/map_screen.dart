import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_map_location_marker/presentation/utility/map_screen_utils.dart';
import 'package:flutter_google_map_location_marker/presentation/widget/create_appbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentPos = const LatLng(0, 0);

  bool _screenShouldLoad = false;

  final List<LatLng> _allLocationTraveled = [];

  late GoogleMapController googleMapController;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getUpdatedLocation() async {
    await takePermission();

    // Geolocator.getPositionStream(
    //   locationSettings: const LocationSettings(
    //     accuracy: LocationAccuracy.best,
    //     timeLimit: Duration(seconds: 10),
    //   ),
    // ).listen((position) async {
    //   _currentPos = LatLng(position.latitude, position.longitude);
    //
    //   _allLocationTraveled.insert(0, _currentPos);
    //
    //   await googleMapController.moveCamera(CameraUpdate.newLatLng(_currentPos));
    //
    //   setState(() {});
    // });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await takePermission();

      final curPos = await Geolocator.getCurrentPosition();

      _currentPos = LatLng(curPos.latitude, curPos.longitude);

      _allLocationTraveled.insert(0, _currentPos);

      await googleMapController.moveCamera(CameraUpdate.newLatLng(_currentPos));

      setState(() {});
    });
  }

  Future<void> _getCurrentPosition() async {
    _screenShouldLoad = false;
    setState(() {});

    await takePermission();

    final curPos = await Geolocator.getCurrentPosition();

    _currentPos = LatLng(curPos.latitude, curPos.longitude);

    _allLocationTraveled.insert(0, _currentPos);

    _screenShouldLoad = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppbar("Real-Time Location Tracker"),
      body: SafeArea(
        child: Visibility(
          visible: _screenShouldLoad && _currentPos != const LatLng(0, 0),
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: GoogleMap(
            onMapCreated: (controller) {
              googleMapController = controller;
              _getUpdatedLocation();
            },
            initialCameraPosition:
                CameraPosition(target: _currentPos, zoom: 17),
            markers: {
              Marker(
                markerId: const MarkerId("currentPosition"),
                position: _currentPos,
                infoWindow: InfoWindow(
                    title: "My current location",
                    snippet:
                        "${_currentPos.latitude} , ${_currentPos.longitude}"),
              ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId("currentPosition"),
                color: Colors.blue,
                width: 5,
                points: _allLocationTraveled,
              )
            },
          ),
        ),
      ),
    );
  }
}
