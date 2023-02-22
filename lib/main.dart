import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/settings_controller.dart';
import 'package:profile_handler/pages/add_new_place.dart';
import 'package:profile_handler/pages/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:profile_handler/pages/settings_page.dart';
import 'package:profile_handler/services/service_workmanager.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Workmanager().initialize(
    callbackDispatcher,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'test_key',
          channelName: 'KKEB',
          channelDescription: 'Channel Desc'),
    ],
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..toastPosition = EasyLoadingToastPosition.bottom;

    final settingsController = Get.put(SettingsController());

    return GetMaterialApp(
      builder: EasyLoading.init(),
      initialRoute: pageHome,
      debugShowCheckedModeBanner: false,
      theme: settingsController.theme,
      getPages: [
        GetPage(
          name: pageHome,
          page: () => HomePage(title: 'Profile Handler'),
        ),
        GetPage(
          name: pageAddNewPlace,
          page: () => const AddNewPlace(title: 'Add new place'),
        ),
        GetPage(
          name: pageSettings,
          page: () => SettingsPage(title: 'Settings'),
        ),
      ],
    );
  }
}
