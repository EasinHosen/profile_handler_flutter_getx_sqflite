import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
// Mandatory if the App is obfuscated or using Flutter 3.1+

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      // case simplePeriTask:
      //   print('$simplePeriTask was executed');
      //   break;
      // case delayedTask:
      //   await getDistanceSetMode();
      //   print('$delayedTask was executed');
      //   break;
    }
    return Future.value(true);
  });
}
