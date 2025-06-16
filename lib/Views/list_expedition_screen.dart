import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Utils/res.dart';
import 'package:naturascan/Utils/showInfosDialog.dart';
import 'package:naturascan/Views/DetailsExpedition.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:naturascan/Views/Obstraces/AddProspection/addProspectionByStep.dart';
import 'package:naturascan/Views/Obstraces/ProspectionDetails.dart';
import 'package:naturascan/Views/Obstraces/addObservationTraceScreen.dart';
import 'package:naturascan/Views/Obstraces/observationTraceDetailsScreen.dart';
import 'package:naturascan/Views/addShippingsForm/addFormByStep.dart';
import 'package:naturascan/Views/conditionsScreen.dart';
import 'package:naturascan/controllers/obstraceController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ListExpeditionScreen extends StatefulWidget {
  final int step;
  const ListExpeditionScreen({super.key, required this.step});

  @override
  State<ListExpeditionScreen> createState() => _ListExpeditionScreenState();
}

class _ListExpeditionScreenState extends State<ListExpeditionScreen> {
  bool loading = true;
  bool enCours = false;
  String type = "NaturaScan";
  List<SortieModel> lists = [];
  int role = 0;
  int surtype = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getSorties();
    });
    super.initState();
  }

  void getSorties() async {
    if(widget.step == 0){
         surtype = 0;
         await PrefManager.putString(Constants.selectedType, 'NaturaScan');
    }else{
            surtype = 1;
      if(widget.step == 1){
         type = "Prospection";
            await PrefManager.putString(Constants.selectedType, 'Prospection');
      }else{
        type = "SuiviTrace";
          await PrefManager.putString(Constants.selectedType, 'SuiviTrace');
      }
    }
    await Utils().getUser();
    role = await PrefManager.getInt(Constants.role);
    setState(() {});
    if (role == 2) {
      setState(() {
        type = "Prospection";
        surtype = 1;
      });
    await PrefManager.putString(Constants.selectedType, 'Prospection');
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.location,
      Permission.manageExternalStorage,
    ].request();
    getSortiesbyType();
  }

  Future<void> getSortiesbyType() async {
    // sortieController.sortieList.clear();
    // sortieController.latestSortie.clear();
    if (type == "SuiviTrace") {
      await sortieController.fetchSortiesSuiviTraces(type,
          limit: 100, offset: 0);
     await PrefManager.putString(Constants.selectedType, 'SuiviTrace');
    } else {
     await PrefManager.putString(Constants.selectedType, type);
      await sortieController.fetchSortiesByType(type, offset: 5, limit: 100);
      await sortieController.fetchLatestSortiesByType(type, offset: 0, limit: 5);
      // lists.clear();
      lists = sortieController.latestSortie;
    }
    setState(() {
      
    });
    await 0.2.delay();
    setState(() {
      loading = false;
    });
  }
  Future<void> _refresh() async {
    setState(() {
      loading = true;
    });
    SyncController().sync();
    getSorties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Acceuil",
          style: TextStyle(
              color: Constants.colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [myPopMenu()],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 70,
        type: ExpandableFabType.up,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(
            Icons.add,
            size: 25,
          ),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: Constants.colorPrimary,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.small,
          foregroundColor: Colors.black,
          backgroundColor: Colors.tealAccent,
          shape: const CircleBorder(),
        ),
        children: [
          if (role == 0 || role == 1)
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                addSortie();
              },
              label: Text(
                "Nouvelle sortie\n Naturascan",
                style: GoogleFonts.nunito(fontSize: 18),
              ),
            ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              Get.to(() => const AddObservationTracesScreen(
                    sortie: null,
                    trace: null,
                  ));
            },
            label: Text(
              "Nouvelle trace sans effort\n d'observation",
              style: GoogleFonts.nunito(fontSize: 18),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
            addProspection();
            },
            label: Text(
              "Nouvelle prospection \nen effort d'observation",
              style: GoogleFonts.nunito(fontSize: 18),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: GetBuilder(
                init: sortieController,
                builder: (sortieControl) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              if (role == 0 || role == 1)
                                SizedBox(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                      padding: const EdgeInsets.only(left: 20),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              surtype = 0;
                                              type = "NaturaScan";
                                              loading = true;
                                            });
                                            getSortiesbyType();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                color: type == "NaturaScan"
                                                    ? Constants.colorPrimary
                                                    : Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: CustomText(
                                                text: 'NaturaScan',
                                                color: type == "NaturaScan"
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              surtype = 1;
                                              type = "Prospection";
                                              loading = true;
                                            });
                                            getSortiesbyType();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                color: surtype == 1
                                                    ? (role == 1 || role == 0)
                                                        ? Colors.grey.shade600
                                                        : Constants.colorPrimary
                                                    : Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: CustomText(
                                                text: 'SuiviTrace',
                                                color: surtype == 1
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              if (role == 2)
                                SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                      padding: const EdgeInsets.only(left: 20),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              surtype = 1;
                                              type = "Prospection";
                                              loading = true;
                                            });
                                            getSortiesbyType();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                color: type == "Prospection"
                                                    ? Constants.colorPrimary
                                                    : Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: CustomText(
                                                text:
                                                    'Prospection en\neffort d\'observation',
                                                color: type == "Prospection"
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              surtype = 1;
                                              type = "SuiviTrace";
                                              loading = true;
                                            });
                                            getSortiesbyType();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                color: type == "SuiviTrace"
                                                    ? Constants.colorPrimary
                                                    : Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: CustomText(
                                                text:
                                                    'Trace sans effort\nd\'observation',
                                                color: type == "SuiviTrace"
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),

                              /// sortie naturascan
                              if (surtype == 0)
                                Column(
                                  children: [
                                    loading ?
                                   const SizedBox(
                                      height: 500,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    :
                                    (sortieController.sortieList.isEmpty &&
                                            sortieController
                                                .latestSortie.isEmpty)
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _refresh();
                                                  },
                                                  child: Icon(
                                                    Icons.refresh,
                                                    color: Colors.grey.shade500,
                                                    size: 50,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Center(
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "Aucune sortie naturascan trouvée.\n Veuillez ajouter une sortie.",
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        addSortie();
                                                      },
                                                      child: Card(
                                                        elevation: 2,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 30.0,
                                                                    right:
                                                                        30.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Constants
                                                                  .colorPrimary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            height: 45,
                                                            child: Center(
                                                              child: Text(
                                                                'Ajouter une sortie',
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              if (sortieController
                                                  .sortieList.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 20),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Text("Plus anciennes",
                                                              style: GoogleFonts.nunito(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                       ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 175,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              sortieController
                                                                  .sortieList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return getItem(
                                                                sortieController
                                                                        .sortieList[
                                                                    index]);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              if (sortieController
                                                  .latestSortie.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 20),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Text(
                                                              "Sorties récentes",
                                                              style: GoogleFonts.nunito(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        // height: MediaQuery.of(context).size.height,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              sortieController
                                                                  .latestSortie
                                                                  .length,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return getItem2(
                                                                sortieController
                                                                        .latestSortie[
                                                                    index]);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            ],
                                          )
                                  ],
                                ),

                              /// suivietrca
                              if (surtype == 1)
                                Column(
                                  children: [
                                    if (role != 2)
                                      SizedBox(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 20),
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    surtype = 1;
                                                    type = "Prospection";
                                                    loading = true;
                                                  });
                                                  getSortiesbyType();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15,
                                                          right: 15,
                                                          top: 5,
                                                          bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          type == "Prospection"
                                                              ? Constants
                                                                  .colorPrimary
                                                              : Colors.grey
                                                                  .shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                    child: CustomText(
                                                      text:
                                                          'Prospection en\neffort d\'observation',
                                                      color:
                                                          type == "Prospection"
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    surtype = 1;
                                                    type = "SuiviTrace";
                                                    loading = true;
                                                  });
                                                  getSortiesbyType();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15,
                                                          right: 15,
                                                          top: 5,
                                                          bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          type == "SuiviTrace"
                                                              ? Constants
                                                                  .colorPrimary
                                                              : Colors.grey
                                                                  .shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                    child: CustomText(
                                                      text:
                                                          'Trace sans effort\nd\'observation',
                                                      color:
                                                          type == "SuiviTrace"
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    if (type == "Prospection")
                                       loading ?
                                   const SizedBox(
                                      height: 500,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    : (sortieController.sortieList.isEmpty &&
                                              sortieController
                                                  .latestSortie.isEmpty)
                                          ? SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  100,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _refresh();
                                                    },
                                                    child: Icon(
                                                      Icons.refresh,
                                                      color:
                                                          Colors.grey.shade500,
                                                      size: 50,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      "Aucune prospection trouvée.\n Veuillez ajouter une prospection.",
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                       addProspection();
                                                        },
                                                        child: Card(
                                                          elevation: 2,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          30.0,
                                                                      right:
                                                                          30.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Constants
                                                                    .colorPrimary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              height: 45,
                                                              child: Center(
                                                                child: Text(
                                                                  'Ajouter une prospection',
                                                                  style: GoogleFonts.nunito(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                if (sortieController
                                                    .sortieList.isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 20),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: <Widget>[
                                                            Text(
                                                                "Plus anciennes",
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          height: 175,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                sortieController
                                                                    .sortieList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return getItem(
                                                                  sortieController
                                                                          .sortieList[
                                                                      index]);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                if (sortieController
                                                    .latestSortie.isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 20),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: <Widget>[
                                                            Text(
                                                                "Prospections récentes",
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          // height: MediaQuery.of(context).size.height,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                sortieController
                                                                    .latestSortie
                                                                    .length,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return getItem2(
                                                                  sortieController
                                                                          .latestSortie[
                                                                      index]);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            )
                                  ],
                                ),

                              /// trace 
                              if (type == "SuiviTrace")
                                Column(
                                  children: [
                                     loading ?
                                   const SizedBox(
                                      height: 500,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    :
                                    sortieController.sortieTraceList.isEmpty
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _refresh();
                                                  },
                                                  child: Icon(
                                                    Icons.refresh,
                                                    color: Colors.grey.shade500,
                                                    size: 50,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Center(
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "Aucune observation trace trouvée.\n Veuillez ajouter une observation trace.",
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            const AddObservationTracesScreen(
                                                              sortie: null,
                                                              trace: null,
                                                            ));
                                                      },
                                                      child: Card(
                                                        elevation: 2,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 30.0,
                                                                    right:
                                                                        30.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Constants
                                                                  .colorPrimary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            height: 45,
                                                            child: Center(
                                                              child: Text(
                                                                'Ajouter une trace',
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              if (sortieController
                                                  .sortieTraceList.isNotEmpty)
                                                SizedBox(
                                                  height: sortieController
                                                        .sortieTraceList.length* 110 + 60 ,
                                                  child: GridView.builder(
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing: 5,
                                                      mainAxisSpacing: 5,
                                                      childAspectRatio: 0.9,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50,
                                                            top: 15,
                                                            left: 10,
                                                            right: 10),
                                                    itemCount: sortieController
                                                        .sortieTraceList.length,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return getItemSuiviTrace(
                                                          sortieController
                                                              .sortieTraceList[index]
                                                              .obstrace!
                                                              .traces!,
                                                          sortieController
                                                              .sortieTraceList[index]);
                                                    },
                                                  ),
                                                )
                                            ],
                                          )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  Widget getItemSuiviTrace(ObservationTrace trace, SortieModel sortie) {
    return FutureBuilder(
        future: ObstracesController().getObservationTrace(trace.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              ObservationTrace item = snapshot.data;
              return Padding(
                padding: const EdgeInsets.only(right: 0),
                child: InkWell(
                    onTap: () {
                      Get.to(() => ObservationTraceDetails(
                                traceId: item.id!,
                                sortie: sortie,
                              ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      elevation: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      image: item.photos == null
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                Res.ic_trace,
                                              ),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image:
                                                  FileImage(File(item.photos!)), fit: BoxFit.cover)),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 3, right: 3),
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          item.heure?.toInt() ?? 0),
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 3, left: 3, right: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.place,
                                    color: Constants.colorPrimary,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      (item.location?.latitude?.degMinSec ==
                                                  null &&
                                              item.location?.longitude
                                                      ?.degMinSec ==
                                                  null)
                                          ? 'Non défini'
                                          : "lat: ${item.location?.latitude?.degMinSec ?? ''},  long: ${item.location?.longitude?.degMinSec ?? ''}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        ),
                      ),
                    )),
              );
            } else {
              return Container();
            }
          } else {
            return const Center(
                child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    )));
          }
        });
  }

  Widget getItem(SortieModel item) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: InkWell(
          onTap: () {
            if (item.naturascan != null) {
              Get.to(() => DetailsExpeditionScreen(
                    idShiiping: item.id!,
                  ));
            } else {
              Get.to(() => ProspectionDetailsScreen(
                    idShiiping: item.id!,
                  ));
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              //set border radius more than 50% of height and width to make circle
            ),
            elevation: 1,
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Container(
                        width: 130,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            image: item.photo == null
                                ? DecorationImage(
                                    image: AssetImage(
                                      item.naturascan == null
                                          ? Res.ic_prospection
                                          : Res.ic_expedition,
                                    ),
                                    fit: BoxFit.cover)
                                : DecorationImage(
                                    image: FileImage(File(item.photo!)))),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 3, right: 3),
                    child: FittedBox(
                      child: Text(
                        "${item.naturascan == null ? "Prospection" : "Sortie"} du ${Utils.formatDate1(item.date!.toInt())}",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 3, left: 3, right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Type: ",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                        Text(
                          item.type ?? 'NaturaScan',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget getItem2(SortieModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: InkWell(
          onTap: () {
            if (item.naturascan != null) {
              Get.to(() => DetailsExpeditionScreen(
                    idShiiping: item.id!,
                  ));
            } else {
              Get.to(() => ProspectionDetailsScreen(
                    idShiiping: item.id!,
                  ));
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              //set border radius more than 50% of height and width to make circle
            ),
            elevation: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            image: item.photo == null
                                ? DecorationImage(
                                    image: AssetImage(
                                      item.naturascan == null
                                          ? Res.ic_prospection
                                          : Res.ic_expedition,
                                    ),
                                    fit: BoxFit.cover)
                                : DecorationImage(
                                    image: FileImage(File(item.photo!)),
                                    fit: BoxFit.cover),
                          ))),
                  if (item.naturascan != null)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 3, left: 3, right: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date de la sortie: ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 14, color: Colors.grey.shade600),
                              ),
                              Text(
                                " ${Utils.formatDate1(item.date!.toInt())}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: item.naturascan == null ? 10 : 0,
                              left: 3,
                              right: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Type: ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 14, color: Colors.grey.shade600),
                              ),
                              Text(
                                "${item.type}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    color: Constants.colorPrimary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: item.naturascan == null ? 10 : 0,
                              left: 3,
                              right: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Statut: ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 14, color: Colors.grey.shade600),
                              ),
                              Text(
                                  item.synchronised == true ? "Synchronisée" : item.finished == true ?  "Non synchronisée" : "En cours",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: item.synchronised == true ?  Colors.green : item.finished == true ? Colors.red : Colors.grey.shade500,
                                      fontWeight: FontWeight.w600
                                      ),
                                ),
                            ],
                          ),
                        ),
                       const SizedBox(height: 5,)
                     
                      ],
                    ),
                  if (item.obstrace != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: "Secteur:  ",
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.bold,
                                                 color: Colors.black,
                                              fontSize: 14),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text:
                                                  (item.obstrace!.prospection ==
                                                              null ||
                                                          item
                                                                  .obstrace!
                                                                  .prospection!
                                                                  .secteur ==
                                                              null)
                                                      ? "Inconnu"
                                                      : item
                                                              .obstrace
                                                              ?.prospection
                                                              ?.secteur
                                                              ?.name ??
                                                          "Inconnu",
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            )
                                          ]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: "Sous-Secteur:  ",
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: (item.obstrace!
                                                              .prospection ==
                                                          null ||
                                                      item
                                                              .obstrace!
                                                              .prospection!
                                                              .sousSecteur ==
                                                          null)
                                                  ? "Inconnu"
                                                  : item.obstrace?.prospection
                                                          ?.sousSecteur?.name ??
                                                      "Inconnu",
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            )
                                          ]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: "Plage:  ",
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.bold,
                                             color: Colors.black,
                                              fontSize: 14),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text:
                                                  (item.obstrace!.prospection ==
                                                              null ||
                                                          item
                                                                  .obstrace!
                                                                  .prospection!
                                                                  .plage ==
                                                              null)
                                                      ? "Inconnu"
                                                      : item
                                                              .obstrace
                                                              ?.prospection
                                                              ?.plage
                                                              ?.name ??
                                                          "Inconnu",
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            )
                                          ]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text(
                                  item.synchronised == true ? "Synchronisée" : item.finished == true ?  "Non synchronisée" : "En cours",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: item.synchronised == true ?  Colors.green : item.finished == true ? Colors.red : Colors.grey.shade500,
                                      fontWeight: FontWeight.w600
                                      ),
                                ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Constants.colorPrimary,
                                          size: 15,
                                        ),
                                        Text(
                                          " ${Utils.formatDate1(item.date!.toInt())}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${item.type}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          color: Constants.colorPrimary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )),
    );
  }

  Widget myPopMenu() {
    return PopupMenuButton(
      onSelected: (val) async {
        if (val == 0) {
          Uri uri = Uri.parse("https://api-naturascan.norisix.com/admin");
          launchUrl(
            uri,
          );
        }
        if (val == 1) {
          SyncController().sync();
        }
        if (val == 2) {}

        if (val == 6) {
          Get.to(()=> const ConditionsScreen());
        }

        if (val == 5) {
            showDeleteDialog(); 
        }
      },
      itemBuilder: (BuildContext bc) {
        return [
          if (role == 0)
            const PopupMenuItem(
              value: 0,
              child: Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Back Office",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          const PopupMenuItem(
            value: 1,
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
                  "Synchroniser en arrière plan",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
               const PopupMenuItem(
            value: 6,
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
                  "Conditions d'utilisation",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
      if (role == 0)
            PopupMenuItem(
              onTap: () {
                 Utils().sendExcel();
              },
              value: 3,
              child: const Row(
                children: [
                  Icon(
                    Icons.download_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Télécharger le fichier Excel",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          PopupMenuItem(
            onTap: () async{
         progress = ProgressDialog(Get.context!);
         progress.show();
         await 0.5.delay();
             Utils().localLogout();
            },
            value: 4,
            child: const Row(
              children: [
                Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Se déconnecter",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        
          PopupMenuItem(
            onTap: () async{
            showDeleteDialog();
            },
            value: 5,
            child: const Row(
              children: [
                Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Supprimer le compte",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_outlined,
          color: Constants.colorPrimary, size: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void addSortie() {
    if (lists.isEmpty) {
      Get.to(() => const AddShippingScreen());
    } else {
      for (var element in lists) {
        if (element.finished != true) {
          enCours = true;
        }
      }
      if (enCours == false) {
        Get.to(() => const AddShippingScreen());
      } else {
        ShowInfosDialog().show(context,
            "Vous avez déjà une sortie en cours. Vous ne pouvez pas créer une autre. Veuillez finaliser la sortie en cours avant de créer une nouvelle sortie. \nMerci.");
      }
    }
  }

void addProspection() {
    if (lists.isEmpty) {
        Get.to(() => const AddProspectionStep(
                    shiping: null,
                  ));
    } else {
      for (var element in lists) {
        if (element.finished != true) {
          enCours = true;
        }
      }
      if (enCours == false) {
       Get.to(() => const AddProspectionStep(
                    shiping: null,
                  ));
      } else {
        ShowInfosDialog().show(context,
            "Vous avez déjà une prospection en cours. Vous ne pouvez pas créer une autre. Veuillez finaliser la prospection en cours avant de créer une nouvelle prospection. \nMerci.");
      }
    }
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
                            "Attention!!! Cette action est irréversible",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.red),
                          ),
                          Text(
                            "Etes vous sûre de vouloir supprimer cet compte? Vous allez perdre tous vos données.",
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
                                Get.back();
                               deleteAcount();
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


  void deleteAcount() async{ 
    progress = ProgressDialog(Get.context!);
    progress.show();
     await 0.5.delay();
    int? response = await ApiProvider("La suppression du compte a échouée").delete();
    print('response $response');
    if(response == 200){
      Utils().localLogout();
    }
  }

}

class AppBarBack extends StatelessWidget {
  const AppBarBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.colorPrimary.withOpacity(0.3)),
            child: const Center(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )),
      ),
    );
  }
}
