import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Utils/res.dart';
import 'package:naturascan/Views/Obstraces/addObservationTraceScreen.dart';
import 'package:naturascan/Views/Obstraces/presenceNidScreen.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/controllers/obstraceController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';

class ObservationTraceDetails extends StatefulWidget {
  final SortieModel? sortie;
  final String traceId;
  const ObservationTraceDetails({super.key,required this.sortie, required this.traceId});

  @override
  State<ObservationTraceDetails> createState() =>
      _ObservationTraceDetailsState();
}

class _ObservationTraceDetailsState extends State<ObservationTraceDetails> {
  ObstracesController obtracesController = Get.put(ObstracesController());
  @override
  void initState() {
      print('je viens ii');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: obtracesController.getObservationTrace(widget.traceId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ObservationTrace trace = snapshot.data;
                  print('pototootot ${trace.photos}');
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 350,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: trace.photos == null
                                      ? const DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(Res.ic_trace))
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(File(trace.photos!))),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(60))),
                            ),
                            // if(widget.sortie!.obstrace != null && widget.sortie!.obstrace!.traces != null) 
                             Positioned(
                              top: 20,
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
                                        SortieModel? sortie = await sortieController.getItem(widget.sortie!.id!);
                                        if(sortie != null){
                                     await SyncController().sendSortie(widget.sortie!, 32, obstraceModel: sortie.obstrace).then((value) {
                                        setState(() {
                                          obtracesController
                                              .getObservationTrace(
                                                  widget.traceId);
                                        });
                                     });
                                        }
                                      }
                                      // if (val == 1) {
                                      //  Utils().sendExcel();
                                      // }
                                    },
                                    itemBuilder: (BuildContext bc) {
                                      return [
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
                                                "Valider et synchroniser \ncette observation",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                    //   if(widget.sortie!.synchronised == true)  const PopupMenuItem(
                                    //       value: 1,
                                    //       child: Row(
                                    //         children: [
                                    //           Icon(
                                    //             Icons.download,
                                    //             color: Colors.black,
                                    //           ),
                                    //           SizedBox(
                                    //             width: 10,
                                    //           ),
                                    //           Text(
                                    //             "Générer un ficier Excel et envoyer",
                                    //             style: TextStyle(fontSize: 16),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    // 
                                    ];
                                    },
                                    icon: const Icon(Icons.more_vert_outlined,
                                        color: Colors.white, size: 25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                              )
                            ),
                         
                          
                            Positioned(
                              top: 10,
                              left: 10,
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
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                       
                         if(widget.sortie!.obstrace != null && widget.sortie!.obstrace!.traces != null) 
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                          child: Text(
                                            widget.sortie!.synchronised == true ? 'Cette observation est déjà synchronisée.' : "Cette observation n'est pas encore\n synchronisée. Veuillez synchroniser.",
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color:  widget.sortie!.synchronised == true ?  Colors.green : Colors.red),
                                                textAlign: TextAlign.center,
                                          ),
                                                         ),
                                  if(widget.sortie!.synchronised != true) 
                                    Center(
                                    child: InkWell(
                              onTap: () async {
                                    progress = ProgressDialog(context);
                                        progress.show();
                                       await SyncController().sendSortie(widget.sortie!, 32, obstraceModel: widget.sortie!.obstrace).then((value) {
                                        setState(() {
                                          obtracesController
                                              .getObservationTrace(
                                                  widget.traceId);
                                        });
                                     });
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Synchroniser",
                                      style: GoogleFonts.nunito(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                                                        ),
                                                      ),
                                                      
                                ],
                              ),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Lieu de l'observation",
                                    color: Constants.colorPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )
                                ],
                              ),
                              GridView(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 1,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  gridChildInfos("Secteur",
                                      "  ${trace.secteur?.name ?? ""}"),
                                  gridChildInfos("Sous Secteur",
                                      "  ${trace.sousSecteur?.name ?? ""}"),
                                  gridChildInfos(
                                      "Plage", "  ${trace.plage?.name ?? ""}"),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade500,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Latitude",
                                                      style: GoogleFonts.nunito(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      (trace.location == null ||
                                                              trace.location!
                                                                      .latitude ==
                                                                  null ||
                                                              trace
                                                                      .location!
                                                                      .latitude!
                                                                      .degMinSec ==
                                                                  null)
                                                          ? "Inconnu"
                                                          : trace
                                                              .location!
                                                              .latitude!
                                                              .degMinSec
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.nunito(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Longitude",
                                                      style: GoogleFonts.nunito(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      (trace.location == null ||
                                                              trace.location!
                                                                      .longitude ==
                                                                  null ||
                                                              trace
                                                                      .location!
                                                                      .longitude!
                                                                      .degMinSec ==
                                                                  null)
                                                          ? "Inconnu"
                                                          : trace
                                                              .location!
                                                              .longitude!
                                                              .degMinSec
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.nunito(),
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
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: "Météo",
                                      color: Constants.colorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
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
                                      "Heure d'observation",
                                      trace.heure == null
                                          ? "Non défini"
                                          : Utils.formatTime(
                                              trace.heure?.toInt() ?? 0)),
                                  gridChild(
                                      "Etat de la mer- Douglas",
                                      trace.weatherReport?.seaState?.nom ??
                                          "Non défini"),
                                  gridChild(
                                      "Couverture nuageuse",
                                      trace.weatherReport?.cloudCover?.nom ??
                                          "Non défini"),
                                  gridChild(
                                      "Force du vent",
                                      trace.weatherReport?.windForce
                                              ?.description ??
                                          "Non défini"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.all(
                              10,
                            ),
                            padding: const EdgeInsets.only(
                                left: 5, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade500, width: 0.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Remarques",
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (trace.remark == null || trace.remark == '')
                                        ? "Aucune remarque"
                                        : trace.remark ?? '',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        if(trace.presenceNid == null)
                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(()=> PresenceNidScreen(trace: trace ,edit: false, level: 0, sortie: widget.sortie,))!.then((value) =>  setState(() {
                                obtracesController.getObservationTrace(widget.traceId);
                              }));
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
                                    "Marquer une présence de nid",
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
                        if(trace.presenceNid != null)
                          Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Présence de nid",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => PresenceNidScreen(
                                            trace: trace, edit: true, level: 0, sortie: widget.sortie,))!
                                        .then((value) {
                                      setState(() {
                                        obtracesController
                                            .getObservationTrace(widget.traceId);
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
                                 gridChild("Présence de nid", trace.presenceNid?.presenNid == true ? "Oui" : "Non"),
                                gridChild("Date", Utils.formatDate(trace.presenceNid?.date?.toInt() ?? 0)),
                               ],
                            ),
                            SizedBox(height: 10,),
                            if(trace.emergence == null)
                            Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(()=> PresenceNidScreen(trace: trace ,edit: false, level: 1, sortie: widget.sortie,))!.then((value) =>  setState(() {
                                obtracesController.getObservationTrace(widget.traceId);
                              }));
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
                                    "Ajouter l'émergence du nid",
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
                           if(trace.emergence != null)
                          Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Emergence du nid",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => PresenceNidScreen(
                                            trace: trace, edit: true, level: 1, sortie: widget.sortie,))!
                                        .then((value) {
                                      setState(() {
                                        obtracesController
                                            .getObservationTrace(widget.traceId);
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
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio:1,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                 gridChild("Emergence du nid", trace.emergence?.emergence == true ? "Oui" : "Non"),
                                gridChild("Date de début", Utils.formatDate(trace.emergence?.dateDebut?.toInt() ?? 0)),
                                gridChild("Date de fin", Utils.formatDate(trace.emergence?.dateFin?.toInt() ?? 0)),
                               ],
                            ),
                           const SizedBox(height: 5,),
                                Container(
                            margin: const EdgeInsets.all(
                              0,
                            ),
                            padding: const EdgeInsets.only(
                                left: 5, bottom: 10, top: 10 , right: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade500, width: 0.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Remarques",
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (trace.emergence!.remark == null || trace.emergence!.remark  == '')
                                        ? "Aucune remarque"
                                        : trace.emergence!.remark  ?? '',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                    ),
                                    
                                  )
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                            if(trace.esclavation == null)
                            Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(()=> PresenceNidScreen(trace: trace ,edit: false, level: 2, sortie: widget.sortie,))!.then((value) =>  setState(() {
                                obtracesController.getObservationTrace(widget.traceId);
                              }));
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
                                    "Ajouter l'excavation du nid",
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
                         if(trace.esclavation != null)
                          Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Excavation du nid",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => PresenceNidScreen(
                                            trace: trace,edit: true, level: 2, sortie: widget.sortie,))!
                                        .then((value) {
                                      setState(() {
                                        obtracesController
                                            .getObservationTrace(widget.traceId);
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
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 1,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                 gridChild("Excavation du nid", trace.esclavation?.esclavation == true ? "Oui" : "Non"),
                                gridChild("Date de début", Utils.formatDate(trace.esclavation?.dateDebut?.toInt() ?? 0)),
                                gridChild("Date de fin", Utils.formatDate(trace.esclavation?.dateFin?.toInt() ?? 0)),
                               ],
                            ),
                              const SizedBox(height: 5,),
                                Container(
                            margin: const EdgeInsets.all(
                              0,
                            ),
                            padding: const EdgeInsets.only(
                                left: 5, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade500, width: 0.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Remarques",
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (trace.esclavation!.remark == null || trace.esclavation!.remark  == '')
                                        ? "Aucune remarque"
                                        : trace.esclavation!.remark  ?? '',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                         
                          ],
                        ),
                      ),

                  
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Get.dialog(const DeleteDialog())
                                          .then((value) {
                                        if (value == true) {
                                          obtracesController
                                              .deleteObservationTrace(
                                                  widget.traceId);
                                                  if(widget.sortie?.obstrace?.prospection == null){
                                                    sortieController.deleteSortie(widget.sortie!.id!);
                                                  }else{
                                                          Get.back();
                                                  }
                                        }
                                      });
                                    },
                                    child: const CustomText(text: "Supprimer")),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      Get.to(() => AddObservationTracesScreen(
                                              trace: trace, sortie: widget.sortie))!
                                          .then((value) {
                                        setState(() {
                                          obtracesController
                                              .getObservationTrace(
                                                  widget.traceId);
                                        });
                                      });
                                    },
                                    child: const CustomText(text: "Modifier")),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }

 
  Widget gridChild(String title, String value) {
    return Container(
        padding: const EdgeInsets.only(left: 5, bottom: 10, top: 10, right: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500, width: 0.5),
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
}

class DetailItem extends StatelessWidget {
  final String title;
  final String subTitle;
  const DetailItem({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width / 2.2,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey.shade300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          CustomText(text: subTitle)
        ],
      ),
    );
  }
}
