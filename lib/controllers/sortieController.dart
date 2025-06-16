import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Views/DetailsExpedition.dart';
import 'package:naturascan/Views/Obstraces/ProspectionDetails.dart';
import 'package:naturascan/Views/Obstraces/observationTraceDetailsScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';
import '../Utils/position.dart';
import '../assistants/sql_helper.dart';
import '../models/local/sortieModel.dart';

class SortieController extends GetxController {
  Rx<CloudCover>? cloudCover;
  Rx<SeaState>? seaState;
  Rx<WindSpeedBeaufort>? windSpeed;
  TextEditingController heureFinController = TextEditingController();
  TextEditingController heureDebutController = TextEditingController();
  TextEditingController remark1Controller= TextEditingController();
  TextEditingController remark2Controller= TextEditingController();
  TextEditingController startLongDegMinSecController = TextEditingController();
  TextEditingController startLongDegDecController = TextEditingController();
  TextEditingController startLatDegMinSecController = TextEditingController();
  TextEditingController startLatDegDecController = TextEditingController();
  TextEditingController endLongDegMinSecController = TextEditingController();
  TextEditingController endLongDegDecController = TextEditingController();
  TextEditingController endLatDeglMinSecController = TextEditingController();
  TextEditingController endLatDegDecController = TextEditingController();
  TextEditingController modeController = TextEditingController(text: "0");
  RxList<UserModel> selectedRefs = <UserModel>[].obs;
  RxList<UserModel> selectedPat = <UserModel>[].obs;
  RxBool suivi = false.obs;
  final RxList<SortieModel> _sortieList = <SortieModel>[].obs;
  final RxList<SortieModel> _sortieTraceList = <SortieModel>[].obs;
  final RxList<SortieModel> _latestSortieList = <SortieModel>[].obs;
  StopWatchTimer stopWatchTimer = StopWatchTimer(
  mode: StopWatchMode.countUp
);


  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;
  RxBool isRunning = true.obs;

  List<SortieModel> get sortieList => _sortieList;

  List<SortieModel> get latestSortie => _latestSortieList;

  List<SortieModel> get sortieTraceList => _sortieTraceList;

  void reset(){
    cloudCover = null;
    seaState = null;
    windSpeed = null;
    heureFinController.clear();
    heureDebutController.clear();
    remark1Controller.clear();
    remark2Controller.clear();
    startLatDegDecController.clear();
    startLatDegMinSecController.clear();
    startLongDegDecController.clear();
    startLongDegMinSecController.clear();
    endLatDegDecController.clear();
    endLatDeglMinSecController.clear();
    endLongDegDecController.clear();
    endLongDegMinSecController.clear();
    modeController.text = "0";
    suivi.value = false;
    selectedPat.clear();
    selectedRefs.clear();
  }

