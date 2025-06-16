import 'dart:convert';
import 'dart:io';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/controllers/obstraceController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/secteur.dart';
import 'package:naturascan/models/local/shippingModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:uuid/uuid.dart';

class PresenceNidScreen extends StatefulWidget {
  final ObservationTrace? trace;
  final SortieModel? sortie;
  final bool? edit;
  final int? level;
  const PresenceNidScreen(
      {super.key, required this.trace, required this.sortie, required this.edit, required this.level});

  @override
  State<PresenceNidScreen> createState() => _PresenceNidScreenState();
}

class _PresenceNidScreenState extends State<PresenceNidScreen> {
  final PageController _controller = PageController(initialPage: 0);
  ObstracesController obstracesController = Get.put(ObstracesController());
  TextEditingController dateDebut = TextEditingController(
      text: DateTime.now().millisecondsSinceEpoch.toString());
  TextEditingController dateFin = TextEditingController(
      text: DateTime.now().millisecondsSinceEpoch.toString());
  RxBool presence = true.obs;

  @override
  void initState() {
    getData();
    super.initState();
  }

  int selectPage = 0;
  @override
  void dispose() {
    dateDebut.clear();
    dateFin.clear();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const AppBarBack(),
          title: CustomText(
            text: widget.level == 0
                ? "Présence de nid"
                : widget.level == 1
                    ? "Emergence du nid"
                    : "Excavation du nid",
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 30,),
                      if (widget.level == 0)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Présence de nid",
                                    style: GoogleFonts.nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                        return CheckboxListTile.adaptive(
                                          value: presence.value,
                                          onChanged: (v) {
                                            presence.value = v!;
                                          },
                                          title: const Text("Oui"),
                                        );
                                      }),
                                    ),
                                    Expanded(
                                      child: Obx(() {
                                        return CheckboxListTile.adaptive(
                                          value: !presence.value,
                                          onChanged: (v) {
                                            presence.value = !v!;
                                          },
                                          title: const Text("Non"),
                                        );
                                      }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Date",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await showDatePickerDialog(
                                  context: context,
                                  minDate: DateTime(2015, 1, 1),
                                  maxDate: DateTime(2030, 12, 31),
                                  initialDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch) ,
                                  currentDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch)
                                ).then((value){
                                  if(value != null){
                                    setState(() {
                                      dateDebut.text = value.millisecondsSinceEpoch.toString();
                                    });
                                  }
                                });
                                                            
                              },
                              child: Container(
                                width: 300,
                                height: 50,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: Utils.formatDate1(
                                          int.tryParse(dateDebut.text) ??
                                              DateTime.now()
                                                  .millisecondsSinceEpoch),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.calendar_month,
                                          color: Constants.colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 300,
                            ),
                          ],
                        ),
                      if (widget.level == 1)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Emergence du nid",
                                    style: GoogleFonts.nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                        return CheckboxListTile.adaptive(
                                          value: presence.value,
                                          onChanged: (v) {
                                            presence.value = v!;
                                          },
                                          title: const Text("Oui"),
                                        );
                                      }),
                                    ),
                                    Expanded(
                                      child: Obx(() {
                                        return CheckboxListTile.adaptive(
                                          value: !presence.value,
                                          onChanged: (v) {
                                            presence.value = !v!;
                                          },
                                          title: const Text("Non"),
                                        );
                                      }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Date de début",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await showDatePickerDialog(
                                  context: context,
                                  minDate: DateTime(2015, 1, 1),
                                  maxDate: DateTime(2030, 12, 31),
                                  initialDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch) ,
                                  currentDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch)
                                ).then((value){
                                  if(value != null){
                                    setState(() {
                                      dateDebut.text = value.millisecondsSinceEpoch.toString();
                                    });
                                  }
                                });
                                                            
                              },
                              child: Container(
                                width: 300,
                                height: 50,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: Utils.formatDate1(
                                          int.tryParse(dateDebut.text) ??
                                              DateTime.now()
                                                  .millisecondsSinceEpoch),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.calendar_month,
                                          color: Constants.colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                               const SizedBox(
                              height: 15,
                            ),
                            Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Date de fin",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await showDatePickerDialog(
                                  context: context,
                                  minDate: DateTime(2015, 1, 1),
                                  maxDate: DateTime(2030, 12, 31),
                                  initialDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateFin.text) ?? DateTime.now().millisecondsSinceEpoch) ,
                                  currentDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateFin.text) ?? DateTime.now().millisecondsSinceEpoch)
                                ).then((value){
                                  if(value != null){
                                    setState(() {
                                      dateFin.text = value.millisecondsSinceEpoch.toString();
                                    });
                                  }
                                });
                                                            
                              },
                              child: Container(
                                width: 300,
                                height: 50,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: Utils.formatDate1(
                                          int.tryParse(dateFin.text) ??
                                              DateTime.now()
                                                  .millisecondsSinceEpoch),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.calendar_month,
                                          color: Constants.colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 22),
                      child: CustomText(
                        text: "Remarques",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomInputField(
                      controller: obstracesController.remark,
                      minLines: 5,
                      maxLines: 5,
                    ),
                  ],
                ),
            
                          ],
                        ),
                    if (widget.level == 2)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Excavation du nid",
                                    style: GoogleFonts.nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                        return CheckboxListTile.adaptive(
                                          value: presence.value,
                                          onChanged: (v) {
                                            presence.value = v!;
                                          },
                                          title: const Text("Oui"),
                                        );
                                      }),
                                    ),
                                    Expanded(
                                      child: Obx(() {
                                        return CheckboxListTile.adaptive(
                                          value: !presence.value,
                                          onChanged: (v) {
                                            presence.value = !v!;
                                          },
                                          title: const Text("Non"),
                                        );
                                      }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Date de début",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await showDatePickerDialog(
                                  context: context,
                                  minDate: DateTime(2015, 1, 1),
                                  maxDate: DateTime(2030, 12, 31),
                                  initialDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch) ,
                                  currentDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch)
                                ).then((value){
                                  if(value != null){
                                    setState(() {
                                      dateDebut.text = value.millisecondsSinceEpoch.toString();
                                    });
                                  }
                                });
                                                            
                              },
                              child: Container(
                                width: 300,
                                height: 50,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: Utils.formatDate1(
                                          int.tryParse(dateDebut.text) ??
                                              DateTime.now()
                                                  .millisecondsSinceEpoch),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.calendar_month,
                                          color: Constants.colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                               const SizedBox(
                              height: 15,
                            ),
                            Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Date de fin",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await showDatePickerDialog(
                                  context: context,
                                  minDate: DateTime(2015, 1, 1),
                                  maxDate: DateTime(2030, 12, 31),
                                  initialDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateFin.text) ?? DateTime.now().millisecondsSinceEpoch) ,
                                  currentDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateFin.text) ?? DateTime.now().millisecondsSinceEpoch)
                                ).then((value){
                                  if(value != null){
                                    setState(() {
                                      dateFin.text = value.millisecondsSinceEpoch.toString();
                                    });
                                  }
                                });
                                                            
                              },
                              child: Container(
                                width: 300,
                                height: 50,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: Utils.formatDate1(
                                          int.tryParse(dateFin.text) ??
                                              DateTime.now()
                                                  .millisecondsSinceEpoch),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.calendar_month,
                                          color: Constants.colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 22),
                      child: CustomText(
                        text: "Remarques",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomInputField(
                      controller: obstracesController.remark,
                      minLines: 5,
                      maxLines: 5,
                    ),
                  ],
                ),
            
                          ],
                        ),
                    
                     const SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              updateTrace();
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
                                    "Valider",
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
                      ),
                    ])),
          ),
        ));
  }

  void getData() {
    obstracesController.descriptionController.text = widget.trace?.remark ?? "";
    observationController.heureAController.text =
        widget.trace?.heure?.toString() ?? "";
    if (widget.trace?.weatherReport != null) {
      obstracesController.cloudCover?.value = cloudCovers.firstWhere(
          (element) =>
              element.id == widget.trace?.weatherReport?.cloudCover?.id,
          orElse: (() => zoneController.selectedCloudCover.value));
      obstracesController.seaState?.value = seaStates.firstWhere(
          (element) => element.id == widget.trace?.weatherReport?.seaState?.id,
          orElse: (() => zoneController.selectedSeaState.value));
      obstracesController.windSpeed?.value = windSpeedBeauforts.firstWhere(
          (element) => element.id == widget.trace?.weatherReport?.windSpeed?.id,
          orElse: (() => zoneController.selectedWindForce.value));
  if(widget.edit == true){
  if (widget.trace!.presenceNid != null && widget.level == 0) {
       presence.value = widget.trace?.presenceNid?.presenNid ?? false;
       dateDebut.text = widget.trace?.presenceNid?.date?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
      } 
        if (widget.trace!.emergence != null && widget.level == 1) {
       presence.value = widget.trace?.emergence?.emergence ?? false;
       dateDebut.text = widget.trace?.emergence?.dateDebut?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
       dateFin.text = widget.trace?.emergence?.dateFin?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
       obstracesController.remark.text = widget.trace?.emergence?.remark ??"";
      } 
          if (widget.trace!.esclavation != null && widget.level == 2) {
       presence.value = widget.trace?.esclavation?.esclavation ?? false;
       dateDebut.text = widget.trace?.esclavation?.dateDebut?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
       dateFin.text = widget.trace?.esclavation?.dateFin?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
       obstracesController.remark.text = widget.trace?.esclavation?.remark ??"";
      } 
  }

      if (widget.trace!.location != null &&
          widget.trace!.location!.latitude != null) {
        obstracesController.startLatDegDecController.text =
            widget.trace?.location?.latitude?.degDec?.toString() ?? "";
        obstracesController.startLatDegMinSecController.text =
            widget.trace?.location?.latitude?.degMinSec ?? "";
      }
      if (widget.trace!.location != null &&
          widget.trace!.location!.longitude != null) {
        obstracesController.startLongDegDecController.text =
            widget.trace?.location?.longitude?.degDec?.toString() ?? "";
        obstracesController.startLongDegMinSecController.text =
            widget.trace?.location?.longitude?.degMinSec ?? "";
      }
      if (widget.trace!.secteur != null) {
        zoneController.selectedSecteur.value = secteurLists.firstWhere(
            (element) => element.id == widget.trace!.secteur?.id,
            orElse: (() => secteurLists.first));
      }
      if (widget.trace!.sousSecteur != null) {
        zoneController.selectedSousSecteur.value =
            zoneController.selectedSecteur.value.sousSecteurs!.firstWhere(
                (element) => element.id == widget.trace!.sousSecteur?.id,
                orElse: (() =>
                    zoneController.selectedSecteur.value.sousSecteurs!.first));
      }
      if (widget.trace!.sousSecteur != null) {
        zoneController.selectedPlage.value = zoneController
            .selectedSousSecteur.value.plage!
            .firstWhere((element) => element.id == widget.trace!.plage?.id,
                orElse: (() =>
                    zoneController.selectedSousSecteur.value.plage!.first));
      }
    }
    setState(() {
      
    });
  }

  void updateTrace() async {
    progress = ProgressDialog(context);
    progress.show();
      obstracesController.seaState = zoneController.selectedSeaState;
    obstracesController.cloudCover = zoneController.selectedCloudCover;
    obstracesController.windSpeed = zoneController.selectedWindForce;
    await 1.delay();
    int dt = int.tryParse(obstracesController.heureAController.text) ??
        DateTime.now().millisecondsSinceEpoch;
    WeatherReportModel? dataWeather = WeatherReportModel(
      id: const Uuid().v4(),
      seaState: obstracesController.seaState?.value,
      cloudCover: obstracesController.cloudCover?.value,
      windForce: obstracesController.windSpeed?.value,
      windSpeed: obstracesController.windSpeed?.value,
    );
    if(widget.level == 0){
      obstracesController.presenceNid = PresenceNid().obs;
      obstracesController.presenceNid?.value = PresenceNid(
        presenNid: presence.value,
        date: int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch
      );
    }else{
    }
      if(widget.level == 1){
       obstracesController.emergence = Emergence().obs;
      obstracesController.emergence?.value = Emergence(
        emergence: presence.value,
        dateDebut: int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch,
        dateFin: int.tryParse(dateFin.text) ?? DateTime.now().millisecondsSinceEpoch,
        remark: obstracesController.remark.text.isEmpty ? null : obstracesController.remark.text
      );
    }
       if(widget.level == 2){
       obstracesController.esclavation = Esclavation().obs;
      obstracesController.esclavation?.value = Esclavation(
        esclavation: presence.value,
        dateDebut: int.tryParse(dateDebut.text) ?? DateTime.now().millisecondsSinceEpoch,
        dateFin: int.tryParse(dateFin.text) ?? DateTime.now().millisecondsSinceEpoch,
        remark: obstracesController.remark.text.isEmpty ? null : obstracesController.remark.text
      );
    }
    setState(() {});
    ObservationTrace data = ObservationTrace(
      id: widget.trace!.id!,
      secteur: zoneController.selectedSecteur.value,
      sousSecteur: zoneController.selectedSousSecteur.value,
      plage: zoneController.selectedPlage.value,
      heure: dt,
      weatherReport: dataWeather,
      presenceNid: widget.level == 0 ? obstracesController.presenceNid?.value : widget.trace?.presenceNid,
      emergence: widget.level == 1 ? obstracesController.emergence?.value : widget.trace?.emergence,
      esclavation: widget.level == 2 ? obstracesController.esclavation?.value : widget.trace?.esclavation,
      remark: obstracesController.descriptionController.text.isEmpty
          ? null
          : obstracesController.descriptionController.text,
      location: (obstracesController.startLatDegDecController.text.isEmpty &&
              obstracesController.startLatDegMinSecController.text.isEmpty &&
              obstracesController.startLongDegDecController.text.isEmpty &
                  obstracesController.startLongDegMinSecController.text.isEmpty)
          ? null
          : PositionS(
              latitude:
                  (obstracesController.startLatDegDecController.text.isEmpty &&
                          obstracesController
                              .startLatDegMinSecController.text.isEmpty)
                      ? null
                      : MapPosition(
                          degDec: obstracesController
                                  .startLatDegDecController.text.isEmpty
                              ? null
                              : double.tryParse(obstracesController
                                      .startLatDegDecController.text) ??
                                  0,
                          degMinSec: obstracesController
                                  .startLatDegMinSecController.text.isEmpty
                              ? null
                              : obstracesController
                                  .startLatDegMinSecController.text,
                        ),
              longitude:
                  (obstracesController.startLongDegDecController.text.isEmpty &&
                          obstracesController
                              .startLongDegMinSecController.text.isEmpty)
                      ? null
                      : MapPosition(
                          degDec: obstracesController
                                  .startLongDegDecController.text.isEmpty
                              ? null
                              : double.tryParse(obstracesController
                                      .startLongDegDecController.text) ??
                                  0,
                          degMinSec: obstracesController
                                  .startLongDegMinSecController.text.isEmpty
                              ? null
                              : obstracesController
                                  .startLongDegMinSecController.text,
                        ),
            ),
      photos: widget.trace!.photos == null ? null :  Utils().compressString(base64Encode(File(widget.trace?.photos ?? "").readAsBytesSync())),
      prospectionId: widget.trace!.prospectionId,
      shippingId: widget.trace!.shippingId,
      createdAt: widget.trace?.createdAt
    );
    obstracesController.updateObservationTrace(widget.trace!.id!, data).then((value){
       progress = ProgressDialog(context);
      progress.show();
          SyncController().sendSortie(widget.sortie!, 33, obstraceModel: widget.sortie!.obstrace);
    });
  }
}
