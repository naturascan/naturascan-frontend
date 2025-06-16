import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/etapeModel.dart';

class EtapeController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController heureAController = TextEditingController();
  TextEditingController heureDController = TextEditingController();
  Rx<CloudCover> cloudCoverA = CloudCover().obs;
  Rx<VisibiliteMer> visibilityA = VisibiliteMer().obs;
  Rx<SeaState> seaStateA = SeaState().obs;
  Rx<WindSpeedBeaufort> windSpeedA = WindSpeedBeaufort().obs;
  Rx<WindDirection> windDirectionA = WindDirection().obs;
  Rx<CloudCover> cloudCoverD = CloudCover().obs;
  Rx<VisibiliteMer> visibilityD = VisibiliteMer().obs;
  Rx<SeaState> seaStateD = SeaState().obs;
  Rx<WindSpeedBeaufort> windSpeedD = WindSpeedBeaufort().obs;
  Rx<WindDirection> windDirectionD = WindDirection().obs;

  void reset() {
    titleController.clear();
    descriptionController.clear();
    heureAController.clear();
    heureDController.clear();
    seaStateA.value = SeaState();
    seaStateD.value = SeaState();
    cloudCoverA.value = CloudCover();
    cloudCoverD.value = CloudCover();
    visibilityA.value = VisibiliteMer();
    visibilityD.value = VisibiliteMer();
    windDirectionA.value = WindDirection();
    windDirectionD.value = WindDirection();
    windSpeedA.value = WindSpeedBeaufort();
    windSpeedD.value = WindSpeedBeaufort();
  }

  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;
  RxString currentShippingID = "".obs;

  final RxList<EtapeModel> _etapeList = <EtapeModel>[].obs;
  List<EtapeModel> get etapeList => _etapeList;

  fetchEtapes({int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final etapes = await SQLHelper.getItems(
        table: 'Etapes',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _etapeList.clear();
      }
      for (var etape in etapes) {
        if (!_etapeList.any((e) => e.id == etape['id'])) {
          _etapeList.add(EtapeModel.fromJson(etape));
        }
      }
      return _etapeList;
    } catch (e) {
      print('Erreur lors de la récupération des étapes : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      // update();
    }
  }

  Future<List<EtapeModel>?> fetchEtapesByShippingId({
    required int limit,
    required int offset,
    required String shippingId,
    bool isReload = false,
  }) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final etapes = await SQLHelper.getEtapesByShippingIdPaginated(
        limit: limit,
        offset: offset,
        shippingId: shippingId,
      );
      if (offset == 0) {
        _etapeList.clear();
      }
      log("voici etape length---------------------------------------------$etapes");
      _etapeList.addAll(etapes);
      return _etapeList;
    } catch (e) {
      print('Erreur lors de la récupération des étapes : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
    return null;
  }

  Future getEtape(String id) async {
    try {
      final result = await SQLHelper.getItem(id, 'Etapes');
      if (result.isNotEmpty) {
        final etape = EtapeModel.fromJson(result.first);
        print('Étape récupérée : ${etape.toJson()}');
        return etape;
      } else {
        print('Aucune étape trouvée avec l\'ID : $id');
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'étape : $e');
    }
  }

  Future<void> addEtape() async {
    print('etat err ${cloudCoverA.toJson()}');
    try {
      Map<String, dynamic> data = {
        'shipping_id': currentShippingID.value,
        'heure_depart_port': heureDController.text.isEmpty ? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch,
        'heure_arrivee_port': heureAController.text.isEmpty ? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureAController.text) ?? DateTime.now().millisecondsSinceEpoch,
        'point_de_passage': jsonEncode(zoneController.selectedPoint.value.toJson()),
        'description': descriptionController.text,
        'nom': titleController.text,
        'departure_weather_report': jsonEncode({
          "id": const Uuid().v4(),
          'sea_state': jsonEncode(seaStateD.value.toJson()),
          'cloud_cover': jsonEncode(cloudCoverD.value.toJson()),
          'visibility': jsonEncode(visibilityD.value.toJson()),
          'wind_force': jsonEncode(windSpeedD.value.toJson()),
          'wind_direction': jsonEncode(windDirectionD.value.toJson()),
          'wind_speed': jsonEncode(windSpeedD.value.toJson())
        }),
       'arrival_weather_report': jsonEncode({
          "id": const Uuid().v4(),
          'sea_state': jsonEncode(seaStateA.value.toJson()),
          'cloud_cover': jsonEncode(cloudCoverA.value.toJson()),
          'visibility': jsonEncode(visibilityA.value.toJson()),
          'wind_force': jsonEncode(windSpeedA.value.toJson()),
          'wind_direction': jsonEncode(windDirectionA.value.toJson()),
          'wind_speed': jsonEncode(windSpeedA.value.toJson())
        }),
      };
      data["created_at"] = DateTime.now().toIso8601String();
      data["id"] = const Uuid().v4();
      int idStep = await SQLHelper.createItem(data, 'Etapes');
      // _etapeList.add(EtapeModel.fromJson(data));
      if (idStep == -1) {
        await progress.hide();
        Utils.showToast(
            'Erreur lors de la création de la sortie. Veuillez réssayer');
      } else {
        await progress.hide();
        fetchEtapesByShippingId(
            limit: 10, offset: 0, shippingId: currentShippingID.value);
      }
      print('Étape ajoutée avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'étape : $e');
    } finally {
      reset();
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> addSyncEtape(EtapeModel etape) async {
    try {
      Map<String, dynamic> data = etape.toJson();
      data["created_at"] = DateTime.now().toIso8601String();
      int idStep = await SQLHelper.createItem2(data, 'Etapes');
      if (idStep == -1) {
       
      } else {
        fetchEtapesByShippingId(
            limit: 10, offset: 0, shippingId: currentShippingID.value);
      }
      print('Étape ajoutée avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'étape : $e');
    } finally {
      update(); 
    }
  }

  Future<void> updateEtape(String id) async {
    try {
      Map<String, dynamic> data = {
        'heure_depart_port': heureDController.text.isEmpty ? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch,
        'heure_arrivee_port': heureAController.text.isEmpty ? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureAController.text) ?? DateTime.now().millisecondsSinceEpoch,
        'point_de_passage': jsonEncode(
         zoneController.selectedPoint.value.toJson()
          ),
        'description': descriptionController.text,
        'nom': titleController.text,
        'departure_weather_report': jsonEncode({
          "id": const Uuid().v4(),
          'sea_state': jsonEncode(seaStateD.value.toJson()),
          'cloud_cover': jsonEncode(cloudCoverD.value.toJson()),
          'visibility': jsonEncode(visibilityD.value.toJson()),
          'wind_force': jsonEncode(windSpeedD.value.toJson()),
          'wind_direction': jsonEncode(windDirectionD.value.toJson()),
          'wind_speed': jsonEncode(windSpeedD.value.toJson())
        }),
       'arrival_weather_report': jsonEncode({
          "id": const Uuid().v4(),
          'sea_state': jsonEncode(seaStateA.value.toJson()),
          'cloud_cover': jsonEncode(cloudCoverA.value.toJson()),
          'visibility': jsonEncode(visibilityA.value.toJson()),
          'wind_force': jsonEncode(windSpeedA.value.toJson()),
          'wind_direction': jsonEncode(windDirectionA.value.toJson()),
          'wind_speed': jsonEncode(windSpeedA.value.toJson())
        }),
        };
      print('je viens ici etape');
      // final index = _etapeList.indexWhere((e) => e.id == id);
      // if (index != -1) {
      //   _etapeList[index] = updatedEtape;
      // }
      await SQLHelper.updateItem(id, data, 'Etapes');
    } catch (e) {
      await progress.hide();
      print('Erreur lors de la mise à jour de l\'étape : $e');
    } finally {
      reset();
      await progress.hide();
      Get.back(); // Retour à l'écran précédent
      update();
    }
  }

  Future<void> deleteEtape(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'Etapes');
      _etapeList.removeWhere((e) => e.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de l\'étape : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteAllEtapes() async {
    try {
      await SQLHelper.deleteTable('Etapes');
      _etapeList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de tous les sorties: $e');
    } finally {
      update();
    }
  }
  
}
