import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Utils/res.dart';
import 'package:naturascan/Views/Obstraces/editProspectionScreen.dart';
import 'package:naturascan/Views/Obstraces/listObstraceScreen.dart';
import 'package:naturascan/Views/mapScreen.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/gpsTrackModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';

class ProspectionDetailsScreen extends StatefulWidget {
  final String idShiiping;
  const ProspectionDetailsScreen(
      {super.key, required this.idShiiping});

  @override
  State<ProspectionDetailsScreen> createState() =>
      _ProspectionDetailsScreenState();
}

class _ProspectionDetailsScreenState extends State<ProspectionDetailsScreen> {
  String? imageFile;
  Future<SortieModel>? future;
  List<ObservationTrace> lisTraces = [];
  RxString travelHour = "".obs;
  RxString hour = "00".obs;
  RxString min = "00".obs;
  RxString sec = "00".obs;
  Duration duration = const Duration();
  Timer? timer;
  bool fist = true;
  NumberFormat format = NumberFormat('###.##');


  @override
  void initState() {
  
  }

  @override
  Widget build(BuildContext context) {
    observationController.currentShippingID.value = widget.idShiiping;
    sortieController.isRunning.value =
        sortieController.stopWatchTimer.isRunning;
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: sortieController.getItem(widget.idShiiping),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snap.hasData) {
                SortieModel data = snap.data;
                calculateDuration(data);
                print('daadatataa ${data.finished} ${data.synchronised}');
                if(data.finished != true && data.synchronised != true){
                 timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  calculateDuration(data);
                });
                Timer.periodic(const Duration(seconds: 30), (timer) {
                  Geolocation()
                      .determinePosition()
                      .then((value) => gpsTrackController.addGpsTrack({
                            "longitude": "${value.longitude}",
                            "latitude": "${value.latitude}",
                            "device": "GPS_device_1",
                            "shipping_id": widget.idShiiping,
                            "inObservation": 1,
                          }));
                });
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Stack(children: [
                             data.photo == null
                                ?
                                 data.synchronised == true ?
                                 Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                        image: DecorationImage(
                                                image: AssetImage(
                                                  Res.ic_prospection,
                                                ),
                                                fit: BoxFit.cover)
                                            ),
                                  )
                                 : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        openBottomSheetDialog(
                                            id: widget.idShiiping);
                                      },
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.black54,
                                        size: 70,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                        image: data.photo == null
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                  Res.ic_prospection,
                                                ),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: FileImage(
                                                  File(data.photo!),
                                                ),
                                                fit: BoxFit.cover)),
                                  ),
                         
                            if(data.synchronised != true && (imageFile != null || data.photo != null) ) Positioned(
                                bottom: 10,
                                right: 30,
                                child: InkWell(
                                  onTap: () {
                                    openBottomSheetDialog(
                                        id: widget.idShiiping);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.3)),
                                      child: const Center(
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      )),
                                )),
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    data.type ?? 'Prospection',
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.colorPrimary),
                                  ),
                                )),
                            Positioned(
                              top: 40,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.3)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                              if(data.finished == true && data.synchronised != true)
                            Positioned(
                              top: 40,
                              right: 20,
                              child:  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.3)),
                                child: PopupMenuButton(
                                    onSelected: (val) async {
                                      if (val == 0) {
                                        progress = ProgressDialog(context);
                                        progress.show();
                                      SyncController().sendSortie(data,22, obstraceModel: data.obstrace).then((value) => setState(() {
                                        sortieController.getItem(widget.idShiiping);
                                      }));
                                      }
                                      if (val == 1) {
                                       Utils().sendExcel();
                                      }
                                    },
                                    itemBuilder: (BuildContext bc) {
                                      return [
                                      if(data.synchronised != true) const PopupMenuItem(
                                          value: 0,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.sync,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Synchroniser cette prospection",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      // if(data.synchronised == true)  const PopupMenuItem(
                                      //     value: 1,
                                      //     child: Row(
                                      //       children: [
                                      //         Icon(
                                      //           Icons.download,
                                      //           color: Colors.black,
                                      //         ),
                                      //         SizedBox(
                                      //           width: 10,
                                      //         ),
                                      //         Text(
                                      //           "Générer un ficier Excel et envoyer",
                                      //           style: TextStyle(fontSize: 16),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                    ];
                                    },
                                    icon: const Icon(Icons.more_vert_outlined,
                                        color: Colors.white, size: 25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                              )
                            )
                         
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.access_time_sharp,
                                      color: Constants.colorPrimary,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    if(data.finished == true)
                                    Text(
                                          formatSeconds2(data.obstrace?.prospection?.dureeSortie?.toInt() ??0),
                                          style: GoogleFonts.nunito(),
                                        ),
                                   if(data.finished != true)
                                    Obx(() => Text(
                                          travelHour.value,
                                          style: GoogleFonts.nunito(),
                                        ))
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Constants.colorPrimary,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          Utils.formatDate1(
                                              int.parse("${data.date}")),
                                          style: GoogleFonts.nunito()),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                     const SizedBox(height: 10,),
                          if(data.finished == true) Center(
                         child: Text(
                                      data.synchronised == true ? 'Cette prospection est déjà synchronisée.' : "Cette prospection n'est pas encore synchronisée. Veuillez synchroniser.",
                                      style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:  data.synchronised == true ?  Colors.green : Colors.red),
                                          textAlign: TextAlign.center,
                                    ),
                       ),
                  
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Informations générales",
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Constants.colorPrimary),
                            ),
                            if(data.synchronised != true) InkWell(
                              onTap: () {
                                Get.to(() =>
                                        EditProspectionScreen(shiping: data, level: 1))!
                                    .then((value) {
                                  setState(() {
                                    sortieController.getItem(widget.idShiiping);
                                  });
                                });
                              },
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: RichText(
                                      text: TextSpan(
                                          text: "Mode de prospection:  ",
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: (data.obstrace!.prospection?.mode ==
                                                      null || data.obstrace!.prospection!.mode!.isEmpty
                                                      )
                                                  ? "Non défini"
                                                  : data.obstrace!.prospection!.mode,
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            )
                                          ]),
                                    ),
                          ),
                                     const SizedBox(
                                    height: 10,
                                  ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            //border:Border.all(color: Colors.grey.shade500, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.place,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    Text(
                                      "Zone de prospection",
                                      style: GoogleFonts.nunito(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                      
                                  ],
                                ),
                              ],
                            ),           
                          ],
                        ),
                      ),
                      GridView(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.8,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          gridChildInfos("Secteur",
                              "  ${data.obstrace?.prospection?.secteur?.name ?? ""}"),
                          gridChildInfos("Sous Secteur",
                              "  ${data.obstrace?.prospection?.sousSecteur?.name ?? ""}"),
                          gridChildInfos("Plage",
                              "  ${data.obstrace?.prospection?.plage?.name ?? ""}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                         Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            //border:Border.all(color: Colors.grey.shade500, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.place,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Text(
                                  "Position de départ/ Extrémité 1",
                                  style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                  
                              ],
                            ),    
                               Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade500,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Latitude",
                                                style: GoogleFonts.nunito(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                (data.obstrace?.prospection?.end1 == null ||
                                                data.obstrace?.prospection?.end1?.latitude == null ||
                                                        data.obstrace?.prospection?.end1?.latitude?.degMinSec ==
                                                            null)
                                                    ? "Inconnu"
                                                    : data.obstrace?.prospection?.end1?.latitude?.degMinSec?.toString() ?? "Inconnu",
                                                style: GoogleFonts.nunito(),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Longitude",
                                                style: GoogleFonts.nunito(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                              (data.obstrace?.prospection?.end1 == null ||
                                                data.obstrace?.prospection?.end1?.longitude == null ||
                                                        data.obstrace?.prospection?.end1?.longitude?.degMinSec ==
                                                            null)
                                                    ? "Inconnu"
                                                    : data.obstrace?.prospection?.end1?.longitude?.degMinSec?.toString() ?? "Inconnu",
                                                style: GoogleFonts.nunito(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                              
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                       
                          Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Participants",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Constants.colorPrimary),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                   
                                  RichText(
                                    text: TextSpan(
                                        text: "Référents:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: (data.obstrace!.prospection?.referents ==
                                                    null || data.obstrace!.prospection!.referents!.isEmpty
                                                    )
                                                ? "Aucun référent ajouté"
                                                : data.obstrace!.prospection!.referents!
                                                    .map((element) =>
                                                        "${element?.name ?? ""} ${element?.firstname ?? ""}")
                                                    .toList()
                                                    .join(', '),
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ]),
                                  ),
                                     const SizedBox(
                                    height: 10,
                                  ),
                                   RichText(
                                    text: TextSpan(
                                        text: "Patrouilleurs:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: (data.obstrace!.prospection!.patrouilleurs ==
                                                    null || data.obstrace!.prospection!.patrouilleurs!.isEmpty
                                                    )
                                                ? "Aucun patrouilleur ajouté"
                                                : data.obstrace!.prospection!.patrouilleurs!
                                                    .map((element) =>
                                                        "${element?.name ?? ""} ${element?.firstname ?? ""}")
                                                    .toList()
                                                    .join(', '),
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ]),
                                  ),
                            
                                ],
                              ),
                            ),

                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Paramètre de début",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                                 if(data.synchronised != true) InkWell(
                                  onTap: () {
                                    Get.to(() => EditProspectionScreen(
                                            shiping: data, level: 2))!
                                        .then((value) {
                                      setState(() {
                                        sortieController
                                            .getItem(widget.idShiiping);
                                      });
                                    });
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.grey.shade800,
                                    ), 
                                  ),
                                )
                              ],
                            ),
                            GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 5 / 3,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                gridChild(
                                    "Heure de début",
                                    (data.obstrace!.prospection?.heureDebut != null &&
                                            data.obstrace!.prospection?.heureDebut !=
                                                0)
                                        ? Utils.formatTime(data
                                                .obstrace!.prospection?.heureDebut
                                                ?.toInt() ??
                                            0)
                                        : "Non défini"),
                                gridChild(
                                    "Etat de la mer- Douglas",
                                    data.obstrace!.prospection!.weatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                .obstrace!.prospection!
                                                .weatherReport!
                                                .seaState?.nom ??
                                            "Non défini"),
                                gridChild(
                                    "Couverture nuageuse",
                                    data.obstrace!.prospection!.weatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                    .obstrace!.prospection!
                                                    .weatherReport!
                                                    .cloudCover ==
                                                null
                                            ? "Non défini"
                                            : "${data.obstrace!.prospection!.weatherReport!.cloudCover!.nom}"),
                                gridChild(
                                    "Force du vent",
                                    data.obstrace!.prospection!.weatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                .obstrace!.prospection!
                                                .weatherReport!
                                                .windSpeed?.description ??
                                            "Non défini"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                                height: 100,
                                padding: const EdgeInsets.only(
                                    left: 5, bottom: 10, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Remarques au départ",
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        (data.obstrace!.prospection!.remark1 ==
                                                    null ||
                                                data.obstrace!.prospection!
                                                        .remark1 ==
                                                    '')
                                            ? "Aucune remarque"
                                            : data.obstrace!.prospection!.remark1 ??
                                                '',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Votre trace GPS",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                              ],
                            ),
                            FutureBuilder(
                              future: gpsTrackController.fetchGPSbyShippingId(
                                  // limit: 10000,
                                  // offset: 0,
                                  shippingId: widget.idShiiping),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData &&
                                      snapshot.data.isNotEmpty) {
                                    return Stack(
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          child: MapScreen(
                                            trackList: snapshot.data
                                                as List<GpsTrackModel>,
                                                canGoArrow: false,
                                          ),
                                        ),
                                        Positioned(
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => MapScreen(
                                                      trackList: snapshot.data
                                                          as List<
                                                              GpsTrackModel>,
                                                              canGoArrow: true,
                                                    ));
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.launch_rounded,
                                                    color: Colors.black,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    "  Aggrandir",
                                                    style: GoogleFonts.nunito(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Aucune trace enregistrée',
                                          style: GoogleFonts.nunito(
                                              color: Constants.textColor,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              gpsTrackController
                                                  .fetchGPSbyShippingId(
                                                      // limit: 10000,
                                                      // offset: 0,
                                                      shippingId:
                                                          widget.idShiiping);
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                bottom: 20),
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                "Commencer l'enregistrement",
                                                style: GoogleFonts.nunito(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                               Get.to(()=> ListObstracesScreen(shiping: data));
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Constants.colorPrimary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Observations de traces",
                                      style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      data.finished == true
                          ?   Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            //border:Border.all(color: Colors.grey.shade500, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Paramètre de fin",
                                      style: GoogleFonts.nunito(
                                          color: Constants.colorPrimary,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                        if(data.synchronised != true)  InkWell(
                              onTap: () {
                                Get.to(() =>
                                        EditProspectionScreen(shiping: data, level: 4))!
                                    .then((value) {
                                  setState(() {
                                    sortieController.getItem(widget.idShiiping);
                                  });
                                });
                              },
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            )
                              ],
                            ),    
                               Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade500,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                           Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Heure de fin",
                                                style: GoogleFonts.nunito(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                (data.obstrace?.prospection?.heureFin ==
                                                            null)
                                                    ? "Non défini"
                                                    :  Utils.formatTime(data.obstrace?.prospection?.heureFin?.toInt() ?? 0),
                                                style: GoogleFonts.nunito(),
                                              ),
                                            ],
                                          ),
                                         
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Latitude",
                                                style: GoogleFonts.nunito(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                (data.obstrace?.prospection?.end1 == null ||
                                                data.obstrace?.prospection?.end1?.latitude == null ||
                                                        data.obstrace?.prospection?.end1?.latitude?.degMinSec ==
                                                            null)
                                                    ? "Inconnu"
                                                    : data.obstrace?.prospection?.end1?.latitude?.degMinSec?.toString() ?? "Inconnu",
                                                style: GoogleFonts.nunito(),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Longitude",
                                                style: GoogleFonts.nunito(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                              (data.obstrace?.prospection?.end1 == null ||
                                                data.obstrace?.prospection?.end1?.longitude == null ||
                                                        data.obstrace?.prospection?.end1?.longitude?.degMinSec ==
                                                            null)
                                                    ? "Inconnu"
                                                    : data.obstrace?.prospection?.end1?.longitude?.degMinSec?.toString() ?? "Inconnu",
                                                style: GoogleFonts.nunito(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                              
                          ],
                        ),
                      )
                    
                 : Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                children: [
                                  Text(
                                    "Êtes vous à la fin de cette prospection? Cliquez sur le bouton <<Fin de la prospection>> pour définir"
                                    " les paramètres de fin et enregistrer votre prospection.",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Get.to(() => EditProspectionScreen(
                                                shiping: data, level: 3))!.then((value) =>setState(() {
                                                   setState(() {
                                    sortieController.getItem(widget.idShiiping);
                                  });
                                                }));
                                      },
                                      child: const Text(
                                        "Fin de la prospection",
                                        style: TextStyle(fontSize: 16),
                                      ))
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                       if(data.synchronised != true) InkWell(
                        onTap: () async {
                           showDeleteDialog();
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              "Supprimer cette prospection",
                              style: GoogleFonts.nunito(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      const Text(
                        "Une erreur est survenue. Veuillez réssayer",
                        style: TextStyle(fontSize: 18),
                      ),
                      InkWell(
                          onTap: () {
                            getExpeditionDetails();
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Colors.grey.shade400,
                          ))
                    ],
                  ),
                );
              }
            }));
  }

  openBottomSheetDialog({required String id}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: Wrap(
            children: [
              ListTile(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 75,
                      requestFullMetadata: false);
                  Get.back();
                  if (image != null) {
                    sortieController.updateSortieImg(
                        id, File(image.path).readAsBytesSync());
                    setState(() {
                      imageFile = image.path;
                    });
                  }
                },
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Prendre une photo avec la caméra'),
              ),
              ListTile(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 75,
                      requestFullMetadata: false);
                  Get.back();
                  if (image != null) {
                    sortieController.updateSortieImg(
                        id, File(image.path).readAsBytesSync());
                    setState(() {
                      imageFile = image.path;
                    });
                  }
                },
                leading: const Icon(Icons.image),
                title: const Text('Prendre une photo dans la galerie'),
              ),
            ],
          ),
        );
      },
    );
  }

  _getFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
      imageQuality: 75,
      requestFullMetadata: false,
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        imageFile = image.path;
      });
    }
  }

  _getFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        requestFullMetadata: false);
    if (image != null) {
      setState(() {
        imageFile = image.path;
      });
    }
  }

  Future<SortieModel> getExpeditionDetails() async {
    Map<String, dynamic> params = {"id": widget.idShiiping};
    SortieModel sortie = SortieModel();
    return sortie;
    // String? response = await ApiProvider().getDetailsExpedition(params);
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                //height:300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Etes vous sûre de vouloir supprimer cette prospection?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                    )),
                                child: Center(
                                  child: Text(
                                    "Annuler",
                                    style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                sortieController
                                    .deleteSortie(widget.idShiiping);
                              },
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 146, 23, 14),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    )),
                                child: Center(
                                  child: Text(
                                    "Supprimer",
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
      },
    ).then((value) {
      if (value != null) {
        setState(() {});
      }
    });
  }

  Widget gridChild(String title, String value) {
    return Container(
        padding: const EdgeInsets.only(left: 5, bottom: 15, top: 15, right: 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ));
  }

  Widget gridChildInfos(String title, String value) {
    return Container(
        padding: const EdgeInsets.only(left: 5, bottom: 10, top: 10, right: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500, width: 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }

  Widget gridChildInfos2(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 16,
          ),
        ),
      ],
    );
  }


  void calculateDuration(SortieModel data) {
    int presentTime = DateTime.now().millisecondsSinceEpoch;
    int hD = 0;
    if (data.finished != true) {
      hD = presentTime;
    } else {
      hD = data.obstrace!.prospection?.heureFin?.toInt() ?? 0;
    }
    DateTime statTime =
        DateTime.fromMillisecondsSinceEpoch(data.date?.toInt() ?? 0);
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(hD);
    Duration tH = endTime.difference(statTime);
    travelHour.value = formatSeconds(tH.inSeconds);
  }

  String formatSeconds(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }

  String formatSeconds2(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    String h = "", m = "", s = "";

    if (formattedHours != "00") {
      h = "$formattedHours h";
    }
    if (formattedMinutes != "00") {
      m = "$formattedMinutes min";
    }
    s = "$formattedSeconds s";
    return '$h$m$s';
  }

}
