// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/Dialog/networkDialog.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/controllers/obstraceController.dart';
import 'package:naturascan/dummy-data/user.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/categorySpecies.dart';
import 'package:naturascan/models/local/etapeModel.dart';
import 'package:naturascan/models/local/gpsTrackModel.dart';
import 'package:naturascan/models/local/naturascanModel.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/zone.dart';
import 'package:uuid/uuid.dart';

class SyncController extends GetxController {
 static SyncController instance = Get.find();

 @override
  void onInit() { 
    sync();
    super.onInit();
  }

Future<void> sync() async{
   if(await PrefManager.getBool(Constants.connected)){
    //  sortieController.deleteAllSorties();
     checkTotalExport();
     syncCategory();
     syncUserLocal();
    //  syncZoneLocal(); 
   }
}

Future<void> syncCategory() async{
  try{
  List<CategorySpeciesModel>? categoriesApi = await ApiProvider("a").getCategory();
   if(categoriesApi != null && categoriesApi.isNotEmpty){
    categorySpeciesController.deleteAllCategorySpecies();
    for (var element in categoriesApi) {
      categorySpeciesController.addCategorySpecies(element.toJson());
    }
   } else{
       syncLocalCategories();
   }
       await categorySpeciesController.fetchCategorySpecies();
  }catch(e){
        syncLocalCategories();
  }
  }

  syncLocalCategories() async{
    await categorySpeciesController.fetchCategorySpecies();
    if(categorySpeciesController.categorySpeciesList.isEmpty){
    categorySpeciesController.deleteAllCategorySpecies();
    for (var element in categories) {
      categorySpeciesController.addCategorySpecies(element.toJson());
    }
    await categorySpeciesController.fetchCategorySpecies();
    }
  }
  
  Future<void> syncUser() async{
    try{
   List<UserModel>? users = await ApiProvider("a").getUsers();
   if(users != null && users.isNotEmpty){
    userController.deleteAllUser();
    for (var element in users) {
      userController.addUser(element.toJson(), 1);
    }
   }else{
    // syncUserLocal();
   }
       await userController.fetchUsers(1);
    }catch(e){
      //  syncUserLocal();
    }
}  

Future<void> syncUserLocal() async{
  await userController.fetchUsers(1);
  if(userController.userList.isEmpty){
    for (var element in userData) {
        userController.addUser(element.toJson(), 1);
    }
   await userController.fetchUsers(1);
  }
}

  Future<void> syncZone() async{
    try{
   List<ZoneModel>? zones = await ApiProvider('a').getZones();
   if(zones != null && zones.isNotEmpty){
    zoneController.deleteAllZone();
    for (var element in zones) {
      zoneController.addZone(element.toJson());
    }
   }else{
     syncZoneLocal();
   }
    await zoneController.fetchZoneList();
    }catch(e){
              print("Nous sommes zonesss");
        syncZoneLocal();
    }

}  

Future<void> syncZoneLocal() async{
  await zoneController.fetchZoneList();
  if(zoneController.zoneList.isEmpty){
    for (var element in listZone) {
        zoneController. addZone(element.toJson());
    }
       await zoneController.fetchZoneList();
  }
  }


