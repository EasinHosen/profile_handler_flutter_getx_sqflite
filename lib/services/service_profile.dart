import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

Future<RingerModeStatus> getCurrentSoundMode() async {
  RingerModeStatus ringerStatus = RingerModeStatus.unknown;
  try {
    ringerStatus = await SoundMode.ringerModeStatus;
    // print('try block res: $ringerStatus');
  } catch (err) {
    ringerStatus = RingerModeStatus.unknown;
  }
  return ringerStatus;
}

Future<void> getPermissionStatus() async {
  bool? permissionStatus = false;
  try {
    permissionStatus = await PermissionHandler.permissionsGranted;
    if (permissionStatus == false) {
      openDoNotDisturbSettings();
    }
    // print(permissionStatus);
  } catch (err) {
    print(err);
  }
}

Future<void> openDoNotDisturbSettings() async {
  await PermissionHandler.openDoNotDisturbSetting();
}

Future<void> setSilentMode() async {
  try {
    await SoundMode.setSoundMode(RingerModeStatus.silent);
  } on PlatformException {
    // print('Do Not Disturb access permissions required!');
    EasyLoading.showError('DND Access permission required');
  }
}

Future<void> setNormalMode() async {
  try {
    await SoundMode.setSoundMode(RingerModeStatus.normal);
  } on PlatformException {
    EasyLoading.showError('DND Access permission required');
    // print('Do Not Disturb access permissions required!');
  }
}

Future<void> setVibrateMode() async {
  try {
    await SoundMode.setSoundMode(RingerModeStatus.vibrate);
  } on PlatformException {
    EasyLoading.showError('DND Access permission required');
    // print('Do Not Disturb access permissions required!');
  }
}
