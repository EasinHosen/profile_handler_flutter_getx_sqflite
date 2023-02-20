import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:led_bulb_indicator/led_bulb_indicator.dart';
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
    _setC.monitorEnable.value = _setC.getMonitoringVal(keyMonitor);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Obx(
              () => LedBulbIndicator(
                initialState: _setC.monitorEnable.value
                    ? LedBulbColors.green
                    : LedBulbColors.red,
                size: 10,
                margin: 5,
                glow: true,
              ),
            ),
            Text(title),
          ],
        ),
        actions: [
          PopupMenuButton(
            onSelected: (result) {
              switch (result) {
                case 0:
                  _setC.getMonitoringVal(keyMonitor)
                      ? _sc
                          .disableMonitoring()
                          .then((value) => _setC.monitorEnable.value = false)
                      : _sc
                          .enableMonitoring()
                          .then((value) => _setC.monitorEnable.value = true);
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
                child: Text('Settings'),
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
              if (kDebugMode) {
                print(value);
              }
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
                onTap: () {
                  if (kDebugMode) {
                    print('${place.placeName} ${place.placeId} $index');
                  }
                  _pdc.placeNameController.text = place.placeName;
                  Get.defaultDialog(
                      title: '',
                      barrierDismissible: false,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _pdc.placeNameController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              labelText: 'Place Name',
                              hintMaxLines: 1,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 4.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Obx(
                            () => Text(
                              _pdc.placeNameEmpty.value
                                  ? 'Place name can not be left empty!!'
                                  : '',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12.0),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _pdc.placeNameEmpty.value = false;
                                  Get.back();
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_pdc
                                      .placeNameController.text.isNotEmpty) {
                                    _pdc.updatePlaceName(index, place.placeId!,
                                        _pdc.placeNameController.text);
                                    _pdc.placeNameEmpty.value = false;
                                    Get.back();
                                  } else {
                                    _pdc.placeNameEmpty.value = true;
                                  }
                                },
                                child: const Text(
                                  'Save',
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      radius: 10.0);
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
                      if (kDebugMode) {
                        print('Canceled');
                      }
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
