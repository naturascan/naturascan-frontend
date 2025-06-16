import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Views/addShippingsForm/components/addForm1.dart';
import 'package:naturascan/Views/addShippingsForm/components/addForm2.dart';
import 'package:naturascan/Views/addShippingsForm/components/addForm3.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/controllers/sortieController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/naturascanModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:naturascan/models/local/zone.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:uuid/uuid.dart';

class EditShipping extends StatefulWidget {
  final SortieModel shipping;
  final int level;
  const EditShipping({super.key, required this.shipping, required this.level});

  @override
  State<EditShipping> createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {
  TextEditingController nbController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController typeBController = TextEditingController();
  TextEditingController nomBController = TextEditingController();
  TextEditingController heureDController = TextEditingController();
  TextEditingController portController = TextEditingController();
  Rx<CloudCover> cloudCover = CloudCover().obs;
  Rx<VisibiliteMer> visibility = VisibiliteMer().obs;
  Rx<SeaState> seaState = SeaState().obs;
  Rx<WindSpeedBeaufort> windSpeed = WindSpeedBeaufort().obs;
  Rx<WindDirection> windDirection = WindDirection().obs;
  TextEditingController remarkController2 = TextEditingController();
  TextEditingController heureDController2 = TextEditingController();
  TextEditingController portController2 = TextEditingController();
  TextEditingController heureDebutObservation =TextEditingController();
 TextEditingController heureFinObservation = TextEditingController();
  Rx<CloudCover> cloudCover2 = CloudCover().obs;
  Rx<VisibiliteMer> visibility2 = VisibiliteMer().obs;
  Rx<SeaState> seaState2 = SeaState().obs;
  Rx<WindSpeedBeaufort> windSpeed2 = WindSpeedBeaufort().obs;
  Rx<WindDirection> windDirection2 = WindDirection().obs;
  TextEditingController hauteurBateauController = TextEditingController();
  TextEditingController selectedZoneId =
      TextEditingController(text: "${listZone.first.id ?? 1}");
  final PageController _controller = PageController(initialPage: 0);
  List<UserModel> selectedUser = [];
  List<UserModel> responsable = [];
  List<UserModel> skipper = [];
  List<UserModel> photograph = [];
  List<UserModel> otherUser = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Constants.colorPrimary,
        centerTitle: true,
        leading: const AppBarBack(),
        title: CustomText(
          text: widget.level == 5 ? "Finaliser la sortie" : "Editer une sortie",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5),
          child: Column(
            children: [
              infosEdit(),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: InkWell(
                  onTap: () {
                    editSortie();
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.colorPrimary,
                      ),
                      child: Center(
                        child: Text(
                          widget.level == 5 ? "Finaliser" : "Valider",
                          style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infosEdit() {
    switch (widget.level) {
      case 1:
        return AddForm1(
          selectedZoneId: selectedZoneId,
          typeBateau: typeBController,
          nomBateau: nomBController,
          portController: portController,
          edit: true,
          selectedZone: widget.shipping.naturascan!.zone!,
          hauteurBateauController: hauteurBateauController,
        );
      case 2:
        return AddForm2(
            nbController: nbController,
            selectedUser: selectedUser,
            responsable: responsable,
            skipper: skipper,
            photograph: photograph,
            otherUser: otherUser,
            title: "Infos sur les particpants",
            edit: true);
      case 3:
        return AddForm3(
          heureDController: heureDController,
          remarkController: remarkController,
          cloudCoverr: cloudCover.value,
          seaState: seaState.value,
          visibility: visibility.value,
          windSpeedr: windSpeed.value,
          windDirection: windDirection.value,
          title: "Paramètre de départ",
          edit: true,
          level: widget.level,
        );
      case 4:
        return AddForm3(
          heureDController: heureDController2,
          remarkController: remarkController2,
          cloudCoverr: cloudCover.value,
          seaState: seaState.value,
          visibility: visibility.value,
          windSpeedr: windSpeed.value,
          windDirection: windDirection.value,
          title: "Paramètre de retour",
          edit: true,
          level: widget.level,
          portController: portController2,
        );
      case 5:
        return AddForm3(
          heureDController: heureDController2,
          remarkController: remarkController2,
          cloudCoverr: cloudCover2.value,
          seaState: seaState2.value,
          visibility: visibility2.value,
          windSpeedr: windSpeed2.value,
          windDirection: windDirection2.value,
          title: "Finalisation de la sortie",
          edit: false,
          level: widget.level,
          portController: portController2,
        );
      default:
        return Container();
    }
  }

  void getData() async {
    if (widget.shipping.naturascan!.nbreObservateurs != null) {
      nbController.text = widget.shipping.naturascan!.nbreObservateurs.toString();
    }
    if (widget.shipping.naturascan!.remarqueDepart != null) {
      remarkController.text = widget.shipping.naturascan!.remarqueDepart.toString();
    }
    if (widget.shipping.naturascan!.typeBateau != null) {
      typeBController.text = widget.shipping.naturascan!.typeBateau.toString();
    }
    if (widget.shipping.naturascan!.nomBateau != null) {
      nomBController.text = widget.shipping.naturascan!.nomBateau.toString();
    }
    if (widget.shipping.naturascan!.heureDepartPort != null) {
      heureDController.text = widget.shipping.naturascan!.heureDepartPort.toString();
    }
    if (widget.shipping.naturascan!.portDepart != null) {
      portController.text = widget.shipping.naturascan!.portDepart.toString();
    }
    if (widget.shipping.naturascan!.departureWeatherReport != null) {
      if (widget.shipping.naturascan!.departureWeatherReport!.cloudCover != null && widget.shipping.naturascan?.departureWeatherReport?.cloudCover?.id != null) {
        cloudCover.value = cloudCovers[widget.shipping.naturascan?.departureWeatherReport?.cloudCover?.id?? 1];
      }
      if (widget.shipping.naturascan!.departureWeatherReport!.seaState != null && widget.shipping.naturascan!.departureWeatherReport!.seaState?.id != null) {
        seaState.value = seaStates[widget.shipping.naturascan!.departureWeatherReport!.seaState?.id ?? 1];
      }
      if (widget.shipping.naturascan!.departureWeatherReport!.visibility != null && widget.shipping.naturascan!.departureWeatherReport!.visibility?.id != null) {
        visibility.value = visibilites2[(widget.shipping.naturascan!.departureWeatherReport!.visibility?.id?? 1) -1];
      }
      if (widget.shipping.naturascan!.departureWeatherReport!.windSpeed != null && widget.shipping.naturascan!.departureWeatherReport!.windSpeed?.id != null) {
        windSpeed.value = windSpeedBeauforts[widget.shipping.naturascan!.departureWeatherReport!.windSpeed?.id ?? 1];
      }
      if (widget.shipping.naturascan!.departureWeatherReport!.windDirection != null && widget.shipping.naturascan!.departureWeatherReport!.windDirection?.id != null) {
        windDirection.value = windDirections[widget.shipping.naturascan!.departureWeatherReport!.windDirection?.id ?? 1];
      }
    }
        print("herreeee 1");

    if (widget.shipping.naturascan!.heureArriveePort != null) {
      heureDController2.text = widget.shipping.naturascan!.heureArriveePort.toString();
    }
    if (widget.shipping.naturascan!.portArrivee != null) {
      portController2.text = widget.shipping.naturascan!.portArrivee.toString();
    }
    if (widget.shipping.naturascan!.remarqueArrivee != null) {
      remarkController2.text = widget.shipping.naturascan!.remarqueArrivee.toString();
    }
     if (widget.shipping.naturascan!.heureDebutObservation != null) {
      heureDebutObservation.text = widget.shipping.naturascan!.heureDebutObservation.toString();
    }
     if (widget.shipping.naturascan!.heureFinObservaton != null) {
      heureFinObservation.text = widget.shipping.naturascan!.heureFinObservaton.toString();
    }
    if (widget.shipping.naturascan!.arrivalWeatherReport != null) {
      if (widget.shipping.naturascan!.arrivalWeatherReport!.cloudCover != null && widget.shipping.naturascan!.arrivalWeatherReport!.cloudCover!.id != null) {
        cloudCover2.value = cloudCovers[widget.shipping.naturascan!.arrivalWeatherReport!.cloudCover?.id?? 1];
      }
      if (widget.shipping.naturascan!.arrivalWeatherReport!.seaState != null && widget.shipping.naturascan!.arrivalWeatherReport!.seaState?.id != null) {
         seaState2.value = seaStates[widget.shipping.naturascan!.arrivalWeatherReport!.seaState?.id ?? 1];
      }
      if (widget.shipping.naturascan!.arrivalWeatherReport!.visibility != null && widget.shipping.naturascan!.arrivalWeatherReport!.visibility?.id != null) {
        visibility2.value = visibilites2[(widget.shipping.naturascan!.arrivalWeatherReport!.visibility?.id ?? 1) -  1];
      }
      if (widget.shipping.naturascan!.arrivalWeatherReport!.windSpeed != null && widget.shipping.naturascan!.arrivalWeatherReport!.windSpeed?.id != null) {
        windSpeed2.value = windSpeedBeauforts[widget.shipping.naturascan!.arrivalWeatherReport!.windSpeed?.id ?? 1];
      }
      if (widget.shipping.naturascan!.arrivalWeatherReport!.windDirection != null && widget.shipping.naturascan!.arrivalWeatherReport!.windDirection?.id != null) {
        windDirection2.value = windDirections[widget.shipping.naturascan!.arrivalWeatherReport!.windDirection?.id ?? 1];
      }
    }
    print("herreeee 2");
    if (widget.shipping.naturascan!.zone != null && widget.shipping.naturascan!.zone!.id != null) {
      selectedZoneId =
          TextEditingController(text: "${widget.shipping.naturascan!.zone!.id}");
    }
    if (widget.shipping.naturascan!.hauteurBateau != null &&
        widget.shipping.naturascan!.hauteurBateau != null) {
      hauteurBateauController.text = widget.shipping.naturascan!.hauteurBateau!.toString();
    }
    if (widget.shipping.naturascan!.observateurs != null) {
      for (var element in widget.shipping.naturascan!.observateurs!) {
        selectedUser.add(element);
      }
    }
    if (widget.shipping.naturascan!.responsable != null) {
      for (var element in widget.shipping.naturascan!.responsable!) {
        responsable.add(element);
      }
    }
    if (widget.shipping.naturascan!.skipper != null) {
      for (var element in widget.shipping.naturascan!.skipper!) {
        skipper.add(element);
      }
    }
    if (widget.shipping.naturascan!.photographe != null) {
      for (var element in widget.shipping.naturascan!.photographe!) {
        photograph.add(element);
      }
    }
    if (widget.shipping.naturascan!.otherUser != null) {
      for (var element in widget.shipping.naturascan!.otherUser!) {
        otherUser.add(element);
      }
    }
    setState(() {});
  }

  void editSortie() async {
    progress = ProgressDialog(context);
    progress.show();
    if(widget.level == 3){
    seaState = zoneController.selectedSeaState;
    cloudCover = zoneController.selectedCloudCover;
    visibility = zoneController.selectedVisibility;
    windSpeed = zoneController.selectedWindForce;
    windDirection = zoneController.selectedDirection;
    }else if(widget.level == 4 || widget.level == 5){
    seaState2= zoneController.selectedSeaState;
    cloudCover2 = zoneController.selectedCloudCover;
    visibility2 = zoneController.selectedVisibility;
    windSpeed2 = zoneController.selectedWindForce;
    windDirection2 = zoneController.selectedDirection;
    }
    ZoneModel selectedZone = listZone
        .firstWhere((element) => element.id == int.parse(selectedZoneId.text));
    WeatherReportModel? dataWeather1 = WeatherReportModel(
        id: const Uuid().v4(),
        seaState:seaState.value,
        cloudCover:cloudCover.value,
        visibility: visibility.value,
        windForce: windSpeed.value,
        windDirection: windDirection.value,
        windSpeed: windSpeed.value
        );
    WeatherReportModel? dataWeather2 = WeatherReportModel(
        id: const Uuid().v4(),
        seaState: seaState2.value,
        cloudCover: cloudCover2.value,
        visibility: visibility2.value,
        windForce: windSpeed2.value,
        windDirection: windDirection2.value,
        windSpeed: windSpeed2.value
        );

    setState(() {});
    await gpsTrackController.fetchGPSbyShippingId(
        shippingId: widget.shipping.id!);
    double superficie = 0;
    double area = Utils().calculateDistance(gpsTrackController.gpsTrackList);
    int distance = 0;
    double R = 6371;
    double h = (widget.shipping.naturascan?.hauteurBateau?.toDouble() ?? 0.0 + 1.20) / 1000;
    double d = 2 * R * h + h * h;
    double dp = sqrt(d);
    distance = dp.round();
    superficie = 2 * distance * area;
    if(seaState.value == SeaState() && cloudCover.value == CloudCover() && visibility.value == VisibiliteMer() && windSpeed.value == WindSpeedBeaufort() && windDirection.value == WindDirection()){
      dataWeather1 =  null;
    }
     if(seaState2.value == SeaState() && cloudCover2.value == CloudCover() && visibility2.value == VisibiliteMer() && windSpeed2.value == WindSpeedBeaufort() && windDirection2.value == WindDirection()){
      dataWeather2 =  null;
    }

    int? duration;
    if(widget.level == 5){
        int presentTime = DateTime.now().millisecondsSinceEpoch;
    DateTime statTime =
        DateTime.fromMillisecondsSinceEpoch(widget.shipping.date?.toInt() ?? 0);
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(presentTime);
    duration = endTime.difference(statTime).inSeconds;
    }
   num? dureeObservation = widget.shipping.naturascan?.dureeObservation;
   num? heureFin = widget.shipping.naturascan?.heureFinObservaton;
 if(widget.level == 5){
  if(widget.shipping.naturascan?.heureDebutObservation != null && widget.shipping.naturascan?.heureFinObservaton == null){
         if(sortieController.stopWatchTimer.isRunning){
     sortieController.stopWatchTimer.onStopTimer();
          }
      sortieController.stopWatchTimer.secondTime
          .listen((value) =>  PrefManager.putInt(Constants.timeO, value));  
          dureeObservation = await PrefManager.getInt(Constants.timeO);
          heureFin = DateTime.now().millisecondsSinceEpoch;
  }
 }
    SortieModel data = SortieModel(
        id: widget.shipping.id,
        date: widget.shipping.date,
        type: widget.shipping.type,
        naturascan:
        NaturascanModel(
            zone: selectedZone,
            portDepart: portController.text.isEmpty? null :  portController.text,
            portArrivee: portController2.text.isEmpty ? null : portController2.text,
            heureDepartPort: widget.shipping.naturascan!.heureDepartPort,
            heureArriveePort: heureDController2.text.isEmpty ? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController2.text),
            responsable: responsable.isEmpty ? null : responsable,
            skipper: skipper.isEmpty ? null : skipper,
            photographe: photograph.isEmpty ? null : photograph,
            observateurs: selectedUser.isEmpty ? null : selectedUser,
            otherUser: otherUser.isEmpty ? null : otherUser,
            nbreObservateurs: int.tryParse(nbController.text) ?? 0,
            typeBateau:  typeBController.text.isEmpty ? null : typeBController.text,
            heureDebutObservation: widget.shipping.naturascan?.heureDebutObservation,
            heureFinObservaton: heureFin,
            nomBateau: nomBController.text.isEmpty ? null : nomBController.text,
            hauteurBateau: double.tryParse(hauteurBateauController.text),
            remarqueDepart: remarkController.text.isEmpty ? null : remarkController.text,
            remarqueArrivee: remarkController2.text.isEmpty ? null : remarkController2.text,
            departureExtraComment: remarkController.text.isEmpty ? null : remarkController.text,
            arrivalExtraComment: remarkController2.text.isEmpty ? null : remarkController2.text,
            departureWeatherReport: dataWeather1,
            arrivalWeatherReport: dataWeather2,
            dureeObservation: dureeObservation,
            superficieEchantillonnee:widget.level == 5 ? superficie : widget.shipping.naturascan?.superficieEchantillonnee,
            dureeSortie: duration
        ),
        finished: widget.level == 5 ? true : widget.shipping.finished,
        synchronised: widget.shipping.synchronised,
        createdAt: widget.shipping.createdAt,
        photo: widget.shipping.photo,
        );
    SortieController().updateSortie(widget.shipping.id!, data).then((value) {
      if(widget.level == 5){
       SyncController().sendSortie(data, 11, naturascan: data.naturascan);
      } else{
        Get.back();
      }
    });
//Get.to(()=> const DetailsExpeditionScreen(idShiiping: 1,));
  }

}
