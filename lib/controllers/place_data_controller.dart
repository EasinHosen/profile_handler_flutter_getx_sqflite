import 'package:get/get.dart';

import 'package:profile_handler/db/db_listed_places.dart';
import '../models/place_model.dart';

class PlaceDataController extends GetxController {
  RxList<PlaceModel> listOfPlaces = <PlaceModel>[].obs;

  @override
  void onInit() {
    _getListOfPlaces();
    super.onInit();
  }

  _getListOfPlaces() {
    DBListedPlaces.getListedPlaces().then((value) {
      for (var element in value) {
        listOfPlaces.add(element);
      }
    });
  }

  Future<bool> addNewPlace(PlaceModel placeModel) async {
    final rowId = await DBListedPlaces.createPlace(placeModel);

    if (rowId > 0) {
      placeModel.placeId = rowId;
      // update();
      return true;
    }
    return false;
  }

  void deletePlace(int? placeId) async {
    final rowId = await DBListedPlaces.deletePlace(placeId!);

    if (rowId > 0) {
      listOfPlaces.removeWhere((element) => element.placeId == placeId);
      listOfPlaces.refresh();
      // update();
    }
  }

  void changeEnabled(int index, int id, int val) {
    DBListedPlaces.updateIsEnabled(id, val).then((_) {
      listOfPlaces[index].placeEnabled = !listOfPlaces[index].placeEnabled;
      listOfPlaces.refresh();
      print('Id: $id, En: $val');
    });
  }
}
