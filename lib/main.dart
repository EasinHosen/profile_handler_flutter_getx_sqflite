import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:profile_handler/controllers/place_data_controller.dart';
import 'package:profile_handler/pages/add_new_place.dart';
import 'package:profile_handler/pages/home_page.dart';
import 'package:profile_handler/services/service_location.dart';
import 'package:profile_handler/services/service_profile.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

const simplePeriTask = 'simplePeriodicTask';
const delayedTask = 'Delayed task';
const lat = 23.8527549;
const lon = 90.4121305;
double dist = 0.0;

Future<void> getDistanceSetMode() async {
  final locationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationEnabled) {
    // EasyLoading.showToast('Location is disabled');
    await Geolocator.getCurrentPosition();
    getDistanceSetMode();
  }
  print('before try block');
  try {
    Position pos = await determinePosition();
    dist = Geolocator.distanceBetween(lat, lon, pos.latitude, pos.longitude);
    print('distance: $dist');
    if (dist > 2) {
      setVibrateMode();
    }
  } catch (e) {
    rethrow;
  }
  print('after try block');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // RingerModeStatus _soundMode = RingerModeStatus.unknown;
  // String? _permissionStatus;

  // var _lat1 = 0.0;
  // var _lon1 = 0.0;
  // var _lat2 = 0.0;
  // var _lon2 = 0.0;
  // var dist = 0.0;

  @override
  // void initState() {
  //   super.initState();
  //   // Workmanager().initialize(
  //   //   callbackDispatcher,
  //   //   isInDebugMode: true,
  //   // );
  //   // _getCurrentSoundMode();
  //   // _getPermissionStatus();
  // }

  // Future<void> _getPosition1() async {
  //   final locationEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!locationEnabled) {
  //     // EasyLoading.showToast('Location is disabled');
  //     await Geolocator.getCurrentPosition();
  //     _getPosition1();
  //   }
  //   try {
  //     Position pos = await determinePosition();
  //     setState(() {
  //       // _lat1 = 23.7362801;
  //       // _lon1 = 90.3823502;   //drc location
  //
  //       //_lat1= 23.8527549;
  //       //_lon1 = 90.4121305;     //home loc
  //       _lat1 = pos.latitude;
  //       _lon1 = pos.longitude;
  //       dist = 0.0;
  //       print('lat: $_lat1, lon $_lon1');
  //     });
  //
  //     // print('got first location, now starting delay...');
  //     // Future.delayed(const Duration(seconds: 10)).then((value) {
  //     //   print('Getting position 2...');
  //     //   _getPosition2();
  //     // });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> _getPosition2() async {
  //   final locationEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!locationEnabled) {
  //     // EasyLoading.showToast('Location is disabled');
  //     await Geolocator.getCurrentPosition();
  //     // _getPosition2();
  //   }
  //   try {
  //     Position pos = await determinePosition();
  //     setState(() {
  //       _lat2 = pos.latitude;
  //       _lon2 = pos.longitude;
  //
  //       dist = Geolocator.distanceBetween(_lat1, _lon1, _lat2, _lon2);
  //       print('Distance: $dist');
  //
  //       if (dist > 2) {
  //         setVibrateMode();
  //       }
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..toastPosition = EasyLoadingToastPosition.bottom;

    return GetMaterialApp(
      builder: EasyLoading.init(),
      initialRoute: '/home_page',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      getPages: [
        GetPage(
          name: '/home_page',
          page: () => HomePage(title: 'Profile Handler'),
        ),
        GetPage(
          name: '/add_new_place',
          page: () => const AddNewPlace(title: 'New place'),
        ),
      ],
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Plugin example app'),
      //   ),
      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         const SizedBox(
      //           height: 20,
      //         ),
      //         ElevatedButton(
      //           onPressed: Platform.isAndroid
      //               ? () {
      //                   Workmanager().registerOneOffTask(
      //                     delayedTask,
      //                     delayedTask,
      //                     tag: 'delTask',
      //                     initialDelay: const Duration(seconds: 10),
      //                   );
      //                   print('Task will begin in 10 sec');
      //                   // _getPosition1();
      //                 }
      //               : null,
      //           child: const Text('Delayed task'),
      //         ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         // Text('lat1: $_lat1 \nlon1: $_lon1'),
      //         // ElevatedButton(
      //         //   onPressed: () => _getPosition2(),
      //         //   child: const Text('location2'),
      //         // ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         // Text('lat2: $_lat2 \nlon2: $_lon2'),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         // Text('Distance $dist'),
      //
      //         ElevatedButton(
      //           onPressed: () {
      //             _reset();
      //           },
      //           child: const Text('Reset'),
      //         ),
      //         ElevatedButton(
      //           onPressed: () async {
      //             await Workmanager().cancelByTag('delTask');
      //             print('Delayed task canceled');
      //           },
      //           child: const Text('WM cancel'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

// void _reset() {
//   getCurrentSoundMode().then((value) {
//     print(value);
//     if (value == RingerModeStatus.silent ||
//         value == RingerModeStatus.vibrate) {
//       print('reset inner');
//       setNormalMode();
//     }
//   });
//   // setState(() {
//   //   _lat1 = 0;
//   //   _lat2 = 0;
//   //   _lon1 = 0;
//   //   _lon2 = 0;
//   //   dist = 0;
//   // });
// }

// Future<void> _setSilentMode() async {
//   RingerModeStatus status;
//
//   try {
//     status = await SoundMode.setSoundMode(RingerModeStatus.silent);
//
//     setState(() {
//       _soundMode = status;
//     });
//   } on PlatformException {
//     print('Do Not Disturb access permissions required!');
//   }
// }

// Future<void> _setNormalMode() async {
//   RingerModeStatus status;
//
//   try {
//     status = await SoundMode.setSoundMode(RingerModeStatus.normal);
//     setState(() {
//       _soundMode = status;
//     });
//   } on PlatformException {
//     print('Do Not Disturb access permissions required!');
//   }
// }

// Future<void> _setVibrateMode() async {
//   RingerModeStatus status;
//
//   try {
//     status = await SoundMode.setSoundMode(RingerModeStatus.vibrate);
//
//     setState(() {
//       _soundMode = status;
//     });
//   } on PlatformException {
//     print('Do Not Disturb access permissions required!');
//   }
// }

}
