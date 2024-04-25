import 'package:geolocator/geolocator.dart';

Future<void> takePermission() async {
  LocationPermission locationPermissionStatus =
      await Geolocator.checkPermission();
  if (locationPermissionStatus == LocationPermission.denied) {
    await Geolocator.requestPermission();
    locationPermissionStatus = await Geolocator.checkPermission();
    if (locationPermissionStatus == LocationPermission.denied) {
      takePermission();
    }
  } else if (locationPermissionStatus == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();
    locationPermissionStatus = await Geolocator.checkPermission();
    if (locationPermissionStatus != LocationPermission.always &&
        locationPermissionStatus != LocationPermission.whileInUse) {
      takePermission();
    }
  }
}
