import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/settings_controller.dart';
import 'package:profile_handler/services/service_profile.dart';
import '../services/service_location.dart';

class ServiceController extends GetxController {
  double lat = 0.0, lon = 0.0, distance = 0.0;

  Future<void> getPosition() async {
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

  Future<void> enableMonitoring() async {
    bool status = await getPermissionStatus();
    if (!status) {
      openDoNotDisturbSettings();
    }
    final locationCheck = await Geolocator.isLocationServiceEnabled();
    if (!locationCheck) {
      EasyLoading.showError('Location Disabled!!');
      await Geolocator.getCurrentPosition();
      enableMonitoring();
    } else {
      SettingsController().setMonitoring(keyMonitor, true);
      await Workmanager().registerPeriodicTask(
        '1',
        taskPeriodicBG,
        initialDelay: Duration(
          minutes: SettingsController().getDefaultDuration(keyFrequency),
          // seconds: 10,
        ),
        frequency: Duration(
          minutes: SettingsController().getDefaultDuration(keyFrequency),
        ),
        inputData: {
          'defDist': SettingsController().getDefaultDistance(keyDistance),
          'defMode': SettingsController().getProfileMode(keyProfileMode),
        },
      );
      print('monitor enabled');
      EasyLoading.showToast('Monitoring Enabled');
    }
  }

  Future<void> disableMonitoring() async {
    SettingsController().setMonitoring(keyMonitor, false);
    await Workmanager().cancelAll();
    print('monitor disabled');
    EasyLoading.showToast('Monitoring Disabled');
  }

  static checkDist(var list, Position position, double defDist, String mode) {
    double lat, lon, distance;

    lat = position.latitude;
    lon = position.longitude;
    if (list.isNotEmpty) {
      print('checking distance');
      for (var e in list) {
        if (e.placeEnabled) {
          distance = Geolocator.distanceBetween(
              e.placeLat.toDouble(), e.placeLon.toDouble(), lat, lon);
          if (distance < defDist) {
            print('condition met');
            print('cuDist: $distance, defDist: $defDist, defMode: $mode');
            // setSilentMode();
            mode == 'Vibration' ? setVibrateMode() : setSilentMode();
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
