import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/controllers/place_data_controller.dart';
import 'package:profile_handler/controllers/service_controller.dart';
import 'package:profile_handler/models/place_model.dart';

class AddNewPlace extends StatefulWidget {
  const AddNewPlace({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final placeNameEditController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  double _lat = 0;
  double _lon = 0;

  final PlaceDataController _pdc = Get.find();

  final ServiceController _sCon = Get.find();

  @override
  void dispose() {
    // TODO: implement dispose
    placeNameEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: _savePlace,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 8,
          right: 8,
        ),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: placeNameEditController,
                decoration: const InputDecoration(
                  labelText: 'Name of the place',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The place should have a name!!';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _lat == 0 ? 'Latitude' : 'Latitude: $_lat',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _lon == 0 ? 'Longitude' : 'Longitude: $_lon',
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: _getLocation,
                        icon: const Icon(Icons.share_location),
                      ),
                      const Center(
                        child: Text(
                          'Get current location',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: _getFromMap,
                        icon: const Icon(Icons.map_rounded),
                      ),
                      const Center(
                        child: Text(
                          'Select from map',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePlace() async {
    if (formKey.currentState!.validate()) {
      final place = PlaceModel(
          placeLat: _lat,
          placeLon: _lon,
          placeName: placeNameEditController.text);
      // print(place);
      _pdc.addNewPlace(place).then(
            (value) => {
              if (value)
                {
                  Get.back(result: place),
                  EasyLoading.showSuccess('Place saved'),
                }
              else
                EasyLoading.showError('Failed to save data'),
            },
          );
    }
  }

  void _getLocation() async {
    await _sCon.getPosition();
    setState(
      () {
        _lat = _sCon.lat;
        _lon = _sCon.lon;
      },
    );
  }

  void _getFromMap() {
    Get.toNamed(pageMap)?.then((value) {
      if (value != null) {
        setState(() {
          _lat = value!.latitude;
          _lon = value!.longitude;
        });
      } else {
        EasyLoading.showError('No place selected!');
      }
    });
  }
}
