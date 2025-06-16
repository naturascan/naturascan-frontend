import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Views/observationForm/components/dechetInfo.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/comportement.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import '../../Utils/Widgets/backButton.dart';
import '../../Utils/constants.dart';
import '../../Utils/Widgets/customText.dart';
import '../../main.dart';
import 'components/autreInfo.dart';
import 'components/infoEspece.dart';

class ObservationScreen extends StatefulWidget {
  final SortieModel shiping;
  final ObservationModel? observation;
  const ObservationScreen(
      {super.key, required this.shiping, this.observation});

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> {
  final PageController _controller = PageController(initialPage: 0);
  int selectPage = 0;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    if (observationController.heureDController.text.isEmpty) {
      observationController.heureDController.text = DateTime.now().millisecondsSinceEpoch.toString();
    }
    super.initState();
    Geolocation().permissionHandler();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBarBack(),
        title: const CustomText(
          text: "Formulaire des observations",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            setState(() {
              selectPage = value;
            });
          },
          children: [
            categorySpeciesController.selectedCateory.value.id == 14
                ? InfoDechet(edit: widget.observation != null ? true : false)
                : InfoEspeceMarine(edit: widget.observation != null ? true : false),
           AutreInfo(shiping: widget.shiping, edit: widget.observation != null ? true : false)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectPage != 0)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        },
                        child: const CustomText(
                          fontWeight: FontWeight.w600,
                          text: "  Début de l'observation",
                          fontSize: 14,
                        )),
                    Positioned(
                      left: -25,
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.colorPrimary),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (selectPage != 1) {
                          _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        } else {
                          widget.observation != null
                              ? updateObservation()
                              : saveObservation();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              text: selectPage != 1
                                  ? "Fin de l'observation     "
                                  : "Valider  "),
                        ],
                      )),
                  Positioned(
                    right: -25,
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants.colorPrimary),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )),
                  )
                ],
              )
            ],
          )),
    );
  }

  saveObservation() {
    observationController.addObservation();
  }

  updateObservation() {
    observationController.updateObservation(widget.observation!.id!);
  }

  void getData(){
       observationController.cloudCover ??= cloudCovers[zoneController.selectedCloudCover.value.id ?? 1].obs;
       observationController.seaState ??= seaStates[zoneController.selectedSeaState.value.id ?? 1].obs;
        observationController.visibility ??= visibilites2[zoneController.selectedVisibility.value.id! -1].obs;
        observationController.windDirection ??= windDirections[zoneController.selectedDirection.value.id ?? 1].obs;
        observationController.windSpeed ??= windSpeedBeauforts[zoneController.selectedWindForce.value.id ?? 1].obs;
    if (widget.observation != null) {
      if(widget.observation!.type == 0){
        if(widget.observation!.animal!.heureDebut != null){
        observationController.heureDController.text = widget.observation!.animal!.heureDebut.toString();
        }
      if(widget.observation!.animal!.heureFin != null){
        observationController.heureAController.text = widget.observation!.animal!.heureFin.toString();
        }
        if(widget.observation!.animal!.locationD != null){
          if(widget.observation!.animal!.locationD!.latitude != null){
                    if(widget.observation!.animal!.locationD!.latitude!.degDec != null) {
                      observationController.startLatDegDecController.text = widget.observation?.animal?.locationD?.latitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!.animal!.locationD!.latitude!.degMinSec != null) {
                      observationController.startLatDegMinSecController.text = widget.observation?.animal?.locationD?.latitude?.degMinSec?.toString() ?? "";
                    }
          }
          if(widget.observation!.animal!.locationD!.longitude != null){
                    if(widget.observation!.animal!.locationD!.longitude!.degDec != null) {
                      observationController.startLongDegDecController.text = widget.observation?.animal?.locationD?.longitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!.animal!.locationD!.longitude!.degMinSec != null) {
                      observationController.startLongDegMinSecController.text = widget.observation?.animal?.locationD?.longitude?.degMinSec?.toString() ?? "";
                    }
          }        
        }
        if(widget.observation!.animal!.locationF != null){
          if(widget.observation!.animal!.locationF!.latitude != null){
                    if(widget.observation!.animal!.locationF!.latitude!.degDec != null) {
                      observationController.endLatDegDecController.text = widget.observation?.animal?.locationF?.latitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!.animal!.locationF!.latitude!.degMinSec != null) {
                      observationController.endLatDeglMinSecController.text = widget.observation?.animal?.locationF?.latitude?.degMinSec?.toString() ?? "";
                    }
          }
          if(widget.observation!.animal!.locationF!.longitude != null){
                    if(widget.observation!.animal!.locationF!.longitude!.degDec != null) {
                      observationController.endLongDegDecController.text = widget.observation?.animal?.locationF?.longitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!.animal!.locationF!.longitude!.degMinSec != null) {
                      observationController.endLongDegMinSecController.text = widget.observation?.animal?.locationF?.longitude?.degMinSec?.toString() ?? "";
                    }
          }        
        }
       if (widget.observation!.animal!.comportementSurface != null && widget.observation!.animal!.comportementSurface!.isNotEmpty) {
        List<String> lists = widget.observation!.animal!.comportementSurface!.split(", ");
        for (var element in lists) {
               int index = comportementList.indexWhere((e) => e.nom == element);
          if(index != -1){
           observationController.comportementList.add(comportementList[index]);
          }else{
            observationController.comportementList.add(comportementList.last);
                 observationController.comportement.text = element;
          }
        }
        }

       if (widget.observation!.animal!.structureGroupe != null && widget.observation!.animal!.structureGroupe!.isNotEmpty) {
        observationController.groupState.clear();
        List<String> lists = widget.observation!.animal!.structureGroupe!.split(", ");
        for (var element in lists) {
          int index = Constants.structureList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.groupState.add(Constants.structureList[index]);
          }else{
            observationController.groupState.add(Constants.structureList.last);
                 observationController.groupStateAController.text = element;
          }
        }
        }

        if (widget.observation!.animal!.vitesse != null && widget.observation!.animal!.vitesse!.isNotEmpty) {
        observationController.vitesseList.clear();
        List<String> lists = widget.observation!.animal!.vitesse!.split(", ");
        for (var element in lists) {
          int index = Constants.vitesseList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.vitesseList.add(Constants.vitesseList[index]);
          }else{
          
          }
        }
        }
           if (widget.observation!.animal!.reactionBateau != null && widget.observation!.animal!.reactionBateau!.isNotEmpty) {
        observationController.reactionList.clear();
        List<String> lists = widget.observation!.animal!.reactionBateau!.split(", ");
        for (var element in lists) {
          int index = Constants.reactionList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.reactionList.add(Constants.reactionList[index]);
          }else{
          
          }
        }
        }
        if (widget.observation!.animal!.elementDetection != null && widget.observation!.animal!.elementDetection!.isNotEmpty) {
        observationController.detectionList.clear();
        List<String> lists = widget.observation!.animal!.elementDetection!.split(", ");
        for (var element in lists) {
          int index = Constants.detectionList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.detectionList.add(Constants.detectionList[index]);
          }else{
          
          }
        }
        }
      observationController.nbreEstimeController.text =
          widget.observation!.animal?.nbreEstime?.toString() ?? "";
      observationController.minController.text =
          widget.observation?.animal?.nbreMini?.toString() ?? "";
      observationController.maxController.text =
          widget.observation?.animal?.nbreMaxi?.toString() ?? "";
      observationController.jeunesO.value =
          widget.observation?.animal?.nbreJeunes ?? false;
      observationController.nnO.value =
          widget.observation?.animal?.nbreNouveauNe ?? false;
      observationController.activity.value =
          widget.observation?.animal?.activitesHumainesAssociees ?? false;
      observationController.gisementController.text =
          widget.observation?.animal?.gisement ?? "";
      observationController.activitesHumainesAssociees.text =
          widget.observation?.animal?.activitesHumainesAssocieesPrecision ?? "";
      observationController.distanceDuBateauController.text =
          widget.observation?.animal?.distanceEstimee ?? "";
      observationController.nbreSousGroupController.text =
          widget.observation?.animal?.nbreSousGroupes?.toString() ?? "";
      observationController.nbreIndivSousGroupeController.text =
          widget.observation?.animal?.nbreIndivSousGroupe?.toString() ?? "";
      observationController.bateauVitesseController.text =
          widget.observation?.animal?.vitesseNavire?? "";
      observationController.dureeController.text =
          widget.observation?.animal?.duree?.toString() ?? "0";
            if(widget.observation?.categorieId != null && widget.observation!.animal!.espece != null){
      categorySpeciesController.selectedCateory.value = categorySpeciesController.categorySpeciesList.firstWhere((element) => element.id == widget.observation!.animal!.espece!.categoryId, orElse: ()=> categorySpeciesController.categorySpeciesList.first);
             categorySpeciesController.selectedSpecie.value =  categorySpeciesController.selectedCateory.value.especes!.firstWhere((element) => element.commonName == widget.observation?.animal?.espece?.commonName, orElse: ()=> categorySpeciesController.selectedCateory.value.especes!.first);
          }
        
          if(widget.observation?.animal?.weatherReport != null){
              observationController.seaState = widget.observation?.animal?.weatherReport?.seaState?.obs;
                observationController.cloudCover =
                    widget.observation?.animal?.weatherReport?.cloudCover?.obs;
                observationController.visibility =
                    widget.observation?.animal?.weatherReport?.visibility?.obs;
                observationController.windSpeed =
                    widget.observation?.animal?.weatherReport?.windSpeed?.obs;
                observationController.windDirection =
                    widget.observation?.animal?.weatherReport!.windDirection?.obs;
          }
      observationController.photograph.value = widget.observation?.photograph ?? UserModel();
      observationController.avecEffort.value = widget.observation?.animal?.effort ?? false;
      observationController.desPhotos.value = widget.observation?.animal?.photos ?? false;
      observationController.remarqueController.text =
          widget.observation?.animal?.commentaires ?? "";
      observationController.especeController.text =
          widget.observation?.animal?.especesAssociees ?? "";
      }
      if(widget.observation!.type == 1){
        if(widget.observation!. bird!.heureDebut != null){
        observationController.heureDController.text = widget.observation!.bird!.heureDebut.toString();
        }
      if(widget.observation!. bird!.heureFin != null){
        observationController.heureAController.text =  widget.observation!. bird!.heureFin.toString();
        }
        if(widget.observation!. bird!.locationD != null){
          if(widget.observation!. bird!.locationD!.latitude != null){
                    if(widget.observation!. bird!.locationD!.latitude!.degDec != null) {
                      observationController.startLatDegDecController.text = widget.observation?. bird?.locationD?.latitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!. bird!.locationD!.latitude!.degMinSec != null) {
                      observationController.startLatDegMinSecController.text = widget.observation?. bird?.locationD?.latitude?.degMinSec?.toString() ?? "";
                    }
          }
          if(widget.observation!. bird!.locationD!.longitude != null){
                    if(widget.observation!. bird!.locationD!.longitude!.degDec != null) {
                      observationController.startLongDegDecController.text = widget.observation?. bird?.locationD?.longitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!. bird!.locationD!.longitude!.degMinSec != null) {
                      observationController.startLongDegMinSecController.text = widget.observation?. bird?.locationD?.longitude?.degMinSec?.toString() ?? "";
                    }
          }        
        }
        if(widget.observation!. bird!.locationF != null){
          if(widget.observation!. bird!.locationF!.latitude != null){
                    if(widget.observation!. bird!.locationF!.latitude!.degDec != null) {
                      observationController.endLatDegDecController.text = widget.observation?. bird?.locationF?.latitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!. bird!.locationF!.latitude!.degMinSec != null) {
                      observationController.endLatDeglMinSecController.text = widget.observation?. bird?.locationF?.latitude?.degMinSec?.toString() ?? "";
                    }
          }
          if(widget.observation!. bird!.locationF!.longitude != null){
                    if(widget.observation!. bird!.locationF!.longitude!.degDec != null) {
                      observationController.endLongDegDecController.text = widget.observation?. bird?.locationF?.longitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!. bird!.locationF!.longitude!.degMinSec != null) {
                      observationController.endLongDegMinSecController.text = widget.observation?. bird?.locationF?.longitude?.degMinSec?.toString() ?? "";
                    }
          }        
        }
      if (widget.observation!.bird!.comportement != null && widget.observation!.bird!.comportement!.isNotEmpty) {
        List<String> lists = widget.observation!.bird!.comportement!.split(", ");
        for (var element in lists) {
               int index = comportementOiseauList.indexWhere((e) => e.nom == element);
          if(index != -1){
           observationController.comportementList.add(comportementOiseauList[index]);
          }else{
            observationController.comportementList.add(comportementOiseauList.last);
                 observationController.comportement.text = element;
          }
        }
        }

       if (widget.observation!.bird!.etatGroupe != null && widget.observation!.bird!.etatGroupe!.isNotEmpty) {
        observationController.groupState.clear();
        List<String> lists = widget.observation!.bird!.etatGroupe!.split(", ");
        for (var element in lists) {
          int index = Constants.etatList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.groupState.add(Constants.etatList[index]);
          }else{
            observationController.groupState.add(Constants.etatList.last);
                 observationController.groupStateAController.text = element;
          }
        }
        }

           if (widget.observation!.bird!.reactionBateau != null && widget.observation!.bird!.reactionBateau!.isNotEmpty) {
        observationController.reactionList.clear();
        List<String> lists = widget.observation!.bird!.reactionBateau!.split(", ");
        for (var element in lists) {
          int index = Constants.reactionList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.reactionList.add(Constants.reactionList[index]);
          }else{
          
          }
        }
        }
           if(widget.observation?.categorieId != null && widget.observation!.bird!.espece != null){
      categorySpeciesController.selectedCateory.value = categorySpeciesController.categorySpeciesList.firstWhere((element) => element.id == widget.observation!.bird!.espece!.categoryId, orElse: ()=> categorySpeciesController.categorySpeciesList.first);
      categorySpeciesController.selectedSpecie.value =  categorySpeciesController.selectedCateory.value.especes!.firstWhere((element) => element.commonName == widget.observation?.bird?.espece?.commonName, orElse: ()=> categorySpeciesController.selectedCateory.value.especes!.first);
          }
      observationController.dureeController.text =
          widget.observation?.bird?.duree?.toString() ?? "0";
      observationController.nbreEstimeController.text =
          widget.observation!. bird?.nbreEstime?.toString() ?? "";
      observationController.distanceDuBateauController.text =
          widget.observation?. bird?.distanceEstimee ?? "";
      observationController.bateauVitesseController.text =
          widget.observation?. bird?.vitesseNavire?? "";
          if(widget.observation?. bird?.weatherReport != null){
                observationController.seaState =
                    widget.observation?. bird?.weatherReport?.seaState?.obs;
                observationController.cloudCover =
                    widget.observation?. bird?.weatherReport!.cloudCover?.obs;
                observationController.visibility =
                    widget.observation?. bird?.weatherReport!.visibility?.obs;
                observationController.windSpeed =
                    widget.observation?. bird?.weatherReport!.windSpeed?.obs;
                observationController.windDirection =
                    widget.observation?. bird?.weatherReport!.windDirection?.obs;
          }
      observationController.avecEffort.value = widget.observation?. bird?.effort ?? false;
      observationController.desPhotos.value = widget.observation?. bird?.photos ?? false;
      observationController.remarqueController.text =
          widget.observation?. bird?.commentaires ?? "";
      observationController.especeController.text =
          widget.observation?. bird?.especesAssociees ?? "";
      observationController.jeunes.value = widget.observation?. bird?.presenceJeune ?? false;
      observationController.activity.value =
          widget.observation?.bird?.activitesHumainesAssociees ?? false;
      observationController.activitesHumainesAssociees.text =
          widget.observation?.bird?.activitesHumainesAssocieesPrecision ?? "";
      }
      if(widget.observation!.type == 2){
            if (widget.observation!.waste!.matiere != null && widget.observation!.waste!.matiere!.isNotEmpty) {
        observationController.typeList.clear();
        List<String> lists = widget.observation!.waste!.matiere!.split(", ");
        for (var element in lists) {
          int index = Constants.typeList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.typeList.add(Constants.typeList[index]);
          }else{
            observationController.typeList.add(Constants.typeList.first);
                 observationController.natureController.text = element;
          }
        }
        }
             if (widget.observation!.waste!.color != null && widget.observation!.waste!.color!.isNotEmpty) {
        observationController.colorList.clear();
        List<String> lists = widget.observation!.waste!.color!.split(", ");
        for (var element in lists) {
          int index = Constants.colorList.indexWhere((e) => e == element);
          if(index != -1){
           observationController.colorList.add(Constants.colorList[index]);
          }
        }
        }
        if(widget.observation!.waste!.heureDebut != null){
        observationController.heureDController.text =  widget.observation!.waste!.heureDebut.toString();
        }
        if(widget.observation!. waste!.location != null){
          if(widget.observation!. waste!.location!.latitude != null){
                    if(widget.observation!. waste!.location!.latitude!.degDec != null) {
                      observationController.startLatDegDecController.text = widget.observation?. waste?.location?.latitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!. waste!.location!.latitude!.degMinSec != null) {
                      observationController.startLatDegMinSecController.text = widget.observation?. waste?.location?.latitude?.degMinSec?.toString() ?? "";
                    }
          }
          if(widget.observation!. waste!.location!.longitude != null){
                    if(widget.observation!. waste!.location!.longitude!.degDec != null) {
                      observationController.startLongDegDecController.text = widget.observation?. waste?.location?.longitude?.degDec?.toString() ?? "";
                    }
                     if(widget.observation!. waste!.location!.longitude!.degMinSec != null) {
                      observationController.startLongDegMinSecController.text = widget.observation?. waste?.location?.longitude?.degMinSec?.toString() ?? "";
                    }
          }        
        }
      observationController.bateauVitesseController.text =
          widget.observation?. waste?.vitesseNavire?? "";
          if(widget.observation?. waste?.weatherReport != null){
                observationController.seaState =
                    widget.observation?. waste?.weatherReport?.seaState?.obs;
                observationController.cloudCover =
                    widget.observation?. waste?.weatherReport?.cloudCover?.obs;
                observationController.visibility = 
                    widget.observation?. waste?.weatherReport!.visibility?.obs;
                observationController.windSpeed =
                    widget.observation?. waste?.weatherReport!.windSpeed?.obs;
                observationController.windDirection =
                    widget.observation?. waste?.weatherReport!.windDirection?.obs;
          }

           if(widget.observation?.categorieId != null && widget.observation!.waste!.natureDeche != null){
      categorySpeciesController.selectedCateory.value = categorySpeciesController.categorySpeciesList.firstWhere((element) => element.id == widget.observation!.waste!.natureDeche!.categoryId, orElse: ()=> categorySpeciesController.categorySpeciesList.first);
             categorySpeciesController.selectedSpecie.value =  categorySpeciesController.selectedCateory.value.especes!.firstWhere((element) => element.commonName == widget.observation?.waste?.natureDeche?.commonName, orElse: ()=> categorySpeciesController.selectedCateory.value.especes!.first);
          }
      observationController.avecEffort.value = widget.observation?. waste?.effort ?? false;
      observationController.desPhotos.value = widget.observation?. waste?.photos ?? false;
      observationController.tailleEstmController.text = widget.observation?.waste?.estimatedSize ?? "";
      observationController.remarqueController.text =
          widget.observation?. waste?.commentaires ?? "";
      observationController.tailleEstmController.text =
          widget.observation?. waste?.estimatedSize ?? "";
      observationController.natureController.text =
          widget.observation?. waste?.matiere ?? "";
      // observationController.colorController.text = widget.observation?. waste?.color ?? "";
      observationController.dechePeche.value = widget.observation?. waste?.dechePeche ?? false;
      observationController.picked.value = widget.observation?. waste?.picked ?? false;
      }           
    }
  }
}
