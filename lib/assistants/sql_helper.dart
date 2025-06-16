import 'dart:developer';

import 'package:naturascan/models/local/etapeModel.dart';
import 'package:naturascan/models/local/gpsTrackModel.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:uuid/uuid.dart';

class SQLHelper {
  static Future<void> createDatabaseTableQuerry(
      sqflite.Database database) async {
    await database.execute("""
  CREATE TABLE CategorySpecies (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    especes TEXT,
    created_at TEXT,
    updated_at TEXT
)
  """);
    await database.execute("""
  CREATE TABLE GpsTrack (
    id TEXT PRIMARY KEY,
    longitude TEXT,
    latitude TEXT,
    device TEXT,
    shipping_id TEXT,
    inObservation INTEGER,
    created_at TEXT NOT NULL,
    updated_at TEXT
)
  """);
    await database.execute("""
  CREATE TABLE Leg (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    shipping_id INTEGER,
    arrival_at TEXT,
    departure_at TEXT,
    longitude REAL,
    latitude REAL,
    FOREIGN KEY (shipping_id) REFERENCES Shipping (id)
)
  """);
    await database.execute("""
  CREATE TABLE Policy (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    enabled INTEGER
)
  """);
    await database.execute("""
  CREATE TABLE SeaAnimalObservation (
    id INTEGER PRIMARY KEY,
    espece TEXT,
    taille TEXT,
    nbre_estime INTEGER,
    nbre_mini INTEGER,
    nbre_maxi INTEGER,
    nbre_jeunes INTEGER,
    nbre_nouveau_ne INTEGER,
    structure_groupe TEXT,
    sous_group INTEGER,
    nbre_sous_groupes INTEGER,
    nbre_indiv_sous_groupe INTEGER,
    comportement_surface TEXT,
    vitesse TEXT,
    reaction_bateau TEXT,
    distance_estimee TEXT,
    gisement TEXT,
    element_detection TEXT,
    especes_associees TEXT,
    heure_debut INTEGER,
    heure_fin INTEGER,
    location_d TEXT,
    location_f TEXT,
    vitesse_navire TEXT,
    weather_report TEXT,
    activites_humaines_associees TEXT,
    effort INTEGER,
    commentaires TEXT,
    photos INTEGER,
    images TEXT
)
  """);
    await database.execute("""
  CREATE TABLE SeaBirdObservation(
    id INTEGER PRIMARY KEY,
    espece TEXT,
    nbre_estime INTEGER,
    presence_jeune INTEGER,
    etat_groupe TEXT,
    comportement TEXT,
    reaction_bateau TEXT,
    distance_estimee TEXT,
    gisement TEXT,
    element_detection TEXT,
    especes_associees TEXT,
    heure_debut INTEGER,
    heure_fin INTEGER,
    location_d TEXT,
    location_f TEXT,
    vitesse_navire TEXT,
    weather_report TEXT,
    activites_humaines_associees TEXT,
    effort INTEGER,
    commentaires TEXT,
    photos INTEGER,
    images TEXT
  )
  """);
      await database.execute("""
  CREATE TABLE SeaWasteObservation(
    id INTEGER PRIMARY KEY,
    nature_deche TEXT,
    estimated_size TEXT,
    matiere TEXT,
    color TEXT,
    deche_peche INTEGER,
    picked INTEGER,
    heure_debut INTEGER,
    location TEXT,
    vitesse_navire TEXT,
    weather_report TEXT,
    effort INTEGER,
    commentaires TEXT,
    photos INTEGER,
    images TEXT
  )
  """);
    await database.execute("""
  CREATE TABLE Shipping (
    id INTEGER PRIMARY KEY,
    date_planning TEXT,
    total_observers INTEGER,
    description TEXT,
    shipping_start_at TEXT,
    shipping_end_at TEXT,
    departure_weather_report_id INTEGER,
    arrival_weather_report_id INTEGER,
    departure_extra_comment TEXT,
    arrival_extra_comment TEXT,
    shipping_status TEXT,
    type TEXT,
    created_at TEXT,
    created_by_id INTEGER,
    FOREIGN KEY (departure_weather_report_id) REFERENCES WeatherReport (id),
    FOREIGN KEY (arrival_weather_report_id) REFERENCES WeatherReport (id),
    FOREIGN KEY (created_by_id) REFERENCES user (id)
)
  """);
    await database.execute("""
  CREATE TABLE Species (
    id INTEGER PRIMARY KEY,
    common_name TEXT,
    scientific_name TEXT,
    description TEXT,
    category TEXT
  )
  """);
    await database.execute("""
  CREATE TABLE ObservationsTraces (
    id TEXT PRIMARY KEY,
    secteur TEXT,
    sous_secteur TEXT,
    plage TEXT,
    suivi INTEGER,
    heure INTEGER,
    weather_report TEXT,
    remark TEXT,
    location TEXT,
    photos TEXT,
    prospection_id TEXT,
    presence_nid TEXT,
    emergence TEXT,
    esclavation TEXT,
    shipping_id TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT
  )
  """);
    await database.execute("""
  CREATE TABLE user (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT,
    firstname TEXT,
    email TEXT,
    mobile_number TEXT,
    adress TEXT,
    roles TEXT,
    access TEXT,
    total_export INTEGER,
    pseudo TEXT,
    created_at TEXT NOT NULL
)
  """);
    await database.execute("""
  CREATE TABLE role (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    enabled TEXT,
    isSysRole INTEGER
)
  """);
    await database.execute("""
  CREATE TABLE userRole (
    user_id INTEGER,
    role_id INTEGER,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user (id),
    FOREIGN KEY (role_id) REFERENCES role (id)
)
  """);
    await database.execute("""
  CREATE TABLE WasteObservation (
    id INTEGER PRIMARY KEY,
    estimated_size TEXT,
    material TEXT,
    is_fishing_waste INTEGER,
    collected INTEGER,
    color TEXT,
    waste_id INTEGER,
    FOREIGN KEY (waste_id) REFERENCES Waste (id)
)
  """);
    await database.execute("""
  CREATE TABLE Waste (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT
  )
  """);
    await database.execute("""
  CREATE TABLE WeatherReport (
    id INTEGER PRIMARY KEY,
    sea_state TEXT,
    cloud_cover TEXT,
    visibility TEXT,
    wind_force TEXT,
    wind_direction TEXT,
    wind_speed TEXT
  )
  """);
    await database.execute("""
  CREATE TABLE ZoneModel (
    id INTEGER PRIMARY KEY,
    name TEXT,
    nbre_points INTEGER,
    points TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT
  )
  """);
    await database.execute("""
    CREATE TABLE Sorties(
      id TEXT PRIMARY KEY NOT NULL,
      type TEXT,
      date INTEGER,
      photo TEXT,
      naturascan TEXT,
      obstrace TEXT,
      finished INTEGER,
      synchronised INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT
    )
  """);
    await database.execute("""
    CREATE TABLE Etapes(
        id TEXT PRIMARY KEY,
        shipping_id TEXT,
        nom TEXT,
        description TEXT,
        point_de_passage TEXT,
        heure_depart_port INTEGER,
        heure_arrivee_port INTEGER,
        departure_weather_report TEXT,
        arrival_weather_report TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
    )
  """);
    await database.execute("""
    CREATE TABLE Observations(
        id TEXT PRIMARY KEY,
        shipping_id TEXT,
        date INTEGER,
        type INTEGER,
        categorie_id INTEGER,
        animal TEXT,
        bird TEXT,
        waste TEXT,
        photograph TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
    )
  """);
  }

