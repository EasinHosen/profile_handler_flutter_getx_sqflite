import 'package:geolocator/geolocator.dart';
import 'package:profile_handler/db/db_listed_places.dart';
import 'package:workmanager/workmanager.dart';

import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/service_controller.dart';

@pragma('vm:entry-point')
// Mandatory if the App is obfuscated or using Flutter 3.1+

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case taskPeriodicBG:
        var list = await DBListedPlaces.getListedPlaces();
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        ServiceController.checkDist(list, userLocation);
        break;
    }
    return Future.value(true);
  });
}
