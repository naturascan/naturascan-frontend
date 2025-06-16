import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/comportement.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/seaAnimalObservationModel.dart';
import 'package:naturascan/models/local/seaBirdObservation.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/wasteObservationModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:uuid/uuid.dart';
import '../assistants/sql_helper.dart';
import '../models/local/observationModel.dart';

class ObservationController extends GetxController {
  TextEditingController tailleEstmController = TextEditingController();
  TextEditingController matierController = TextEditingController();
  TextEditingController tailleController = TextEditingController();
  // TextEditingController colorController = TextEditingController(text: Constants.colorList.first);
  TextEditingController heureDController = TextEditingController();
  TextEditingController heureAController = TextEditingController();
  TextEditingController startLongDegMinSecController = TextEditingController();
  TextEditingController startLongDegDecController = TextEditingController();
  TextEditingController startLatDegMinSecController = TextEditingController();
  TextEditingController startLatDegDecController = TextEditingController();
  TextEditingController endLongDegMinSecController = TextEditingController();
  TextEditingController endLongDegDecController = TextEditingController();
  TextEditingController endLatDeglMinSecController = TextEditingController();
  TextEditingController endLatDegDecController = TextEditingController();
  TextEditingController nbreAdulteController = TextEditingController();
  TextEditingController nbreSousGroupController = TextEditingController();
  TextEditingController nbreIndivSousGroupeController = TextEditingController();
  TextEditingController nbreEstimeController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController gisementController = TextEditingController();
  TextEditingController dureeController = TextEditingController();
  TextEditingController especeController = TextEditingController();
  TextEditingController bateauVitesseController = TextEditingController();
  TextEditingController distanceDuBateauController = TextEditingController(text:  Constants.distanceList.first);
  TextEditingController remarqueController = TextEditingController();
  TextEditingController autresInfoController = TextEditingController();
  TextEditingController especesAssocieesController = TextEditingController();
  TextEditingController donneeRecolteesController = TextEditingController();
  TextEditingController groupStateAController = TextEditingController();
  TextEditingController natureController = TextEditingController();
  TextEditingController comportement = TextEditingController();
  TextEditingController activitesHumainesAssociees = TextEditingController();
  Rx<CloudCover>? cloudCover;
  Rx<UserModel> photograph = UserModel().obs;
  Rx<VisibiliteMer>? visibility;
  Rx<SeaState>? seaState;
  Rx<WindSpeedBeaufort>? windSpeed;
  Rx<WindDirection>? windDirection;
  RxList<ComportementEnSurface> comportementList = <ComportementEnSurface>[].obs;
  RxList<String> groupState = <String>[].obs;
  RxList<String> vitesseList = <String>[].obs;
  RxList<String> reactionList = <String>[].obs;
  RxList<String> detectionList = <String>[].obs;
  RxList<String> typeList = <String>[].obs;
  RxList<String> colorList = <String>[].obs;
  //var selectedCateory = categories.first.obs;
  RxInt type = 0.obs;
  RxBool sousGroupe = false.obs;
  RxString distance = "".obs;
  RxBool jeunes = false.obs;
  RxBool jeunesO = false.obs;
  RxBool nnO = false.obs;
  RxBool avecEffort = false.obs;
  RxBool activitePeche = false.obs;
  RxBool dechePeche = false.obs;
  RxBool picked = false.obs;
  RxBool desPhotos = false.obs;
  RxBool activity = false.obs;
  geo.Position? startLocation;
  geo.Position? endLocation;

  final RxList<ObservationModel> _observationList = <ObservationModel>[].obs;
  var isLoading = false.obs;
  var isReloading = false.obs;
  var currentPage = 1;

  RxString currentShippingID = "".obs;

  List<ObservationModel> get observationList => _observationList;

