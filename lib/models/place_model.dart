import 'package:profile_handler/constants/constants.dart';

class PlaceModel {
  int? placeId;
  num placeLat, placeLon;
  String placeName;
  bool placeEnabled;

  PlaceModel({
    this.placeId,
    required this.placeLat,
    required this.placeLon,
    required this.placeName,
    this.placeEnabled = true,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      placeId: map[tablePlacesId],
      placeLat: map[tablePlacesLat],
      placeLon: map[tablePlacesLon],
      placeName: map[tablePlacesName],
      placeEnabled: map[tablePlacesIsEnabled] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      tablePlacesId: placeId,
      tablePlacesLat: placeLat,
      tablePlacesLon: placeLon,
      tablePlacesName: placeName,
      tablePlacesIsEnabled: placeEnabled,
    };
  }

  @override
  String toString() {
    return 'PlaceModel{placeId: $placeId, placeLat: $placeLat, '
        'placeLon: $placeLon, placeName: $placeName, '
        'placeEnabled: $placeEnabled}';
  }
}
