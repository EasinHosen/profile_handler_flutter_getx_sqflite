import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:profile_handler/services/service_profile.dart';
import 'package:workmanager/workmanager.dart';

import '../models/place_model.dart';
import '../services/service_location.dart';
import '../services/service_workmanager.dart';

class ServiceController extends GetxController {
  RxDouble lat = 0.0.obs, lon = 0.0.obs, distance = 0.0.obs;

  List<PlaceModel> listOfPlaces = [];

  // @override
  // void onInit() {
  //   print('second controller init');
  //   _getListOfPlaces();
  //   // enableMonitoring();
  //   super.onInit();
  // }
  //
  // _getListOfPlaces() {
  //   // listOfPlaces.clear();
  //   DBListedPlaces.getListedPlaces().then((value) {
  //     for (var element in value) {
  //       listOfPlaces.add(element);
  //     }
  //   });
  //   print(listOfPlaces.length);
  // }

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
      lat.value = pos.latitude;
      lon.value = pos.longitude;
    } catch (e) {
      rethrow;
    }
  }

  enableMonitoring(var list) async {
    listOfPlaces = list;
    getPermissionStatus();
    // _getListOfPlaces();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    checkDist();
  }

  disableMonitoring() {}

  checkDist() async {
    // print(listOfPlaces.length);
    // RingerModeStatus status = await getCurrentSoundMode();
    if (listOfPlaces.isNotEmpty) {
      print('checking distance');
      await getPosition();
      for (var e in listOfPlaces) {
        // print(e.placeEnabled);
        if (e.placeEnabled) {
          distance.value = Geolocator.distanceBetween(e.placeLat.toDouble(),
              e.placeLon.toDouble(), lat.value, lon.value);

          print(distance.value);
          if (distance.value < 50) {
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
