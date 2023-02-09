import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  // final SettingsController _sc = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // actions: [
        //   TextButton(
        //     onPressed: _saveSettings,
        //     child: const Text(
        //       'Save',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ],
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
                    print(controller.readStorageValue(keyIsDarkTheme));
                  },
                  value: controller.getIsDarkTheme(keyIsDarkTheme),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveSettings() {}
}
