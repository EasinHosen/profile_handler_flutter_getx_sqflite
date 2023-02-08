import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/settings_controller.dart';
import 'package:profile_handler/services/service_profile.dart';
import '../models/place_model.dart';
import '../services/service_location.dart';

class ServiceController extends GetxController {
  static double lat = 0.0, lon = 0.0, distance = 0.0;

  static List<PlaceModel> listOfPlacesSt = [];

  static Future<void> getPosition() async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      EasyLoading.showToast('Location is disabled');
      await Geolocator.requestPermission();
      await Geolocator.getCurrentPosition();
      getPosition();
    }
    try {
      Position pos = await determinePosition();
      lat = pos.latitude;
      lon = pos.longitude;
    } catch (e) {
      rethrow;
    }
  }

  enableMonitoring() async {
    SettingsController().setMonitoring(keyMonitor, true);
    getPermissionStatus();

    await Workmanager().registerOneOffTask(
      '2',
      taskOneOff,
      initialDelay: const Duration(seconds: 5),
    );
    print('monitor enabled');
    print('st list item: ${listOfPlacesSt.length}');

    // Future.delayed(const Duration(seconds: 5)).then((value) => checkDist());
  }

  disableMonitoring() async {
    SettingsController().setMonitoring(keyMonitor, false);
    await Workmanager().cancelAll();
    print('monitor disabled');
    print('st list item: ${listOfPlacesSt.length}');
  }

  static checkDist() async {
    print(listOfPlacesSt.length);
    if (listOfPlacesSt.isNotEmpty) {
      print('checking distance');
      await getPosition();
      for (var e in listOfPlacesSt) {
        if (e.placeEnabled) {
          distance = Geolocator.distanceBetween(
              e.placeLat.toDouble(), e.placeLon.toDouble(), lat, lon);
          if (distance < SettingsController().getDefaultDistance(keyDistance)) {
            print('condition met');
            setSilentMode();
            break;
          } else {
            print('condition not met');
          }
        } else {
          print('not enabled');
          setNormalMode();
        }
      }
    } else {
      print('Empty list');
    }
  }
}