  Future<void> fetchSorties(
      {int limit = 10, int offset = 5, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final sorties = await SQLHelper.getItems(
        table: 'Sorties',
        limit: limit,
        offset: offset,  
      );
        _sortieList.clear();
      for (var sortie in sorties) {
        print('me voici ${sorties.length} ');
        if (!_sortieList.any((s) => s.id == sortie['id'])) {
          _sortieList.add(SortieModel.fromJson(sortie));
        }
      }
      _sortieList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      print('Erreur lors de la récupération des sorties : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

    
  Future<void> fetchSortiesSuiviTraces(String type,
      {int limit = 100, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final sorties = await SQLHelper.getSortiesbyType(
        type: type,
        limit: limit,
        offset: offset,  
      );
        _sortieTraceList.clear();
      for (var sortie in sorties) {
        print('me voici ${sorties.length} ');
        if (!_sortieTraceList.any((s) => s.id == sortie['id'])) {
          _sortieTraceList.add(SortieModel.fromJson(sortie));
        }
      }
      _sortieTraceList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      print('Erreur lors de la récupération des sorties : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }


  Future<void> fetchSortiesByType(String type,
      {int limit = 100, int offset = 5, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final sorties = await SQLHelper.getSortiesbyType(
        type: type,
        limit: limit,
        offset: offset,  
      );
          _sortieList.clear();
      for (var sortie in sorties) {
        if (!_sortieList.any((s) => s.id == sortie['id'])) {
          _sortieList.add(SortieModel.fromJson(sortie));
        }
      }
      _sortieList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      print('Erreur lors de la récupération des sorties : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }


  Future<void> updateSortieImg(String id, Uint8List image) async {
    try {
      String img = await Utils().storeImage(image);
      log("l'image compress $img");
      final index = _sortieList.indexWhere((s) => s.id == id);
      if (index != -1) {
        await progress.hide();
        _sortieList[index].photo = img;
        Get.back();
      } else {
        await progress.hide();
      }
      await SQLHelper.updateItem(id, {"photo": img}, 'Sorties');
    } catch (e) {
      await progress.hide();
      print('Erreur lors de la mise à jour de la sortie : $e');
    } finally {
      await progress.hide();
      update();
    }
  }

  Future<void> updateSortieHeureDebutObserv(String id, heureDebut) async {
    try {
      final index = _sortieList.indexWhere((s) => s.id == id);
      if (index != -1) {
        _sortieList[index].naturascan?.heureDebutObservation = heureDebut;
        sortieController.stopWatchTimer.onStartTimer();
        Get.back();

      }
      await SQLHelper.updateItem(
          id,
          {
            "heure_debut_observation": int.tryParse(heureDebut) ?? DateTime.now().millisecondsSinceEpoch
          },
          'Sorties');
    } catch (e) {
      print('Erreur lors de la mise à jour de la sortie : $e');
    } finally {
      reset();
      await progress.hide();
      update();
    }
  }

 Future<void> updateSortieHeureFinObserv(String id,heureFin) async {
    try {
      final index = _sortieList.indexWhere((s) => s.id == id);
      if (index != -1) {
        _sortieList[index].naturascan?.heureFinObservaton = heureFin;
        Get.back();
      }
      await SQLHelper.updateItem(
          id,
          {
            "heure_fin_observaton": int.tryParse(heureFin) ?? DateTime.now().millisecondsSinceEpoch
          },
          'Sorties');
    } catch (e) {
      print('Erreur lors de la mise à jour de la sortie : $e');
    } finally {
      reset();
      await progress.hide();
      update();
    }
  }

  Future<void> fetchLatestSortiesByType(String type,
      {int limit = 5, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final sorties =
          await SQLHelper.getSortiesbyType(type: type, limit: limit, offset: offset);
      if (offset == 0) {
        _latestSortieList.clear();
      }
      for (var sortie in sorties) {
        if (!_latestSortieList.any((s) => s.id == sortie['id'])) {
          _latestSortieList.add(SortieModel.fromJson(sortie));
        }
      }
      print("iiiiiiiiiiiiiiiiiiiiiii ^${_latestSortieList.length}");
      // _latestSortieList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    } catch (e) {
      print('Erreur lors de la récupération des sorties : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }


  Future<void> fetchLatestSorties(
      {int limit = 5, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final sorties =
          await SQLHelper.getLatestItems(table: 'Sorties', limit: limit);
      if (offset == 0) {
        _latestSortieList.clear();
      }
      for (var sortie in sorties) {
        if (!_latestSortieList.any((s) => s.id == sortie['id'])) {
          _latestSortieList.add(SortieModel.fromJson(sortie));
        }
      }
      // _latestSortieList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    } catch (e) {
      print('Erreur lors de la récupération des sorties : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
  }

  Future getItem(String id) async {
    try {
      final result = await SQLHelper.getItem(id, 'Sorties');
      if (result.isNotEmpty) {
        // Supposons que SortieModel.fromJson() convertisse la ligne de la base de données en un modèle SortieModel
        final sortie = SortieModel.fromJson(result.first);
        // Traitement de l'élément récupéré
        print('Élément récupéré : $sortie');
        return sortie;
      } else {
        print('Aucun élément trouvé avec l\'ID : $id');
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'élément : $e');
    }
  }

  Future<void> addSortie(Map<String, dynamic> data, {String? idTrace}) async {
    try {
      data['id'] = const Uuid().v4(); // Génération d'un nouvel ID unique
      data['created_at'] = DateTime.now().toIso8601String();
      print("xvxvddg ${data['id']}");
      int idShiping = await SQLHelper.createItem(data, 'Sorties');
      if (idShiping == -1) {
        await progress.hide();
        Utils.showToast(
            'Erreur lors de la création de la sortie. Veuillez réssayer');
      } else {
        Geolocation()
            .determinePosition()
            .then((value) => gpsTrackController.addGpsTrack({
                  "longitude": "${value.longitude}",
                  "latitude": "${value.latitude}",
                  "device": "GPS_device_1",
                  "shipping_id": data['id'],
                  "inObservation": 1,
                }));
                if(data['type'] == 'NaturaScan'){
                          await progress.hide();
                Get.to(() => DetailsExpeditionScreen(idShiiping: data['id']))!
            .then((value) => Get.offAll(() => const ListExpeditionScreen(step: 0,)));
                }else if(data['type'] == 'Prospection'){
                          await progress.hide();
                Get.to(() => ProspectionDetailsScreen(idShiiping: data['id']))!
            .then((value) => Get.offAll(() => const ListExpeditionScreen(step: 1,)));
                }else{
                    await progress.hide();
                  SortieModel sortie = SortieModel.fromJson(data);
                   Get.to(()=> ObservationTraceDetails(traceId: idTrace!, sortie: sortie, ))!.then((value) => Get.offAll(() => const ListExpeditionScreen(step: 2,)));
                 
                }
      }
    } catch (e) {
      await progress.hide();
      Utils.showToast(
          'Erreur lors de la création de la sortie. Veuillez réssayer');
      print('Erreur lors de l\'ajout de la sortie : $e');
    } finally {
      reset();
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> addSyncSortie(Map<String, dynamic> data) async {
    try {
      int idShiping = await SQLHelper.createItem2(data, 'Sorties');
      if (idShiping == -1) {
        await progress.hide();
        Utils.showToast(
            'Erreur lors de la création de la sortie. Veuillez réssayer');
      } else {
        await progress.hide();
      }
      // fetchSorties();

    } catch (e) {
      await progress.hide();
      Utils.showToast(
          'Erreur lors de la création de la sortie. Veuillez réssayer');
      print('Erreur lors de l\'ajout de la sortie : $e');
    } finally {
      // Get.back(result: true); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateSortie(String id, SortieModel updatedSortie) async {
    try {
      final index = _sortieList.indexWhere((s) => s.id == id);
      if (index != -1) {
        await progress.hide();
        _sortieList[index] = updatedSortie;
        Get.back();
      } else {

        await progress.hide();
      }

      Map<String, dynamic> futureJson = await updatedSortie.toJson();
      
      await SQLHelper.updateItem(id, futureJson, 'Sorties');
    } catch (e) {
      await progress.hide();
      print('Erreur lors de la mise à jour de la sortie : $e');
    } finally {
      reset();
      await progress.hide();
      update();
    }
  }


  Future<void> updateHeureObservation(String id, SortieModel updatedSortie, int level) async {
    try {
      final index = _sortieList.indexWhere((s) => s.id == id);
      if (index != -1) {
        _sortieList[index] = updatedSortie;
      } else {
      }
      Map<String, dynamic> futureJson = await updatedSortie.toJson();
      await SQLHelper.updateItem(id, futureJson, 'Sorties');
    } catch (e) {
      await progress.hide();
      print('Erreur lors de la mise à jour de la sortie : $e');
    } finally {
      reset();
      await progress.hide();
      update();
    }
  }

  Future<void> deleteSortie(String id) async {
    try {   
      await SQLHelper.deleteItem(id, 'Sorties');
      _sortieList.removeWhere((s) => s.id == id);
      Get.back();
    } catch (e) {
      print('Erreur lors de la suppression de la sortie : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteAllSorties() async {
    try {
      await SQLHelper.deleteTable('Sorties');
      _sortieList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de tous les sorties: $e');
    } finally {
      update();
    }
  }
  
}
