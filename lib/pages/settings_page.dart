import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/settings_controller.dart';
import 'package:profile_handler/services/service_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: GetBuilder<SettingsController>(
          init: SettingsController(),
          builder: (controller) => Column(
            children: [
              ListTile(
                title: const Text('Dark theme'),
                trailing: Switch(
                  onChanged: (value) {
                    controller.setIsDarkTheme(keyIsDarkTheme, value);
                    Get.changeTheme(controller.theme);
                    value
                        ? EasyLoading.showToast('Dark theme enabled')
                        : EasyLoading.showToast('Dark theme disabled');
                  },
                  value: controller.getIsDarkTheme(keyIsDarkTheme),
                ),
              ), //theme settings
              ListTile(
                title: const Text('Notification'),
                trailing: Switch(
                  onChanged: (value) {
                    AwesomeNotifications().isNotificationAllowed().then(
                          (isAllowed) => {
                            if (!isAllowed)
                              {
                                AwesomeNotifications()
                                    .requestPermissionToSendNotifications()
                              }
                            else
                              {
                                controller.setIsNotificationEnabled(
                                  keyIsNotificationEnabled,
                                  value,
                                ),
                              }
                          },
                        );
                    value
                        ? EasyLoading.showToast('Notification enabled')
                        : EasyLoading.showToast('Notification disabled');
                  },
                  value: controller
                      .getIsNotificationEnabled(keyIsNotificationEnabled),
                ),
              ), //Notification settings
              ListTile(
                title: const Text('Radius'),
                subtitle:
                    Text('${controller.getDefaultDistance(keyDistance)} meter'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text("Select Radius"),
                          children: [
                            ...controller.distanceList.map((value) {
                              return SimpleDialogOption(
                                child: Text(
                                  value.toString(),
                                ),
                                onPressed: () {
                                  controller.setDefaultDistance(
                                      keyDistance, value);
                                  EasyLoading.showToast(
                                      'Radius set to $value meters');
                                  Navigator.pop(context);
                                },
                              );
                            }),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: const Text('Frequency(min 15)'),
                subtitle: Text(
                    '${controller.getDefaultDuration(keyFrequency)} minutes'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text("Select frequency"),
                          children: [
                            ...controller.durationList.map((value) {
                              return SimpleDialogOption(
                                child: Text(
                                  value.toString(),
                                ),
                                onPressed: () {
                                  controller.setDefaultDuration(
                                      keyFrequency, value);
                                  EasyLoading.showToast(
                                      'Frequency set to $value minutes');
                                  Navigator.pop(context);
                                },
                              );
                            }),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: const Text('Default mode'),
                subtitle: Text(controller.getProfileMode(keyProfileMode)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text("Select Default mode"),
                          children: [
                            ...controller.modeList.map((value) {
                              return SimpleDialogOption(
                                child: Text(
                                  value,
                                ),
                                onPressed: () {
                                  controller.setProfileMode(
                                      keyProfileMode, value);
                                  EasyLoading.showToast(
                                      'Default mode set to $value mode');
                                  Navigator.pop(context);
                                },
                              );
                            }),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setNormalMode();
                },
                child: const Text('Normal mode'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Please restart monitoring after changing current settings!!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
