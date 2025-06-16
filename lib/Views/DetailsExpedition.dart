import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/stopWatctTimerWidget.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/res.dart';
import 'package:naturascan/Views/editShiping.dart';
import 'package:naturascan/Views/listObservation.dart';
import 'package:naturascan/Views/listStep.dart';
import 'package:naturascan/Views/mapScreen.dart';
import 'package:naturascan/controllers/sortieController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/etapeModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../Utils/position.dart';
import '../models/local/gpsTrackModel.dart';

class DetailsExpeditionScreen extends StatefulWidget {
  final String idShiiping;
  final bool? isNew;
  final bool? isFinished;
  const DetailsExpeditionScreen(
      {super.key, this.isNew, this.isFinished, required this.idShiiping});

  @override
  State<DetailsExpeditionScreen> createState() =>
      _DetailsExpeditionScreenState();
}

class _DetailsExpeditionScreenState extends State<DetailsExpeditionScreen> {
  String? imageFile;
  Future<SortieModel>? future;
  List<EtapeModel> listStep = [];
  String distance = "0.0";
  String superficie = "0.0";
  TextEditingController heureDebutObservation = TextEditingController();
  TextEditingController heureFinObservation = TextEditingController();
  RxString travelHour = "".obs;
  RxString hour = "00".obs;
  RxString min = "00".obs;
  RxString sec = "00".obs;
  Duration duration = const Duration();
  Timer? timer;
  bool fist = true;
  NumberFormat format = NumberFormat('###.##');

  void calculateDisstance(double hauteur, double sup) async {
    double R = 6371;
    double h = (hauteur + 1.20) / 1000;
    double d = 2 * R * h + h * h;
    double dp = sqrt(d);
    NumberFormat format = NumberFormat('###.##');
    //distance = format.format(dp);
    distance = dp.round().toString();
    double di = dp.round().toDouble();
    double S = 2 * di * sup;
    superficie = S.toString();
  }

