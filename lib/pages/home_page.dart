import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/place_data_controller.dart';
import 'package:profile_handler/controllers/service_controller.dart';
import 'package:profile_handler/controllers/settings_controller.dart';
import 'package:profile_handler/models/place_model.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final PlaceDataController _pdc = Get.put(PlaceDataController());
  final ServiceController _sc = Get.put(ServiceController());
  final SettingsController _setC = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // actions: [
        //   PopupMenuButton(
        //
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         child: Text(
        //           _setC.getMonitoringVal(keyMonitor)
        //               ? 'Disable monitoring'
        //               : 'Enable monitoring',
        //         ),
        //         onTap: () {
        //           _setC.getMonitoringVal(keyMonitor)
        //               ? _sc.disableMonitoring()
        //               : _sc.enableMonitoring();
        //           // _sc.enableMonitoring();
        //         },
        //       ),
        //       PopupMenuItem(
        //         child: const Text(
        //           'Settings',
        //         ),
        //         onTap: () {
        //           // Get.toNamed(pageSettings);
        //         },
        //       ),
        //     ],
        //   ),
        // ],
        actions: [
          PopupMenuButton(
            onSelected: (result) {
              switch (result) {
                case 0:
                  _setC.getMonitoringVal(keyMonitor)
                      ? _sc.disableMonitoring()
                      : _sc.enableMonitoring();
                  break;
                case 1:
                  Get.toNamed(pageSettings);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  _setC.getMonitoringVal(keyMonitor)
                      ? 'Disable monitoring'
                      : 'Enable monitoring',
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Settings page'),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed(
            pageAddNewPlace,
          )?.then((value) {
            if (value != null) {
              _pdc.listOfPlaces.add(value as PlaceModel);
              print(value);
            } else {
              EasyLoading.showError('Operation canceled');
            }
          });
        },
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.builder(
            itemCount: _pdc.listOfPlaces.length,
            itemBuilder: (context, index) {
              final place = _pdc.listOfPlaces[index];
              return ListTile(
                title: Text(place.placeName),
                subtitle:
                    Text('Lat: ${place.placeLat}\nLon: ${place.placeLon}'),
                onTap: () {
                  print('${place.placeName} ${place.placeId} $index');
                },
                onLongPress: () {
                  Get.defaultDialog(
                    title: 'Attention!!',
                    middleText: 'Do you want to delete ${place.placeName}?',
                    // content: //or this can be used
                    // actions:
                    textConfirm: 'yes',
                    textCancel: 'no',
                    onConfirm: () {
                      _pdc.deletePlace(place.placeId);
                      EasyLoading.showSuccess(
                          '${place.placeName} was deleted.');
                      Get.back();
                    },
                    onCancel: () {
                      print('Canceled');
                      Get.back();
                    },
                    barrierDismissible: false,
                  );
                },
                trailing: Switch(
                  value: place.placeEnabled,
                  onChanged: (value) {
                    final val = place.placeEnabled ? 0 : 1;
                    _pdc.changeEnabled(index, place.placeId!, val);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
