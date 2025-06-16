import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/crossingPoint.dart';
import 'package:naturascan/models/local/secteur.dart';
import 'package:naturascan/models/local/zone.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import '../assistants/sql_helper.dart';

class ZoneController extends GetxController {
  final RxList<ZoneModel> _zoneList =
      <ZoneModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;
 Rx<ZoneModel> selectedZone = listZone.first.obs;
 Rx<PointDePassage> selectedPoint = listZone.first.points!.first.obs;
 Rx<CloudCover> selectedCloudCover =  cloudCovers[1].obs;
 Rx<SeaState> selectedSeaState =  seaStates[1].obs;
 Rx<VisibiliteMer> selectedVisibility =  visibilites2[0].obs;
 Rx<WindDirection> selectedDirection =  windDirections[1].obs;
 Rx<WindSpeedBeaufort> selectedWindForce =  windSpeedBeauforts[1].obs;
 Rx<Secteur> selectedSecteur = secteurLists.first.obs;
 Rx<SousSecteur> selectedSousSecteur = secteurLists.first.sousSecteurs!.first.obs;
 Rx<Plage> selectedPlage = secteurLists.first.sousSecteurs!.first.plage!.first.obs;

  List<ZoneModel> get zoneList => _zoneList;

  Future fetchZoneList(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final listzones = await SQLHelper.getItems(
        table: 'ZoneModel',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _zoneList.clear();
      }
      for (var zone in listzones) {
        if (!_zoneList.any((c) => c.id == zone['id'])) {
          _zoneList.add(ZoneModel.fromJson(zone));
        }
      }
      _zoneList.sort((a, b) => a.name!.compareTo(b.name!));
      selectedZone.value = _zoneList.first;
      if(selectedZone.value.points != null && selectedZone.value.points!.isNotEmpty){
      selectedPoint.value = selectedZone.value.points!.first;
      }
    } catch (e) {
      print('Erreur lors de la récupération des zones: $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future<void> addZone(Map<String, dynamic> data) async {
    try {
      await SQLHelper.createItem2(data, 'ZoneModel');
      _zoneList.add(ZoneModel.fromJson(data));
    } catch (e) {
      print('Erreur lors de l\'ajout de la zone: $e');
    } finally {
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateZone(
      int id, ZoneModel updatedZone) async {
    try {
      final index = _zoneList.indexWhere((c) => c.id == id);
      if (index != -1) {
        _zoneList[index] = updatedZone;
      }
      await SQLHelper.updateItem(
          id.toString(), updatedZone.toJson(), 'ZoneModel');
    } catch (e) {
      print('Erreur lors de la mise à jour de la zone : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteZone(int id) async {
    try {
      await SQLHelper.deleteItem(id.toString(), 'ZoneModel');
      _zoneList.removeWhere((c) => c.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de la zone : $e');
    } finally {
      update();
    }
  }

    Future<void> deleteAllZone() async {
    try {
      await SQLHelper.deleteTable('ZoneModel');
      _zoneList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de la zone : $e');
    } finally {
      update();
    }
  }
  
}