  @override
  void initState() {
   // getTime();
    etapeController.fetchEtapesByShippingId(
        limit: 10, offset: 0, shippingId: widget.idShiiping);
    super.initState();
  }

void getTime()async {
  sortieController.stopWatchTimer = StopWatchTimer(
    refreshTime: await PrefManager.getInt(Constants.timeO)
  );
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
                if(data.finished != true){
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
                calculateDisstance(
                    data.naturascan?.hauteurBateau?.toDouble() ?? 0.0,
                    data.naturascan?.superficieEchantillonnee?.toDouble() ??
                        0.0);
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
                                                  Res.ic_expedition,
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
                                                  Res.ic_expedition,
                                                ),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: FileImage(
                                                  File(data.photo!),
                                                ),
                                                fit: BoxFit.cover)),
                                  ),
                         
                           if(data.synchronised != true && (imageFile != null || data.photo != null)) Positioned(
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
                                    data.type ?? 'naturaScan',
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
                             if(data.finished == true  && data.synchronised != true)
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
                                      SyncController().sendSortie(data, 12, naturascan: data.naturascan).then((value) => setState(() {
                                        sortieController.getItem(widget.idShiiping);
                                      }));
                                      }
                                      if (val == 1) {
                                       Utils().sendExcel();
                                      }
                                    },
                                    itemBuilder: (BuildContext bc) {
                                      return [
                                       if(data.synchronised != true)
                                       const PopupMenuItem(
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
                                                "Synchroniser cette sortie",
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
                                          formatSeconds2(data.naturascan?.dureeSortie?.toInt() ??0),
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
                      const SizedBox(
                        height: 15,
                      ),
                      if(data.finished == true) Center(
                         child: Text(
                                      data.synchronised == true ? 'Cette sortie est déjà synchronisée.' : "Cette sortie n'est pas encore synchronisée. Veuillez synchroniser.",
                                      style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:  data.synchronised == true ?  Colors.green : Colors.red),
                                          textAlign: TextAlign.center,
                                    ),
                       ),
                                 const SizedBox(
                        height: 5,
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
                                        EditShipping(shipping: data, level: 1))!
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
                                  "Zone attribuée",
                                  style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Text(
                              data.naturascan!.zone == null
                                  ? "Non défini"
                                  : " Zone ${data.naturascan!.zone!.id}, ${data.naturascan!.zone!.name}, (${data.naturascan!.zone!.nbrePoint} points de passages)",
                              style: GoogleFonts.nunito(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      GridView(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                          gridChildInfos("Nombre de participants",
                              "  ${data.naturascan!.nbreObservateurs ?? "0"}"),
                          gridChildInfos("Type de bateau",
                              "  ${(data.naturascan!.typeBateau == null || data.naturascan!.typeBateau!.isEmpty) ? "Non défini" : data.naturascan!.typeBateau!}"),
                          gridChildInfos("Nom du bateau",
                              "  ${(data.naturascan!.nomBateau == null || data.naturascan!.nomBateau!.isEmpty) ? "Non défini" : data.naturascan!.nomBateau!}"),
                          gridChildInfos("Hauteur de pont",
                              "  ${(data.naturascan!.hauteurBateau == null) ? "0 m" : "${data.naturascan!.hauteurBateau!} m"}"),
                          gridChildInfos("Port de départ",
                              "  ${(data.naturascan!.portDepart == null || data.naturascan!.portDepart!.isEmpty) ? "Non défini" : data.naturascan!.portDepart!}"),
                          if (data.finished == true)
                            gridChildInfos("Port d'arrivée",
                                "  ${(data.naturascan!.portArrivee == null || data.naturascan!.portArrivee!.isEmpty) ? "Non défini" : data.naturascan!.portArrivee!}"),
                          gridChildInfos(
                              "Distance à portée du regard", "$distance km"),
                          if (data.finished == true)
                            gridChildInfos(
                                "Superficie échantillonée", "${format.format(data.naturascan!.superficieEchantillonnee ?? 0)} km²"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (data.naturascan!.heureDebutObservation == null &&
                          data.finished != true)
                        Center(
                          child: InkWell(
                            onTap: () {
                              hourDialog(data, 0);
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Constants.colorPrimary,
                                ),
                                child: Center(
                                  child: Text(
                                    "Débuter l'effort d'observation",
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
                      if (data.naturascan!.heureDebutObservation == null &&
                          data.finished == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Effort d'observation",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Constants.colorPrimary),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: CustomText(
                                  text:
                                      "Les paramètres de l'éffort d'observation n'ont pas été définis pendant la sortie", fontSize: 18,),
                            ),
                          ],
                        ),
                      if (data.naturascan!.heureDebutObservation != null &&
                          data.naturascan!.heureFinObservaton == null &&
                          data.finished != true)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Effort d'observation",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const StopWatchTimerWidger(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // width: 120,
                                  child: Obx(
                                    () => ElevatedButton(
                                        onPressed: () {
                                          sortieController.isRunning.value
                                              ? sortieController.stopWatchTimer
                                                  .onStopTimer()
                                              : sortieController.stopWatchTimer
                                                  .onStartTimer();
                                          sortieController.isRunning.value =
                                              sortieController
                                                  .stopWatchTimer.isRunning;
                                          print(
                                              "obbbbbb ${sortieController.stopWatchTimer.isRunning}");
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              sortieController.isRunning.value
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Constants.colorPrimary,
                                            ),
                                            Text(
                                              sortieController.isRunning.value
                                                  ? "Arrêter l'effort"
                                                  : "Reprendre l'effort",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  // width: 120,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        hourDialog(data, 1);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.stop,
                                            color: Constants.colorPrimary,
                                          ),
                                          Text(
                                            "Fin de l'effort",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      if (data.naturascan!.heureDebutObservation != null &&
                          data.naturascan!.heureFinObservaton != null)
                        Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Effort d'observation",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Constants.colorPrimary),
                                      ),
                                    ],
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            "Heure de début de l'effort d'observation:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: (data.naturascan!
                                                            .heureDebutObservation !=
                                                        null &&
                                                    data.naturascan!
                                                            .heureDebutObservation !=
                                                        0)
                                                ? Utils.formatTime(data
                                                        .naturascan!
                                                        .heureDebutObservation
                                                        ?.toInt() ??
                                                    0)
                                                : "Non défini",
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            "Heure de fin de l'effort d'observation:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: (data.naturascan!
                                                            .heureFinObservaton !=
                                                        null &&
                                                    data.naturascan!
                                                            .heureFinObservaton !=
                                                        0)
                                                ? Utils.formatTime(data
                                                        .naturascan!
                                                        .heureFinObservaton
                                                        ?.toInt() ??
                                                    0)
                                                : "Non défini",
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            "Durée de l'effort d'observation:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: formatSeconds2(data.naturascan
                                                    ?.dureeObservation
                                                    ?.toInt() ??
                                                0),
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                      (data.naturascan!.observateurs == null &&
                              data.naturascan!.responsable == null &&
                              data.naturascan!.skipper == null &&
                              data.naturascan!.photographe == null &&
                              data.naturascan!.otherUser == null)
                          ? Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Participants",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Constants.colorPrimary),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Aucun participant défini',
                                        style: GoogleFonts.nunito(
                                            color: Constants.textColor,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => EditShipping(
                                                  shipping: data, level: 2))!
                                              .then((value) {
                                            setState(() {
                                              sortieController
                                                  .getItem(widget.idShiiping);
                                              print(
                                                  "le nouvel objet now est ${data.naturascan!.observateurs}");
                                            });
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 45, right: 45, bottom: 20),
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Text(
                                              "Ajouter des participants",
                                              style: GoogleFonts.nunito(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Participants",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Constants.colorPrimary),
                                      ),
                                     if(data.synchronised != true) InkWell(
                                        onTap: () {
                                          Get.to(() => EditShipping(
                                                  shipping: data, level: 2))!
                                              .then((value) {
                                            setState(() {
                                              sortieController
                                                  .getItem(widget.idShiiping);
                                            });
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: "Observateurs:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: data.naturascan!
                                                        .observateurs ==
                                                    null
                                                ? "Aucun observateur ajouté"
                                                : data.naturascan!.observateurs!
                                                    .map((element) =>
                                                        "${element.name} ${element.firstname}")
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
                                        text: "Responsable:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: data.naturascan!
                                                        .responsable ==
                                                    null
                                                ? "Non défini"
                                                : data.naturascan!.responsable!
                                                    .map((element) =>
                                                        "${element.name} ${element.firstname}")
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
                                        text: "Skipper:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: data.naturascan!.skipper ==
                                                    null
                                                ? "Aucun skipper ajouté"
                                                : data.naturascan!.skipper!
                                                    .map((element) =>
                                                        "${element.name} ${element.firstname}")
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
                                        text: "Photographe:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: data.naturascan!
                                                        .photographe ==
                                                    null
                                                ? "Aucun photographe ajouté"
                                                : data.naturascan!.photographe!
                                                    .map((element) =>
                                                        "${element.name} ${element.firstname}")
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
                                    height: 15,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: "Autres participants:  ",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: data.naturascan!.otherUser ==
                                                    null
                                                ? "Aucun simple participant ajouté"
                                                : data.naturascan!.otherUser!
                                                    .map((element) =>
                                                        "${element.name} ${element.firstname}")
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
                                  "Paramètre de départ",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                                if(data.synchronised != true) InkWell(
                                  onTap: () {
                                    Get.to(() => EditShipping(
                                            shipping: data, level: 3))!
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
                                    "Heure de départ",
                                    (data.naturascan?.heureDepartPort != null &&
                                            data.naturascan?.heureDepartPort !=
                                                0)
                                        ? Utils.formatTime(data
                                                .naturascan?.heureDepartPort
                                                ?.toInt() ??
                                            0)
                                        : "Non défini"),
                                gridChild(
                                    "Etat de la mer- Douglas",
                                    data.naturascan!.departureWeatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                .naturascan!
                                                .departureWeatherReport!
                                                .seaState?.nom ??
                                            "Non défini"),
                                gridChild(
                                    "Couverture nuageuse",
                                    data.naturascan!.departureWeatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                    .naturascan!
                                                    .departureWeatherReport!
                                                    .cloudCover ==
                                                null
                                            ? "Non défini"
                                            : "${data.naturascan!.departureWeatherReport!.cloudCover!.nom}"),
                                gridChild(
                                    "Visiilité",
                                    data.naturascan!.departureWeatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                .naturascan!
                                                .departureWeatherReport!
                                                .visibility?.nom ??
                                            "Non défini"),
                                gridChild(
                                    "Force du vent",
                                    data.naturascan!.departureWeatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                .naturascan!
                                                .departureWeatherReport!
                                                .windSpeed?.description ??
                                            "Non défini"),
                                gridChild(
                                    "Direction du vent",
                                    data.naturascan!.departureWeatherReport ==
                                            null
                                        ? "Non défini"
                                        : data
                                                .naturascan!
                                                .departureWeatherReport!
                                                .windDirection?.nomComplet ??
                                            "Non défini")
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
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
                                        (data.naturascan!.remarqueDepart ==
                                                    null ||
                                                data.naturascan!
                                                        .remarqueDepart ==
                                                    '')
                                            ? "Aucune remarque"
                                            : data.naturascan!.remarqueDepart ??
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
                                  "Trace du Navire",
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
                          // if (zoneController.selectedZone.value.points !=
                          //         null &&
                          //     zoneController
                          //         .selectedZone.value.points!.isNotEmpty)
                            Expanded(
                              child: InkWell(
                                onTap: () => Get.to(() => ListStepScreen(
                                      shiping: data,
                                    )),
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
                                        "Etapes",
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
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() =>
                                    ObservationListScreen(shipping: data));
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
                                      "Observations",
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
                          ? Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Paramètre de retour",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Constants.colorPrimary),
                                      ),
                                      if(data.synchronised != true) InkWell(
                                        onTap: () {
                                          Get.to(() => EditShipping(
                                                  shipping: data, level: 4))!
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      gridChild(
                                          "Heure de retour",
                                          (data.naturascan?.heureArriveePort !=
                                                      null &&
                                                  data.naturascan
                                                          ?.heureArriveePort !=
                                                      0)
                                              ? Utils.formatTime(data.naturascan
                                                      ?.heureArriveePort
                                                      ?.toInt() ??
                                                  0)
                                              : "Non défini"),
                                      gridChild(
                                          "Etat de la mer- Douglas",
                                          data.naturascan!
                                                      .arrivalWeatherReport ==
                                                  null
                                              ? "Non défini"
                                              : data
                                                      .naturascan!
                                                      .arrivalWeatherReport!
                                                      .seaState?.nom ??
                                                  "Non défini"),
                                      gridChild(
                                          "Couverture nuageuse",
                                          data.naturascan!
                                                      .arrivalWeatherReport ==
                                                  null
                                              ? "Non défini"
                                              : data
                                                          .naturascan!
                                                          .arrivalWeatherReport!
                                                          .cloudCover ==
                                                      null
                                                  ? "Non défini"
                                                  : "${data.naturascan!.arrivalWeatherReport!.cloudCover?.nom}"),
                                      gridChild(
                                          "Visiilité",
                                          data.naturascan!
                                                      .arrivalWeatherReport ==
                                                  null
                                              ? "Non défini"
                                              : data
                                                      .naturascan!
                                                      .arrivalWeatherReport!
                                                      .visibility?.nom ??
                                                  "Non défini"),
                                      gridChild(
                                          "Force du vent",
                                          data.naturascan!
                                                      .arrivalWeatherReport ==
                                                  null
                                              ? "Non défini"
                                              : data
                                                      .naturascan!
                                                      .arrivalWeatherReport!
                                                      .windSpeed?.description ??
                                                  "Non défini"),
                                      gridChild(
                                          "Direction du vent",
                                          data.naturascan!
                                                      .arrivalWeatherReport ==
                                                  null
                                              ? "Non défini"
                                              : data
                                                      .naturascan!
                                                      .arrivalWeatherReport!
                                                      .windDirection?.nomComplet ??
                                                  "Non défini")
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 10, top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Remarques au Retour",
                                              style: GoogleFonts.nunito(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              data.naturascan!.remarqueArrivee ==
                                                          null ||
                                                      data.naturascan!
                                                              .remarqueArrivee ==
                                                          ''
                                                  ? "Aucune remarque"
                                                  : data.naturascan!
                                                          .remarqueArrivee ??
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
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                children: [
                                  Text(
                                    "Êtes vous à la fin de cette sortie? Cliquez sur le bouton <<Fin de la sortie>> pour définir"
                                    " les paramètres de retour et enregistrer votre sortie.",
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
                                        Get.to(() => EditShipping(
                                                shipping: data, level: 5))?.then((value){
                                                   setState(() {
                                    sortieController.getItem(widget.idShiiping);
                                  });
                                                });
                                      },
                                      child: const Text(
                                        "Fin de la sortie",
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
                              "Supprimer cette sortie",
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
                            "Etes vous sûre de vouloir supprimer cette sortie?",
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

  void hourDialog(SortieModel sortie, int level) {
    DateTime time = DateTime.now();
    if (level == 0) {
      heureDebutObservation.text = time.millisecondsSinceEpoch.toString();
    } else {
      heureFinObservation.text = time.millisecondsSinceEpoch.toString();
    }
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
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      level == 0
                          ? "Heure de debut de l'effort d'observation"
                          : "Heure de fin de l'effort d'observation",
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          if (value != null) {
                            if (level == 0) {
                              DateTime selectedH = DateTime(
                                  time.year,
                                  time.month,
                                  time.day,
                                  value.hour,
                                  value.minute);
                              heureDebutObservation.text =
                                  selectedH.millisecondsSinceEpoch.toString();
                            } else {
                              DateTime selectedH = DateTime(
                                  time.year,
                                  time.month,
                                  time.day,
                                  value.hour,
                                  value.minute);
                              heureFinObservation.text =
                                  selectedH.millisecondsSinceEpoch.toString();
                            }
                            setState(() {});
                          }
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              text: Utils.formatTime(int.tryParse(level == 0
                                      ? heureDebutObservation.text
                                      : heureFinObservation.text) ??
                                  time.millisecondsSinceEpoch),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.timer,
                                  color: Constants.colorPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                              onTap: () async {
                                Get.back();
                                updateHeureDebut(sortie, level);
                              },
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Constants.colorPrimary,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    )),
                                child: Center(
                                  child: Text(
                                    "Valider",
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
                overflow: TextOverflow.ellipsis,
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
      hD = data.naturascan?.heureArriveePort?.toInt() ?? 0;
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
     sortieController.stopWatchTimer.secondTime
          .listen((value) async => await PrefManager.putInt(Constants.timeO, value));
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

  void updateHeureDebut(SortieModel sortie, int level) async {
    progress = ProgressDialog(context);
    progress.show();
    await 2.delay();
    if (level == 0) {
      sortie.naturascan!.heureDebutObservation =
          int.tryParse(heureDebutObservation.text) ??
              DateTime.now().millisecondsSinceEpoch;
    } else {
      sortie.naturascan!.heureFinObservaton =
          int.tryParse(heureFinObservation.text) ??
              DateTime.now().millisecondsSinceEpoch;
      sortieController.stopWatchTimer.secondTime
          .listen((value) async => await PrefManager.putInt(Constants.timeO, value));
     sortieController.stopWatchTimer.onStopTimer();

    }
       await 2.delay();
    sortie.naturascan!.dureeObservation = await PrefManager.getInt(Constants.timeO);
    SortieController()
        .updateHeureObservation(sortie.id!, sortie, level)
        .then((value) {
      if (level == 0) {
        print('object tieemee');
        sortieController.stopWatchTimer.onStartTimer();
        sortieController.isRunning.value =
            sortieController.stopWatchTimer.isRunning;
      }
      setState(() {
        
      });
    });
  }
}
