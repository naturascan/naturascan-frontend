import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Views/Obstraces/observationTraceDetailsScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import '../assistants/sql_helper.dart';
import '../models/local/sortieModel.dart';

class ObstracesController extends GetxController {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController heureAController = TextEditingController();
  Rx<CloudCover>? cloudCover;
  Rx<VisibiliteMer>? visibility;
  Rx<SeaState>? seaState;
  Rx<WindSpeedBeaufort>? windSpeed;
  Rx<WindDirection>? windDirection;
  Rx<Uint8List>? photo;
  Rx<Emergence>? emergence;
  Rx<PresenceNid>? presenceNid;
  Rx<Esclavation>? esclavation;
  TextEditingController remark = TextEditingController();
  TextEditingController startLongDegMinSecController = TextEditingController();
  TextEditingController startLongDegDecController = TextEditingController();
  TextEditingController startLatDegMinSecController = TextEditingController();
  TextEditingController startLatDegDecController = TextEditingController();

  void reset() {
    descriptionController.clear();
    heureAController.clear();
    startLatDegDecController.clear();
    startLatDegMinSecController.clear();
    startLongDegDecController.clear();
    startLongDegMinSecController.clear();
    seaState = null;
    cloudCover = null;
    visibility = null;
    windDirection = null;
    windSpeed = null;
  }

  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;
  RxString currentShippingID = "".obs;

  final RxList<ObservationTrace> _observationTraceList = <ObservationTrace>[].obs;
  List<ObservationTrace> get observationTraceList => _observationTraceList;

  fetchObservationsTraces({int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final observationsTraces = await SQLHelper.getItems(
        table: 'ObservationsTraces',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _observationTraceList.clear();
      }
      for (var etape in observationsTraces) {
        if (!_observationTraceList.any((e) => e.id == etape['id'])) {
          _observationTraceList.add(ObservationTrace.fromJson(etape));
        }
      }
      return _observationTraceList;
    } catch (e) {
      print('Erreur lors de la récupération des étapes : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      // update();
    }
  }

  Future<List<ObservationTrace>?> fetchObservationsTracesByShippingId({
    required int limit,
    required int offset,
    required String shippingId,
    bool isReload = false,
  }) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final observationsTraces = await SQLHelper.getObservationsTracesBySippingPaginated(
        limit: limit,
        offset: offset,
        shippingID: shippingId,
      );
      if (offset == 0) {
        _observationTraceList.clear();
      }
      _observationTraceList.addAll(observationsTraces);
      return _observationTraceList;
    } catch (e) {
      print('Erreur lors de la récupération des obstraces : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      update();
    }
    return null;
  }

  Future getObservationTrace(String id) async {
    try {
      final result = await SQLHelper.getItem(id, 'ObservationsTraces');
      if (result.isNotEmpty) {
        final etape = ObservationTrace.fromJson(result.first);
        print('ObservationTrace récupérée : ${etape.toJson2()}');
        return etape;
      } else {
        print('Aucune ObservationTrace trouvée avec l\'ID : $id');
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'ObservationTrace : $e');
    }
  }

  Future<void> addObservationTrace(ObservationTrace trace, bool noProspection, SortieModel? sortie) async {
    try {
      Map<String, dynamic> data = await trace.toJson2();
      data["created_at"] = DateTime.now().toIso8601String();
      int idStep = await SQLHelper.createItem(data, 'ObservationsTraces');
      // _observationTraceList.add(ObservationTrace.fromJson(data));
      if (idStep == -1) {
        await progress.hide();
        Utils.showToast(
            'Erreur lors de la création de la ObservationTrace. Veuillez réssayer');
      } else {
        await progress.hide();
        if(noProspection){
        Map<String, dynamic> dtSortie = await sortie?.toJson() ?? {};
        fetchObservationsTracesByShippingId(
            limit: 10, offset: 0, shippingId: currentShippingID.value);
        dtSortie['obstrace'] = jsonEncode({
          "traces": jsonEncode(data)
        });
            sortieController.addSortie(dtSortie, idTrace: data["id"]);
        }else{
           Get.back();
           Get.to(() => ObservationTraceDetails(traceId: data["id"] ?? "" , sortie: sortie,));
        }
      }
      print('ObservationTrace ajoutée avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'ObservationTrace : $e');
    } finally {
      reset();
      Get.back(); // Retour à l'écran précédent
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> addSyncTraces(ObservationTrace obsTrace) async {
    try {
      Map<String, dynamic> data = await obsTrace.toJson2();
      int idStep = await SQLHelper.createItem2(data, 'ObservationsTraces');
      if (idStep == -1) {
      
      } else {
        await progress.hide();
        fetchObservationsTracesByShippingId(
            limit: 10, offset: 0, shippingId: currentShippingID.value);
      }
      print('Étape ajoutée avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'ObservationTrace : $e');
    } finally {
      reset();
      update(); // Mise à jour de l'interface utilisateur
    }
  }

  Future<void> updateObservationTrace(String id, ObservationTrace obsTrace) async {
    try {
      Map<String, dynamic> data = await obsTrace.toJson2();
      int d = await SQLHelper.updateItem(id, data, 'ObservationsTraces');
      if(d == -1){
           Utils.showToast(
            'Erreur lors de la modification de l\'observation trace. Veuillez réssayer');
      }else{
           await progress.hide();
      }
    } catch (e) {
      await progress.hide();
      print('Erreur lors de la mise à jour de l\'ObservationTrace : $e');
    } finally {
      reset();
      await progress.hide();
      //Get.back(); // Retour à l'écran précédent
      update();
    }
  }

  Future<void> deleteObservationTrace(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'ObservationsTraces');
      _observationTraceList.removeWhere((e) => e.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de l\'ObservationTrace : $e');
    } finally {
      update();
    }
  }

  Future<void> deleteAllObservationsTraces() async {
    try {
      await SQLHelper.deleteTable('ObservationsTraces');
      _observationTraceList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de tous les ObservationTrace: $e');
    } finally {
      update();
    }
  }
  
}