  void reset() {
    tailleController.clear();
    tailleEstmController.clear();
    matierController.clear();
    // colorController.clear();
    heureDController.clear();
    heureAController.clear();
    startLatDegDecController.clear();
    startLatDegMinSecController.clear();
    startLongDegDecController.clear();
    startLongDegMinSecController.clear();
    endLatDegDecController.clear();
    endLatDeglMinSecController.clear();
    endLongDegDecController.clear();
    endLongDegMinSecController.clear();
    nbreAdulteController.clear();
    groupStateAController.clear();
    nbreSousGroupController.clear();
    nbreIndivSousGroupeController.clear();
    nbreEstimeController.clear();
    minController.clear();
    maxController.clear();
    gisementController.clear();
    especeController.clear();
    cloudCover = null;
    visibility = null;
    windDirection = null;
    seaState = null;
    windSpeed = null;
    activitesHumainesAssociees.clear();
    bateauVitesseController.clear();
    distanceDuBateauController.clear();
    remarqueController.clear();
    autresInfoController.clear();
    especesAssocieesController.clear();
    donneeRecolteesController.clear();
    natureController.clear();
    comportement.clear();
    comportementList.clear();
    groupState.clear();
    vitesseList.clear();
    reactionList.clear();
    detectionList.clear();
    type.value = 0;
    sousGroupe.value = false;
    avecEffort.value = false;
    activitePeche.value = false;
    dechePeche.value = false;
    picked.value = false;
    jeunes.value = false;
    jeunesO.value = false;
    nnO.value = false;
    desPhotos.value = false;
    activity.value = false;
    startLocation = null;
    endLocation = null;
  }

