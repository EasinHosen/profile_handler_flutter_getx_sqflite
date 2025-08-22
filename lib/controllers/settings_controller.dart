import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:profile_handler/constants/constants.dart';

class SettingsController extends GetxController {
  RxBool monitorEnable = false.obs;

  List<String> modeList = [
    'Vibration',
    'Silent',
  ];
  List<int> durationList = [
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
  ];
  List<double> distanceList = [
    50.0,
    60.0,
    70.0,
    80.0,
    90.0,
    100.0,
  ];

  void setProfileMode(String key, String mode) {
    GetStorage().write(key, mode);
    update();
  }

  String getProfileMode(key) => GetStorage().read(key) ?? 'Vibration';

  void setMonitoring(String key, bool val) {
    GetStorage().write(key, val);
    update();
  }

  bool getMonitoringVal(key) => GetStorage().read(key) ?? false;

  void setIsNotificationEnabled(String key, bool val) {
    GetStorage().write(key, val);
    update();
  }

  bool getIsNotificationEnabled(key) => GetStorage().read(key) ?? false;

  void setIsDarkTheme(String key, bool val) {
    GetStorage().write(key, val);
    update();
  }

  bool getIsDarkTheme(key) => GetStorage().read(key) ?? false;

  ThemeData get theme => getIsDarkTheme(keyIsDarkTheme)
      ? ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.teal,
          colorScheme: const ColorScheme.dark(primary: Colors.teal),
          appBarTheme: const AppBarTheme().copyWith(
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
            color: Colors.teal,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
          ),
        )
      : ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.teal,
          colorScheme: const ColorScheme.light(primary: Colors.teal),
          appBarTheme: const AppBarTheme().copyWith(
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
            color: Colors.teal,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
          ));

  void setDefaultDistance(String key, double val) {
    GetStorage().write(key, val);
    update();
  }

  double getDefaultDistance(key) => GetStorage().read(key) ?? 50.0;

  void setDefaultDuration(String key, int val) {
    GetStorage().write(key, val);
    update();
  }

  int getDefaultDuration(key) => GetStorage().read(key) ?? 15;

  readStorageValue(key) => GetStorage().read(key);
}
