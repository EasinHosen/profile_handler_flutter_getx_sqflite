import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:profile_handler/constants/constants.dart';

class SettingsController extends GetxController {
  void setMonitoring(String key, bool val) {
    GetStorage().write(key, val);
    update();
  }

  bool getMonitoringVal(key) => GetStorage().read(key) ?? false;

  void setIsDarkTheme(String key, bool val) {
    GetStorage().write(key, val);
    update();
  }

  bool getIsDarkTheme(key) => GetStorage().read(key) ?? false;

  ThemeData get theme => getIsDarkTheme(keyIsDarkTheme)
      ? ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
        )
      : ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
        );

  void setDefaultDistance(String key, double val) {
    GetStorage().write(key, val);
    update();
  }

  double getDefaultDistance(key) => GetStorage().read(key) ?? 50;

  void setDefaultDuration(String key, double val) {
    GetStorage().write(key, val);
    update();
  }

  double getDefaultDuration(key) => GetStorage().read(key) ?? 15;

  readStorageValue(key) => GetStorage().read(key);
}
