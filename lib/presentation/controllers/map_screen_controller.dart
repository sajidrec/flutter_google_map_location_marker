import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenController extends GetxController {
  LatLng _currentPos = const LatLng(0, 0);

  get currentPos => _currentPos;

  bool _screenShouldLoad = false;

  get screenShouldLoad => _screenShouldLoad;

  final List<LatLng> _allLocationTraveled = [];

  get allLocationTraveled => _allLocationTraveled;

  late GoogleMapController googleMapController;

  Future<void> _takePermission() async {
    LocationPermission locationPermissionStatus =
        await Geolocator.checkPermission();
    if (locationPermissionStatus == LocationPermission.denied) {
      await Geolocator.requestPermission();
      locationPermissionStatus = await Geolocator.checkPermission();
      if (locationPermissionStatus == LocationPermission.denied) {
        _takePermission();
      }
    } else if (locationPermissionStatus == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      locationPermissionStatus = await Geolocator.checkPermission();
      if (locationPermissionStatus != LocationPermission.always &&
          locationPermissionStatus != LocationPermission.whileInUse) {
        _takePermission();
      }
    }
  }

  Future<void> getUpdatedLocation() async {
    await _takePermission();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    ).listen((position) async {
      _currentPos = LatLng(position.latitude, position.longitude);

      _allLocationTraveled.insert(0, _currentPos);

      await googleMapController.moveCamera(CameraUpdate.newLatLng(_currentPos));

      update();
    });

    // Timer.periodic(const Duration(seconds: 3), (timer) async {
    //   await _takePermission();
    //
    //   final curPos = await Geolocator.getCurrentPosition();
    //
    //   _currentPos = LatLng(curPos.latitude, curPos.longitude);
    //
    //   await googleMapController.moveCamera(CameraUpdate.newLatLng(_currentPos));
    //
    //   _allLocationTraveled.insert(0, _currentPos);
    //
    //   update();
    // });
  }

  Future<void> getCurrentPosition() async {
    _screenShouldLoad = false;
    update();

    await _takePermission();

    final curPos = await Geolocator.getCurrentPosition();

    _currentPos = LatLng(curPos.latitude, curPos.longitude);

    _allLocationTraveled.insert(0, _currentPos);

    _screenShouldLoad = true;
    update();
  }
}
