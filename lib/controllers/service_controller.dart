import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/place_data_controller.dart';
import 'package:profile_handler/controllers/settings_controller.dart';
import 'package:profile_handler/db/db_listed_places.dart';
import 'package:profile_handler/services/service_profile.dart';
import 'package:workmanager/workmanager.dart';

import '../models/place_model.dart';
import '../services/service_location.dart';
import '../services/service_workmanager.dart';

class ServiceController extends GetxController {
  static double lat = 0.0, lon = 0.0, distance = 0.0;

  // static List<PlaceModel> listOfPlaces = [];

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

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    // await Workmanager().registerPeriodicTask(
    //   '1',
    //   periodicTaskBG,
    // );
    await Workmanager().registerOneOffTask(
      '2',
      taskOneOff,
      initialDelay: const Duration(seconds: 5),
    );
    print('monitor enabled');
  }

  disableMonitoring() async {
    SettingsController().setMonitoring(keyMonitor, false);
    await Workmanager().cancelAll();
    print('monitor disabled');
  }

  static checkDist() async {
    var listOfPlaces = [];
    DBListedPlaces.getListedPlaces().then((value) {
      print('Inside db');
      for (var e in value) {
        listOfPlaces.add(e);
      }
    });
    Future.delayed(const Duration(seconds: 3));
    print(listOfPlaces.length);
    if (listOfPlaces.isNotEmpty) {
      print('checking distance');
      await getPosition();
      for (var e in listOfPlaces) {
        // print(e.placeEnabled);
        if (e.placeEnabled) {
          distance = Geolocator.distanceBetween(
              e.placeLat.toDouble(), e.placeLon.toDouble(), lat, lon);

          print(distance);
          if (distance < 50) {
            print('condition met');
            // setVibrateMode();
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
    // listOfPlaces.clear();
  }
}
