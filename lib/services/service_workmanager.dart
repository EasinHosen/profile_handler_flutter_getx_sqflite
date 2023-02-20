import 'package:geolocator/geolocator.dart';
import 'package:profile_handler/db/db_listed_places.dart';
import 'package:profile_handler/models/place_model.dart';
import 'package:workmanager/workmanager.dart';

import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/service_controller.dart';

@pragma('vm:entry-point')
// Mandatory if the App is obfuscated or using Flutter 3.1+

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case taskPeriodicBG:
        Position? userLocation;
        try {
          userLocation = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(minutes: 1),
          );
        } catch (e) {
          userLocation = await Geolocator.getLastKnownPosition();
        }
        if (userLocation == null) {
          //send user a notification
        } else {
          List<PlaceModel> list = await DBListedPlaces.getListedPlaces();
          double defDist = inputData!['defDist'];
          String mode = inputData['defMode'];
          bool isNotificationEnabled = inputData['notification'];
          ServiceController.takeAction(
            list,
            userLocation,
            defDist,
            mode,
            isNotificationEnabled,
          );
        }
        break;
    }
    return Future.value(true);
  });
}