  Future<void> sendSortie(SortieModel sortie, int step, {NaturascanModel? naturascan, ObstraceModel? obstraceModel}) async{
    try{
      
       Map<String, dynamic>? ntr;
       Map<String, dynamic>? obst;
       Map<String, dynamic>? ntrExp;
       Map<String, dynamic>? obstExp;
      if(naturascan != null){
       ntr = naturascan.toJson2();
       ntrExp = naturascan.toJson();
     List<EtapeModel>? etapes = await etapeController.fetchEtapesByShippingId(limit: 100, offset: 0, shippingId: sortie.id!);
     if(etapes != null && etapes.isNotEmpty){
      ntr["etapes"] = etapes.map((v) => v.toJson2()).toList();
      ntrExp["etapes"] = etapes.map((v) => v.toJson()).toList();
     }
    List<ObservationModel>? observations = await observationController.fetchObservationById(limit: 100, offset: 0, shippingID: sortie.id?? "");
     if(observations != null && observations.isNotEmpty){
      ntr["observations"] = observations.map((v) => v.toJson2()).toList();
      ntrExp["observations"] = observations.map((v) => v.toJson()).toList();
     }
     List<GpsTrackModel>? gps = await gpsTrackController.fetchGPSbyShippingId(shippingId: sortie.id?? "");
     if(gps != null && gps.isNotEmpty){
      ntr["gps"] = gps.map((v) => v.toJson()).toList();
      ntrExp["gps"] = gps.map((v) => v.toJson()).toList();
     }
      }

  if(obstraceModel != null){
    obst = obstraceModel.toJson2();
    obstExp = obstraceModel.toJson();
    Map<String, dynamic>? pros;
    Map<String, dynamic>? prosExp;
    if(obstraceModel.prospection != null){
      print('referentt ${obstraceModel.prospection!.referents!.length}');
      pros = obstraceModel.prospection?.toJson2();
      prosExp = obstraceModel.prospection?.toJson();
       List<ObservationTrace>? traces = await ObstracesController().fetchObservationsTracesByShippingId(shippingId: sortie.id?? "", limit: 1000, offset: 0);
     if(traces != null && traces.isNotEmpty){
      pros!["traces"] =  traces.map((v) => v.toJson3()).toList();
      List<Map<String, dynamic>> list = [];
      traces.forEach((element) async {
        Map<String, dynamic> trc = await element.toJson2();
        list.add(trc);
      });
      prosExp!["traces"] = list;
     }
    List<GpsTrackModel>? gps = await gpsTrackController.fetchGPSbyShippingId(shippingId: sortie.id?? "");
     if(gps != null && gps.isNotEmpty){
      pros!["gps"] = gps.map((v) => v.toJson()).toList();
      prosExp!["gps"] = gps.map((v) => v.toJson()).toList();
     }
    }
    obst["prospection"] = pros;
    obstExp["prospection"] = prosExp;
    if(obstraceModel.traces != null){
       ObservationTrace? trace = await ObstracesController().getObservationTrace(obstraceModel.traces!.id!);
     if(trace != null){ 
      obst["traces"] =  trace.toJson3();
      obstExp["traces"] = await trace.toJson2();
     }
    }
  }
      Map<String, dynamic> shipping = sortie.toJson2();
      Map<String, dynamic> shippingExp = await sortie.toJson();
      if(naturascan != null) shipping["naturascan"] = ntr;
      if(naturascan != null) shippingExp["naturascan"] = ntrExp;
      if(obstraceModel != null) shipping["obstrace"] = obst;
      if(obstraceModel != null) shippingExp["obstrace"] = obstExp; 

      Map<String, dynamic> data = {
        "uuid":  sortie.id,
        "data_export": jsonEncode(shippingExp),
        "data": jsonEncode(shipping)
      };
   String? response = await ApiProvider('La synchronisation a échouée.').sendSortie(data); 
   if(response == "success"){
        SortieModel sh = sortie; 
        sh.synchronised = true;
        if(step == 11 || step == 21){
        await sortieController.updateSortie(sortie.id!, sh).then((value) => Get.back());
        }else{
        }
        if(step == 32){
        await sortieController.updateSortie(sortie.id!, sh);
        }
        if(step == 31 || step == 33){
          Get.back();
          Get.back();
        await sortieController.updateSortie(sortie.id!, sh);
        }
        if(step == 12 || step == 22){
        await sortieController.updateSortie(sortie.id!, sh);
        }
      
      // Utils().sendExcel();
   }else{
      progress.hide();
       if(response == "network"){
                  Get.dialog(barrierDismissible: false,
                    const NetworkDialog(message: "La synchronisation a échouée",)).then((value){
                       if(step == 11 || step == 21){
                      Get.back();
                    } 
                    if(step == 31 || step == 33 || step == 32){
                     progress.hide();
                      Get.back();
                    }
                    
                    });
                   
       }
//  Get.offAll(()=> const ListExpeditionScreen(step: 2,));
   }
    }catch(e){
      progress.hide();
            // Get.back();
            //  Get.back();
             int step = 0;
           String type = await PrefManager.getString(Constants.selectedType);
           if(type == "SuiviTrace"){
            step = 2;
           }else if(type == "Prospection"){
            step = 1;
           }else{
            step = 0;
           }
      print("lerreur est $e");
           Get.dialog(barrierDismissible: false,
                    const ErrorDialog(message: "Une erreur est survenue lors de la synchronisation. Veuillez synchroniser en cliquant sur les 3 boutons du haut de la page de détail. ",)).then((value) =>   Get.offAll(()=>  ListExpeditionScreen(step: step,)));
      
  }
}  



