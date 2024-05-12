import 'package:flutter_google_map_location_marker/presentation/controllers/map_screen_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(MapScreenController());
  }
}
