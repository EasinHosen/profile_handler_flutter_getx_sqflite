import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/service_controller.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
// Mandatory if the App is obfuscated or using Flutter 3.1+

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case taskOneOff:
        print('Task started');
        ServiceController.checkDist();
        break;
    }
    return Future.value(true);
  });
}