  Future fetchObservations(
      {int limit = 10, int offset = 0, bool isReload = false}) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      final observations = await SQLHelper.getItems(
        table: 'Observations',
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _observationList.clear();
      }
      for (var observation in observations) {
        _observationList.add(ObservationModel.fromJson(observation));
      }
      return _observationList;
    } catch (e) {
      print('Erreur lors de la récupération des observations : $e');
      throw "error";
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
    }
  }



  Future fetchObservationByTypeId({
    required int limit,
    required int offset,
    required int type,
    required String shippingID,
    bool isReload = false,
  }) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      print('récupération des iobservation');
      final observs = await SQLHelper.getObservationsByTypePaginated(
        limit: limit,
        offset: offset,
        type: type,
        shippingID: shippingID
      );
      if (offset == 0) {
        _observationList.clear();
      }
      log(observs.length.toString());
      _observationList.addAll(observs);
      return observs;
    } catch (e) {
      print('Erreur lors de la récupération des iobservation : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      // update();
    }
  }

  Future fetchObservationById({
    required int limit,
    required int offset,
    required String shippingID,
    bool isReload = false,
  }) async {
    isReload ? isReloading(true) : isLoading(true);
    try {
      print('récupération des iobservation');
      final observs = await SQLHelper.getObservationsByIdPaginated(
        limit: limit,
        offset: offset,
        shippingID: shippingID
      );
      if (offset == 0) {
        _observationList.clear();
      }
      log(observs.length.toString());
      _observationList.addAll(observs);
      return _observationList;
    } catch (e) {
      print('Erreur lors de la récupération des iobservation : $e');
    } finally {
      isReload ? isReloading(false) : isLoading(false);
      currentPage++;
      // update();
    }
  }

  Future getObservation(String id) async {
    try {
      final result = await SQLHelper.getItem(id, 'Observations');
      if (result.isNotEmpty) {
        final observation = ObservationModel.fromJson(result.first);
        print('Observation récupérée : $observation');
        return observation;
      } else {
        print('Aucune Observation trouvée avec l\'ID : $id');
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'Observation : $e');
    }
  }

  Future<void> addObservation() async {
    progress = ProgressDialog(Get.context!);
    progress.show();
    await 1.delay();
    try {
      ObservationModel data = constitution(const Uuid().v4());
       log("la data de lobservabb $data");
      int idObservation = await SQLHelper.createItem(data.toJson(), 'Observations');
      if (idObservation == -1) {
        await progress.hide();
        Utils.showToast(
            "Erreur lors de la création de l'observation. Veuillez réssayer");
      } else {
        //  Get.back();
        //Get.to(()=> ObservationListScreen(idShiiping: data['id']))!.then((value) => Get.back()));
      }
      // _observationList.add(ObservationModel.fromJson(data));
    } catch (e) {
      await progress.hide();
      print('Erreur lors de l\'ajout de l\'observation : $e');
    } finally {
      await progress.hide();
      reset();
      Get.back();
      update();
    }
  }

  Future<void> addSyncObservation(ObservationModel data) async {
    print('suu');
    try {
      int idObservation = await SQLHelper.createItem2(data.toJson(), 'Observations');
      if (idObservation == -1) {
        Utils.showToast(
            "Erreur lors de la création de l'observation. Veuillez réssayer");
      } else {
      }
          print('observationnnn susses');

    } catch (e) {
      print('Erreur lors de l\'ajout de l\'observation : $e');
    } finally {
      reset();
      update();
    }
  }

  Future<void> updateObservation(String id) async {
    progress = ProgressDialog(Get.context!);
    progress.show();
    await 1.delay();
    try {
     ObservationModel data = constitution(id);
             print("object constitution ${data.toJson()}");
      await SQLHelper.updateItem(id, data.toJson(), 'Observations');
      // final index = _observationList.indexWhere((o) => o.id == id);
      // if (index != -1) {
      //   _observationList[index] = updatedObservation;
      // }
      fetchObservationByTypeId(limit: 100, offset: 0, type: type.value, shippingID: currentShippingID.value);
    } catch (e) {
      await progress.hide();
      print('Erreur lors de la mise à jour de l\'observation : $e');
    } finally {
      reset();
      await progress.hide();
      Get.back();
      update();
    }
  }

  Future<void> deleteObservation(String id) async {
    try {
      await SQLHelper.deleteItem(id, 'Observations');
      _observationList.removeWhere((o) => o.id == id);
    } catch (e) {
      print('Erreur lors de la suppression de l\'observation : $e');
    } finally {
      update();
    }
  }


  Future<void> deleteAllObservations() async {
    try {
      await SQLHelper.deleteTable('Observations');
      _observationList.clear();
    } catch (e) {
      print('Erreur lors de la suppression de tous les sorties: $e');
    } finally {
      update();
    }
  }
  ObservationModel constitution(String id){
    seaState = zoneController.selectedSeaState;
    cloudCover = zoneController.selectedCloudCover;
    visibility = zoneController.selectedVisibility;
    windSpeed = zoneController.selectedWindForce;
    windDirection = zoneController.selectedDirection;
print("etat ede al mere ^${seaState?.value}");
    RxString selectedComportementList = ''.obs;
    if(comportementList.isNotEmpty) {
      for (var element in comportementList) {
        if(element.nom == "Autre"){
        selectedComportementList.value = "${selectedComportementList.value}${selectedComportementList.isEmpty ? '' : ", "}${comportement.text.isEmpty ? element.nom : comportement.text}";
        }else{
        selectedComportementList.value = selectedComportementList.value + (selectedComportementList.isEmpty ? '' : ", ") + element.nom;
        }
      }
    }
   RxString selectedStructureGroup = ''.obs;
    if(groupState.isNotEmpty) {
      for (var element in groupState) {
        if(element == "Autre"){
        selectedStructureGroup.value = selectedStructureGroup.value + (selectedStructureGroup.isEmpty ? '' : ", ") + (groupStateAController.text.isEmpty ? element : groupStateAController.text);
        }else{
        selectedStructureGroup.value = selectedStructureGroup.value + (selectedStructureGroup.isEmpty ? '' : ", ") + element;
        }
      }
    }
    RxString selectedVitesseGroup = ''.obs;
    if(vitesseList.isNotEmpty) {
      for (var element in vitesseList) {
        selectedVitesseGroup.value = selectedVitesseGroup.value + (selectedVitesseGroup.isEmpty ? '' : ", ") + element;
      }
    }
    RxString selectedReaction= ''.obs;
    if(reactionList.isNotEmpty) {
      for (var element in reactionList) {
        selectedReaction.value = selectedReaction.value + (selectedReaction.isEmpty ? '' : ", ") + element;
      }
    }
   RxString selectedDetection = ''.obs;
    if(detectionList.isNotEmpty) {
      for (var element in detectionList) {
        selectedDetection.value = selectedDetection.value + (selectedDetection.isEmpty ? '' : ", ") + element;
      }
    }
       RxString selectedColor = ''.obs;
    if(colorList.isNotEmpty) {
      for (var element in colorList) {
        selectedColor.value = selectedColor.value + (selectedColor.isEmpty ? '' : ", ") + element;
      }
    }
     RxString selectedNature = ''.obs;
    if(typeList.isNotEmpty) {
      for (var element in typeList) {
        if(element == "Autre"){
        selectedNature.value = selectedNature.value + (selectedNature.isEmpty ? '' : ", ") + (natureController.text.isEmpty ? element : natureController.text);
        }else{
        selectedNature.value = selectedNature.value + (selectedNature.isEmpty ? '' : ", ") + element;
        }
      }
    }
    return  ObservationModel(
        shippingId: currentShippingID.value,
        date: DateTime.now().millisecondsSinceEpoch,
        type: type.value,
        categorieId: categorySpeciesController.selectedCateory.value.id,
        photograph: photograph.value ,
        animal: type.value != 0 ? null :
        SeaAnimalObservation(
          espece: categorySpeciesController.selectedSpecie.value,
          taille: tailleController.text.isEmpty? null : tailleController.text,
          nbreEstime: nbreEstimeController.text.isEmpty? null : int.tryParse(nbreEstimeController.text),
          nbreMini: minController.text.isEmpty? null : int.tryParse(minController.text),
          nbreMaxi: maxController.text.isEmpty? null : int.tryParse(maxController.text),
          nbreJeunes: jeunesO.value,
          nbreNouveauNe: nnO.value,
          structureGroupe: selectedStructureGroup.isEmpty? null : selectedStructureGroup.value,
          sousGroup: sousGroupe.value,
          nbreSousGroupes: nbreSousGroupController.text.isEmpty? null : int.tryParse(nbreSousGroupController.text),
          nbreIndivSousGroupe: nbreIndivSousGroupeController.text.isEmpty? null : int.tryParse(nbreIndivSousGroupeController.text),
          comportementSurface: selectedComportementList.isEmpty? null : selectedComportementList.value,
          vitesse: selectedVitesseGroup.isEmpty? null : selectedVitesseGroup.value,
          reactionBateau: selectedReaction.isEmpty? null : selectedReaction.value,
          distanceEstimee: distanceDuBateauController.text.isEmpty? null : distanceDuBateauController.text,
          gisement: gisementController.text.isEmpty? null : gisementController.text,
          elementDetection: selectedDetection.isEmpty? null : selectedDetection.value,
          especesAssociees: especesAssocieesController.text.isEmpty? null : especesAssocieesController.text,
          heureDebut: heureDController.text.isEmpty? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch,
          heureFin: heureAController.text.isEmpty? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureAController.text) ?? DateTime.now().millisecondsSinceEpoch,
          duree: observationController.dureeController.text.isEmpty ? null : observationController.dureeController.text,
          locationD:(startLatDegDecController.text.isEmpty && startLatDegMinSecController.text.isEmpty && startLongDegDecController.text.isEmpty & startLongDegMinSecController.text.isEmpty)? null :
           PositionS(
            latitude: (startLatDegDecController.text.isEmpty && startLatDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: startLatDegDecController.text.isEmpty? null : double.tryParse(startLatDegDecController.text) ?? 0,
              degMinSec: startLatDegMinSecController.text.isEmpty? null : startLatDegMinSecController.text,
            ),
            longitude:  (startLongDegDecController.text.isEmpty && startLongDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: startLongDegDecController.text.isEmpty? null : double.tryParse(startLongDegDecController.text) ?? 0,
              degMinSec: startLongDegMinSecController.text.isEmpty? null : startLongDegMinSecController.text,
            ),
          ),
            locationF:(endLatDegDecController.text.isEmpty && endLatDeglMinSecController.text.isEmpty && endLongDegDecController.text.isEmpty & endLongDegMinSecController.text.isEmpty)? null :
             PositionS(
            latitude: (endLatDegDecController.text.isEmpty && endLatDeglMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: endLatDegDecController.text.isEmpty? null : double.tryParse(endLatDegDecController.text) ?? 0,
              degMinSec: endLatDeglMinSecController.text.isEmpty? null : endLatDeglMinSecController.text,
            ),
            longitude:  (endLongDegDecController.text.isEmpty && endLongDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: endLongDegDecController.text.isEmpty? null : double.tryParse(endLongDegDecController.text) ?? 0,
              degMinSec: endLongDegMinSecController.text.isEmpty? null : endLongDegMinSecController.text,
            ),
          ),
           vitesseNavire: bateauVitesseController.text.isEmpty? null : bateauVitesseController.text,
           weatherReport: WeatherReportModel(
            seaState: zoneController.selectedSeaState.value,
            cloudCover: zoneController.selectedCloudCover.value,
            visibility: zoneController.selectedVisibility.value,
            windSpeed: zoneController.selectedWindForce.value,
            windDirection: zoneController.selectedDirection.value,
            windForce: zoneController.selectedWindForce.value,
           ),
           activitesHumainesAssociees: activity.value,
           activitesHumainesAssocieesPrecision: activitesHumainesAssociees.text.isEmpty ? null : activitesHumainesAssociees.text,
           effort: avecEffort.value,
           commentaires: remarqueController.text.isEmpty? null : remarqueController.text,
           photos: desPhotos.value,
        ),
        bird: type.value != 1 ? null :
        SeaBirdObservation(
           espece: categorySpeciesController.selectedSpecie.value,
          nbreEstime: nbreEstimeController.text.isEmpty? null : int.tryParse(nbreEstimeController.text),
          etatGroupe: selectedStructureGroup.isEmpty? null : selectedStructureGroup.value,
          comportement: selectedComportementList.isEmpty? null : selectedComportementList.value,
          presenceJeune:jeunes.value,
          reactionBateau: selectedReaction.isEmpty? null : selectedReaction.value,
          distanceEstimee: distanceDuBateauController.text.isEmpty? null : distanceDuBateauController.text,
          especesAssociees: especesAssocieesController.text.isEmpty? null : especesAssocieesController.text,
          heureDebut: heureDController.text.isEmpty? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch,
          heureFin: heureAController.text.isEmpty? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureAController.text) ?? DateTime.now().millisecondsSinceEpoch,
          duree: observationController.dureeController.text.isEmpty ? null : observationController.dureeController.text,
          locationD:(startLatDegDecController.text.isEmpty && startLatDegMinSecController.text.isEmpty && startLongDegDecController.text.isEmpty & startLongDegMinSecController.text.isEmpty)? null :
           PositionS(
            latitude: (startLatDegDecController.text.isEmpty && startLatDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: startLatDegDecController.text.isEmpty? null : double.tryParse(startLatDegDecController.text) ?? 0,
              degMinSec: startLatDegMinSecController.text.isEmpty? null : startLatDegMinSecController.text,
            ),
            longitude:  (startLongDegDecController.text.isEmpty && startLongDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: startLongDegDecController.text.isEmpty? null : double.tryParse(startLongDegDecController.text) ?? 0,
              degMinSec: startLongDegMinSecController.text.isEmpty? null : startLongDegMinSecController.text,
            ),
          ),
            locationF:(endLatDegDecController.text.isEmpty && endLatDeglMinSecController.text.isEmpty && endLongDegDecController.text.isEmpty & endLongDegMinSecController.text.isEmpty)? null :
             PositionS(
            latitude: (endLatDegDecController.text.isEmpty && endLatDeglMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: endLatDegDecController.text.isEmpty? null : double.tryParse(endLatDegDecController.text) ?? 0,
              degMinSec: endLatDeglMinSecController.text.isEmpty? null : endLatDeglMinSecController.text,
            ),
            longitude:  (endLongDegDecController.text.isEmpty && endLongDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: endLongDegDecController.text.isEmpty? null : double.tryParse(endLongDegDecController.text) ?? 0,
              degMinSec: endLongDegMinSecController.text.isEmpty? null : endLongDegMinSecController.text,
            ),
          ),
           vitesseNavire: bateauVitesseController.text.isEmpty? null : bateauVitesseController.text,
            weatherReport: WeatherReportModel(
             seaState: zoneController.selectedSeaState.value,
            cloudCover: zoneController.selectedCloudCover.value,
            visibility: zoneController.selectedVisibility.value,
            windSpeed: zoneController.selectedWindForce.value,
            windDirection: zoneController.selectedDirection.value,
            windForce: zoneController.selectedWindForce.value,
           ),
           activitesHumainesAssociees: activity.value,
           activitesHumainesAssocieesPrecision: activitesHumainesAssociees.text.isEmpty ? null : activitesHumainesAssociees.text,
           effort: avecEffort.value,
           commentaires: remarqueController.text.isEmpty? null : remarqueController.text,
           photos: desPhotos.value,
        ),
        waste: type.value != 2 ? null : 
        SeaWasteObservation(
          matiere: selectedNature.value.isEmpty? null : selectedNature.value,
          estimatedSize: tailleEstmController.text.isEmpty? null : tailleEstmController.text,
          natureDeche: categorySpeciesController.selectedSpecie.value,
          color: selectedColor.value.isEmpty? null : selectedColor.value,
          // color: colorController.text.isEmpty? null : colorController.text,
          dechePeche: dechePeche.value,
          picked: picked.value,
          heureDebut: heureDController.text.isEmpty? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch,
          location:(startLatDegDecController.text.isEmpty && startLatDegMinSecController.text.isEmpty)? null :
           PositionS(
            latitude: (startLatDegDecController.text.isEmpty && startLatDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: startLatDegDecController.text.isEmpty? null : double.tryParse(startLatDegDecController.text) ?? 0,
              degMinSec: startLatDegMinSecController.text.isEmpty? null : startLatDegMinSecController.text,
            ),
            longitude:  (startLongDegDecController.text.isEmpty && startLongDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: startLongDegDecController.text.isEmpty? null : double.tryParse(startLongDegDecController.text) ?? 0,
              degMinSec: startLongDegMinSecController.text.isEmpty? null : startLongDegMinSecController.text,
            ),
          ),
          vitesseNavire: bateauVitesseController.text.isEmpty? null : bateauVitesseController.text,
            weatherReport: WeatherReportModel(
            seaState: zoneController.selectedSeaState.value,
            cloudCover: zoneController.selectedCloudCover.value,
            visibility: zoneController.selectedVisibility.value,
            windSpeed: zoneController.selectedWindForce.value,
            windDirection: zoneController.selectedDirection.value,
            windForce: zoneController.selectedWindForce.value,
           ),
           effort: avecEffort.value,
           commentaires: remarqueController.text.isEmpty? null : remarqueController.text,
           photos: desPhotos.value
        ),
        createdAt: DateTime.now().toIso8601String(),
        id: id
      );
      
  }
}

