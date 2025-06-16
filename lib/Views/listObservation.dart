import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/showInfosDialog.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/Views/observationForm/observForm.dart';
import 'package:naturascan/models/local/categorySpecies.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import '../../../Utils/constants.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class ObservationListScreen extends StatefulWidget {
  final SortieModel shipping;
  const ObservationListScreen({super.key, required this.shipping});

  @override
  State<ObservationListScreen> createState() => _ObservationListScreenState();
}

class _ObservationListScreenState extends State<ObservationListScreen> {
  bool withObser = false;

  List<Cat> cats = [
    Cat(id: 11, title: "Cétacés"),
    Cat(id: 4, title: "Poissons"),
    Cat(id: 2, title: "Oiiseaux"),
    Cat(id: 12, title: "Tortues"),
    Cat(id: 13, title: "Invertébrés"),
    Cat(id: 14, title: "Déchets")
  ];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async{
  await categorySpeciesController.fetchCategorySpecies();
    print('xxxnxx ${categorySpeciesController.categorySpeciesList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Constants.colorPrimary,
        centerTitle: true,
        leading: const AppBarBack(),
        title: const CustomText(
          text: "Liste des observations",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder(
          init: observationController,
          builder: (observationControl) {
            return categorySpeciesController.categorySpeciesList.isEmpty ?
           const Center(child: CircularProgressIndicator())
            :
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 200),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: cats.length,
                      itemBuilder: (context, index) {
                            Cat item = cats[index];
                          CategorySpeciesModel cat = categorySpeciesController
                            .categorySpeciesList.firstWhere((element) => element.id == item.id);
                        String title = cat.name?.toLowerCase() ?? "";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Observation $title",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Constants.colorPrimary),
                                ),
                                InkWell(
                                  onTap: () {
                                    observationControl.reset();
                                    if(cat.id == 14){
                                       observationControl.type.value = 2;
                                    }else if(cat.id == 2){
                                      observationControl.type.value = 1;
                                    }else{
                                      observationControl.type.value = 0;
                                    }
                                    categorySpeciesController
                                        .selectedCateory.value = cat;
                                    categorySpeciesController.selectedSpecie.value = cat.especes!.first;
                                    setState(() {
                                      
                                    });                                 
                                    addObservation();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Constants.colorPrimary)),
                                    child: const Icon(Icons.add,
                                        color: Constants.colorPrimary),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            SizedBox(
                              height: 190,
                              child: FutureBuilder(
                                  future: observationController
                                      .fetchObservationByTypeId(
                                          limit: 20,
                                          offset: 0,
                                          type: cat.id!,
                                          shippingID: widget.shipping.id!),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? snapshot.data.isEmpty
                                            ? const Center(
                                                child: CustomText(
                                                text:
                                                    "Aucune observation de ce type n'a été ajoutée",
                                                fontSize: 18,
                                                textAlign: TextAlign.center,
                                              ))
                                            : ListView.builder(
                                                itemCount:
                                                    snapshot.data!.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return getItem(
                                                      snapshot.data[index]
                                                          as ObservationModel,
                                                      1);
                                                },
                                              )
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                  }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget getItem(ObservationModel data, int nature) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: InkWell(
          onTap: () {
             categorySpeciesController.selectedCateory.value = categorySpeciesController
                            .categorySpeciesList.firstWhere((element) => element.id == data.categorieId, orElse: (() => categorySpeciesController.categorySpeciesList.first));
            Get.to(() => ObservationDetailsScreen(
                  shipping: widget.shipping,
                  observationId: data.id!,
                  nature: nature,
                ));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 1,
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Container(
                        width: 150,
                        height: 70,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade500, width: 0.5),
                                  right: BorderSide(
                                      color: Colors.grey.shade500, width: 0.5),
                                )),
                                child: Container(
                                    padding: const EdgeInsets.all(7),
                                    margin: const EdgeInsets.only(
                                        right: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.grey.shade400,
                                    )),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                if (data.type == 0)
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 5, top: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Min:  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          data.animal!.nbreMini == null
                                              ? "Non défini"
                                              : "${data.animal!.nbreMini}",
                                          style: TextStyle(
                                              fontSize:
                                                  data.animal!.nbreMini == null
                                                      ? 8
                                                      : 12),
                                        )
                                      ],
                                    ),
                                  ),
                                if (data.type == 0)
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 5, top: 3),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Max:  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          data.animal!.nbreMaxi == null
                                              ? "Non défini"
                                              : "${data.animal!.nbreMaxi}",
                                          style: TextStyle(
                                              fontSize:
                                                  data.animal!.nbreMaxi == null
                                                      ? 8
                                                      : 12),
                                        )
                                      ],
                                    ),
                                  ),
                                if (data.type == 1)
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 5, top: 3),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Nbre:  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          data.bird!.nbreEstime == null
                                              ? "Non défini"
                                              : "${data.bird!.nbreEstime}",
                                          style: TextStyle(
                                              fontSize:
                                                  data.bird!.nbreEstime == null
                                                      ? 8
                                                      : 12),
                                        )
                                      ],
                                    ),
                                  ),
                                if (data.type == 1)
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 5, top: 3),
                                    child: Row(
                                      children: [
                                        Icon(
                                          data.bird!.presenceJeune == true
                                              ? Icons.check_circle_outline
                                              : Icons.circle_outlined,
                                          size: 10,
                                          color: Colors.teal,
                                        ),
                                        const Text(
                                          "  Jeune",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                if (data.type == 2)
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 5, top: 3),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Taille:  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          data.waste!.estimatedSize == null
                                              ? "Non défini"
                                              : "${data.waste!.estimatedSize}",
                                          style: TextStyle(
                                              fontSize:
                                                  data.waste!.estimatedSize ==
                                                          null
                                                      ? 8
                                                      : 12),
                                        )
                                      ],
                                    ),
                                  ),
                                if (data.type == 2)
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 5, top: 3),
                                    child: Row(
                                      children: [
                                        Icon(
                                          data.waste!.picked == true
                                              ? Icons.check_circle_outline
                                              : Icons.circle_outlined,
                                          size: 10,
                                          color: Colors.teal,
                                        ),
                                        const Text(
                                          "  ramassé",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ))
                          ],
                        ),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 3, right: 3),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 10,
                          color: Colors.teal,
                        ),
                        Text(
                          data.date == null
                              ? "  ${data.createdAt}".substring(0, 12)
                              : "  ${Utils.formatDate1(data.date?.toInt() ?? 0)}",
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
                  if (data.type == 0)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 3, left: 3, right: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Début",
                                style: GoogleFonts.nunito(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 10,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    (data.animal!.heureDebut == null)
                                        ? ""
                                        : "  ${Utils.formatTime(data.animal?.heureDebut?.toInt() ?? 0)}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fin",
                                style: GoogleFonts.nunito(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 10,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    (data.animal!.heureFin == null)
                                        ? ""
                                        : "  ${Utils.formatTime(data.animal?.heureFin?.toInt() ?? 0)}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (data.type == 1)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 3, left: 3, right: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Début",
                                style: GoogleFonts.nunito(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 10,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    (data.bird!.heureDebut == null)
                                        ? ""
                                        : "  ${Utils.formatTime(data.bird?.heureDebut?.toInt() ?? 0)}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fin",
                                style: GoogleFonts.nunito(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 10,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    (data.bird!.heureFin == null)
                                        ? ""
                                        : "  ${Utils.formatTime(data.bird?.heureFin?.toInt() ?? 0)}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (data.type == 2)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 3, left: 3, right: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Heure d'observation",
                                style: GoogleFonts.nunito(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 10,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    (data.waste!.heureDebut == null)
                                        ? ""
                                        : "  ${Utils.formatTime(data.waste?.heureDebut?.toInt() ?? 0)}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ObservationScreen(
                                shiping: widget.shipping,
                                observation: data,
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
                              observationController.deleteObservation(data.id!);
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
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void addObservation() {
    if (widget.shipping.finished == true) {
      ShowInfosDialog().show(context,
          "Cette sortie est déjà finalisé. Vous ne pouvez plus ajouter des observatons");
    } else {
      Get.to(() => ObservationScreen(
            shiping: widget.shipping,
          ));
    }
  }
}


class Cat{
  int id;
  String title;
   Cat({required this.id, required this.title});
}