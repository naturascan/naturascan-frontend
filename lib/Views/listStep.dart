import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/showInfosDialog.dart';
import 'package:naturascan/Views/LogingScreen.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/Views/stedForm/stepScreen.dart';
import 'package:naturascan/Views/stepDetail.dart';
import 'package:naturascan/controllers/etapeController.dart';
import 'package:naturascan/models/local/etapeModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';

import '../main.dart';

class ListStepScreen extends StatefulWidget {
  final SortieModel shiping;
  const ListStepScreen({super.key, required this.shiping});

  @override
  State<ListStepScreen> createState() => _ListStepScreenState();
}

class _ListStepScreenState extends State<ListStepScreen> {
  @override
  void initState() {
    super.initState();
    etapeController.fetchEtapesByShippingId(
        limit: 100, offset: 0, shippingId: widget.shiping.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.colorPrimary,
          centerTitle: true,
          leading: const AppBarBack(),
          title: const CustomText(
            text: "Liste des étapes",
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Constants.colorPrimary,
          onPressed: () {
            etapeController.reset();
            addStep();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: GetBuilder(
            init: etapeController,
            builder: (etapeControl) {
              if (etapeController.etapeList.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
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
                          "Aucune étape ajoutée.",
                          style: GoogleFonts.nunito(fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              etapeController.reset();
                              Get.to(() => StepScreen(
                                    shiping: widget.shiping,
                                  ));
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  decoration: BoxDecoration(
                                    color: Constants.colorPrimary,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      'Ajouter une étape',
                                      style: GoogleFonts.nunito(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  itemCount: etapeController.etapeList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return getItem(etapeController.etapeList[index], index);
                  },
                );
              }
            }));
  }

  Widget getItem(EtapeModel etape, int index) {
    print('etape est ${etape.toJson()}');
    return GestureDetector(
        onTap: () {
          Get.to(() =>
              StepDetailScreen(shiping: widget.shiping, stepID: etape.id!));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Container(
            height: 120,
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(color: Colors.grey.shade300, width: 0.4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        border: Border.all(
                          color: Colors.grey.shade600,
                        ),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${etape.pointDePassage?.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                if (etape.pointDePassage != null)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place_outlined,
                                        size: 10,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          "lat: ${etape.pointDePassage?.latitudeDegMinSec}, long: ${etape.pointDePassage?.longitudeDegMinSec}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              height: 1.1,
                                              color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Heure d'arrivée:",
                                  style: GoogleFonts.nunito(
                                      decoration: TextDecoration.underline,
                                      fontSize: 12),
                                ),
                                Text(etape.heureArriveePort != null ?
                                  Utils.formatTime(etape.heureArriveePort?.toInt() ?? 0) : "Non défini",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Heure de départ:",
                                  style: GoogleFonts.nunito(
                                      decoration: TextDecoration.underline,
                                      fontSize: 12),
                                ),
                                Text(
                                 etape.heureDepartPort != null ?
                                  Utils.formatTime(etape.heureDepartPort?.toInt() ?? 0) : "Non défini",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => StepScreen(
                              shiping: widget.shiping,
                              etape: etape,
                            ));
                      },
                      child: Card(
                        elevation: 2,
                        shape: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                        onTap: () {
                          Get.dialog(const DeleteDialog()).then((value) {
                            if (value == true) {
                              etapeController.deleteEtape(etape.id!);
                            }
                          });
                        },
                        child: Card(
                          elevation: 2,
                          shape: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.delete,
                              size: 15,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

void addStep(){
    if(widget.shiping.finished == true){
      ShowInfosDialog().show(context, "Cette sortie est déjà finalisé. Vous ne pouvez plus ajouter des étapes");
    }else{
       Get.to(() => StepScreen(shiping: widget.shiping));
    }
  }
}