  static Future<sqflite.Database> createDatabase() async {
    return sqflite.openDatabase('naturatest2.db', version: 1, onOpen: (db) {},
        onCreate: (sqflite.Database database, int version) async {
      await createDatabaseTableQuerry(database);
    });
  }

  static Future<int> createItemWithTransaction(
      dynamic item, String table) async {
    final db = await SQLHelper.createDatabase();

    final data = item.toJson();

    int? id;

    await db.transaction((txn) async {
      id = await txn.insert(table, data,
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    });

    return id ??
        -1; // Si id est null, retourne -1 (ou une valeur par défaut) pour indiquer une erreur.
  }

  static Future<int> createItem(dynamic item, String table) async {
    try {
      print("-----------*-------");
      item['id'] = const Uuid().v4();
      item['created_at'] = DateTime.now().toIso8601String();
      final db = await SQLHelper.createDatabase();

      final id = await db.insert(table, item,
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
      print("successfully creatio $id");
      return id;
    } catch (e) {
      print('Erreur lors de la création de l\'élément : $e');
      return -1; // Ou une valeur par défaut pour indiquer une erreur
    }
  }

 static Future<int> createItem2(dynamic item, String table) async {
    try {
      final db = await SQLHelper.createDatabase();

      final id = await db.insert(table, item,
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
      print("successfully creatio $id");
      return id;
    } catch (e) {
      print('Erreur lors de la création de l\'élément : $e');
      return -1; // Ou une valeur par défaut pour indiquer une erreur
    }
  }


  static Future<int> updateItem(
      String id, Map<String, Object?> data, String table) async {
    print("------------------");
    print("---------*---------");
    print(' la data estr $data');
    print("------------------");
    print("-----------*-------");
    try {
      final db = await SQLHelper.createDatabase();

      final result =
          await db.update(table, data, where: "id = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'élément : $e');
      return -1; // Ou une valeur par défaut pour indiquer une erreur
    }
  }

  static Future<void> deleteItem(String id, String table) async {
    try {
      final db = await SQLHelper.createDatabase();
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print('Erreur lors de la suppression de l\'élément : $err');
      // Gérer l'erreur de suppression, si nécessaire
    }
  }

  static Future<List<Map<String, dynamic>>> getItem(
      String id, String table) async {
    final db = await SQLHelper.createDatabase();
    return db.query(table, where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getItems({
    required String table,
    required int limit,
    required int offset,
  }) async {
    try {
      final sqflite.Database db = await createDatabase();
      return db.query(table,
          limit: limit, offset: offset, orderBy: "created_at DESC");
    } catch (e) {
      print('Erreur lors de la récupération des éléments : $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }

  static Future<List<Map<String, dynamic>>> getLatestItems(
      {required String table, required int limit}) async {
    try {
      final sqflite.Database db = await createDatabase();
      return db.query(table, limit: limit, orderBy: "created_at DESC");
    } catch (e) {
      print('Erreur lors de la récupération des éléments : $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }

  static Future<List<Map<String, dynamic>>> getAllItems(String table) async {
    try {
      final db = await SQLHelper.createDatabase();
      return db.query(table, orderBy: "created_at DESC");
    } catch (e) {
      print('Erreur lors de la récupération de tous les éléments : $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }

  // Function to delete a specific table
  static Future<void> deleteTable(String tableName) async {
    try {
      final db = await SQLHelper.createDatabase();
      await db.delete(tableName); // Deletes all rows from the table
      print('Table $tableName has been cleared');
    } catch (e) {
      print(
          'Erreur lors de la suppression des données de la table $tableName : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUsersWithRoles() async {
    final db = await SQLHelper.createDatabase();
    return db.rawQuery('''
      SELECT
      user.*, 
      role.*
    FROM
      user
    LEFT JOIN
      userRole ON user.id = userRole.user_id
    LEFT JOIN
      role ON userRole.role_id = role.id
    GROUP BY
      user.id, role.id
  ''');
  }

  static Future<List<EtapeModel>> getEtapesByShippingIdPaginated({
    required int limit,
    required int offset,
    required String shippingId,
  }) async {
    try {
      final sqflite.Database db = await createDatabase();
      final List<Map<String, dynamic>> shippingEtapeList = await db.query(
        "Etapes",
        where: 'shipping_id = ?',
        whereArgs: [shippingId],
        offset: offset,
        limit: limit,orderBy: "created_at DESC"
      );

      return shippingEtapeList
          .map((cardMap) => EtapeModel.fromJson(cardMap))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des etapes : $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }

  static Future<List<ObservationModel>> getObservationsByTypePaginated(
      {required int limit,
      required int offset,
      required int type,
      required String shippingID}) async {
    try {
      final sqflite.Database db = await createDatabase();
      final List<Map<String, dynamic>> etapeObservationList = await db.query(
        "Observations",
        where: 'categorie_id = ? AND shipping_id = ?',
        whereArgs: [type, shippingID],
        offset: offset,
        limit: limit,orderBy: "created_at DESC"
      );

      return etapeObservationList
          .map((observationMap) => ObservationModel.fromJson(observationMap))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des observations: $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }

 static Future<List<ObservationTrace>> getObservationsTracesBySippingPaginated(
      {required int limit,
      required int offset,
      required String shippingID}) async {
    try {
      final sqflite.Database db = await createDatabase();
      final List<Map<String, dynamic>> observationsTraceList = await db.query(
        "ObservationsTraces",
        where: 'shipping_id = ?',
        whereArgs: [shippingID],
        offset: offset,
        limit: limit,orderBy: "created_at DESC"
      );

      return observationsTraceList
          .map((observationMap) => ObservationTrace.fromJson(observationMap))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des observations traces: $e');
      return [];
    }
  }

    static Future<List<Map<String, dynamic>>> getSortiesbyType(
      {required int limit,
      required int offset,
      required String type,
      }) async {
    try {
      final sqflite.Database db = await createDatabase();
      final List<Map<String, dynamic>> sortiesList = await db.query(
        "Sorties",
        where: 'type = ?',
        whereArgs: [type],
        offset: offset,
        limit: limit,
        orderBy: "created_at DESC"
      );
      return sortiesList;
    } catch (e) {
      print('Erreur lors de la récupération des observations: $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }



  static Future<List<ObservationModel>> getObservationsByIdPaginated(
      {required int limit,
      required int offset,
      required String shippingID}) async {
    try {
      final sqflite.Database db = await createDatabase();
      final List<Map<String, dynamic>> etapeObservationList = await db.query(
        "Observations",
        where: 'shipping_id = ?',
        whereArgs: [shippingID],
        offset: offset,
        limit: limit,orderBy: "created_at DESC"
      );

      return etapeObservationList
          .map((observationMap) => ObservationModel.fromJson(observationMap))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des observations: $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }


  static Future<List<GpsTrackModel>> getGpsTrackByShippingId({
    // required int limit,
    // required int offset,
    required String shippingId,
  }) async {
    try {
      final sqflite.Database db = await createDatabase();
      final List<Map<String, dynamic>> gpsPositionList = await db.query(
        "GpsTrack",
        where: 'shipping_id = ?',
        whereArgs: [shippingId],
        orderBy: "created_at DESC"
        // offset: offset,
        // limit: limit,
      );
      // log("gps list--------$gpsPositionList");

      return gpsPositionList
          .map((positionMap) => GpsTrackModel.fromJson(positionMap))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des pgstrack: $e');
      return []; // Ou une gestion d'erreur appropriée
    }
  }
}
