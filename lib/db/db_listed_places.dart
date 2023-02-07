import 'package:path/path.dart';
import 'package:profile_handler/constants/constants.dart';
import 'package:profile_handler/models/place_model.dart';
import 'package:sqflite/sqflite.dart';

class DBListedPlaces {
  static const String createTablePlaces = '''create table $tablePlaces(
  $tablePlacesId integer primary key,
  $tablePlacesName text,
  $tablePlacesLat num,
  $tablePlacesLon num,
  $tablePlacesIsEnabled int
  )''';

  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();

    final dbPath = join(rootPath, 'places.db');

    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(createTablePlaces);
    });
  }

  static Future<int> createPlace(PlaceModel placeModel) async {
    final db = await open();

    return db.insert(tablePlaces, placeModel.toMap());
  }

  static deletePlace(int placeId) async {
    final db = await open();

    return db.delete(
      tablePlaces,
      where: '$tablePlacesId = ?',
      whereArgs: [placeId],
    );
  }

  static Future<List<PlaceModel>> getListedPlaces() async {
    final db = await open();

    final List<Map<String, dynamic>> mapList = await db.query(tablePlaces);

    return List.generate(
      mapList.length,
      (index) => PlaceModel.fromMap(mapList[index]),
    );
  }

  static Future<int> updatePlace(PlaceModel placeModel) async {
    final db = await open();

    return db.update(
      tablePlaces,
      {
        tablePlacesId: placeModel.placeId,
        tablePlacesName: placeModel.placeName,
        tablePlacesLat: placeModel.placeLat,
        tablePlacesLon: placeModel.placeLon,
        tablePlacesIsEnabled: placeModel.placeEnabled,
      },
      where: '$tablePlacesId = ?',
      whereArgs: [placeModel.placeId],
    );
  }

  static Future<int> updateIsEnabled(int placeId, int value) async {
    final db = await open();

    return db.update(
      tablePlaces,
      {
        tablePlacesIsEnabled: value,
      },
      where: '$tablePlacesId = ?',
      whereArgs: [placeId],
    );
  }
}