  Future<void> checkTotalExport() async{
      UserModel? response ;
    try{
       response = await ApiProvider("a").userInfos(); 
        if (response != null) {
        print('resssss ${response.totalExport}');
    await PrefManager.putString(
            Constants.me, jsonEncode(response.toJson()));
        print('resssss ${response.toJson()}');
             await PrefManager.putInt(Constants.totalExport, response.totalExport ?? 0);
      if(response.totalExport != null && response.totalExport != 0){
        syncSortie();
      }
      }
    }catch(e){
      syncSortie();

      }
    }
  }


  Future<void> syncSortie() async{
    try{
     List<SortieModel>? sor = await ApiProvider("La synchronisation en arrière plan de vos anciennes sorties a échouée.").getSorties(); 
     if(sor != null && sor.isNotEmpty){
      List<SortieModel> sorties = [];
      if (sor.isNotEmpty) {
        for (var element in sor) {
          sorties.add(element);
        }
      } else {
        sorties = <SortieModel>[];
      }
       if(sorties.isNotEmpty){
      // sortieController.deleteAllSorties();    
      // etapeController.deleteAllEtapes();
      // observationController.deleteAllObservations();
      // gpsTrackController.deleteAllGpsTracks();
      // ObstracesController().deleteAllObservationsTraces();
      for (var element in sorties) {
              Map<String, dynamic> futureJson = await element.toJson();
        sortieController.addSyncSortie(futureJson);
        observationController.currentShippingID.value = element.id!;
      if(element.naturascan != null && element.naturascan!.etapes != null && element.naturascan!.etapes!.isNotEmpty){
        for (var etapes in element.naturascan!.etapes!) {
          etapeController.addSyncEtape(etapes);
        }
      }
      if(element.naturascan != null && element.naturascan!.observations != null && element.naturascan!.observations!.isNotEmpty){
        for (var observation in element.naturascan!.observations!) {
          observationController.addSyncObservation(observation);
        }
      }
      if(element.naturascan != null && element.naturascan!.gps != null && element.naturascan!.gps!.isNotEmpty){
        for (var gps in element.naturascan!.gps!) {
          gpsTrackController.addSynGpsTrack(gps.toJson());
        }
      }

       if(element.obstrace != null && element.obstrace!.prospection != null && element.obstrace!.prospection!.gps != null && element.obstrace!.prospection!.gps!.isNotEmpty){
        for (var gps in element.obstrace!.prospection!.gps!) {
          gpsTrackController.addSynGpsTrack(gps.toJson());
        }
      }
        if(element.obstrace != null && element.obstrace!.prospection != null && element.obstrace!.prospection!.traces != null && element.obstrace!.prospection!.traces!.isNotEmpty){
        for (var trace in element.obstrace!.prospection!.traces!) {
          if(trace != null){
             ObstracesController().addSyncTraces(trace);
          }
         
        }
      }
       if(element.obstrace != null && element.obstrace!.traces != null){
             ObstracesController().addSyncTraces(element.obstrace!.traces!);          
        }
         }
          }
           }
      String type = await PrefManager.getString(Constants.selectedType);
       if(type == "SuiviTrace"){
       sortieController.fetchSortiesSuiviTraces(type);
       }else{
       sortieController.fetchLatestSortiesByType(type);
       sortieController.fetchSortiesByType(type);
       }
    }catch(e){
      print('syn syn sync $e');
    }


}  
  