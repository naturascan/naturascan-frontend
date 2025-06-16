import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/res.dart';
import 'package:naturascan/Views/observationForm/observForm.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';

import '../Utils/constants.dart';

class ObservationDetailsScreen extends StatefulWidget {
  final SortieModel shipping;
  final String observationId;
  final int nature;
  const ObservationDetailsScreen(
      {super.key,
      required this.shipping,
      required this.observationId,
      required this.nature});

  @override
  State<ObservationDetailsScreen> createState() =>
      _ObservationDetailsScreenState();
}

class _ObservationDetailsScreenState extends State<ObservationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future:
                  observationController.getObservation(widget.observationId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ObservationModel data = snapshot.data;
                  observationController.type.value = data.type!.toInt();
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
                                  image: widget.shipping.photo == null
                                      ? const DecorationImage(
                                          image: AssetImage(
                                            Res.ic_expedition,
                                          ),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: FileImage(
                                            File(widget.shipping.photo!),
                                          ),
                                          fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(60))),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: double.maxFinite,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.7),
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(60))),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(right: 60, left: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: CustomText(
                                        text: "Détails de l'observation",
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                          height: 10,
                        ),
                        if(data.type != 2)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date d'observation",
                                        style: GoogleFonts.nunito(
                                            decoration: TextDecoration.underline,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data.date == null
                                            ? "Non défini"
                                            :  Utils.formatDate(data.date!.toInt()),
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ],
                                  ),
                                   Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Durée de l'observation",
                                        style: GoogleFonts.nunito(
                                            decoration: TextDecoration.underline,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                        if(data.type == 0)Text(
                                        data.animal!.duree == null
                                            ? "Non défini"
                                            :  data.animal!.duree.toString(),
                                        style: GoogleFonts.nunito(),
                                      ),
                                        if(data.type == 1)Text(
                                        data.bird!.duree == null
                                            ? "Non défini"
                                            :  data.bird!.duree.toString(),
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                                const SizedBox(
                          height: 10,
                        ),
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                 Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Heure de début",
                                    style: GoogleFonts.nunito(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if(data.type == 0)
                                  Text(
                                    data.animal!.heureDebut == null
                                        ? "Inconnu"
                                        : Utils.formatTime(data.animal?.heureDebut?.toInt() ?? 0),
                                    style: GoogleFonts.nunito(),
                                  ),
                                   if(data.type == 1)
                                  Text(
                                    data.bird!.heureDebut == null
                                        ? "Inconnu"
                                        : Utils.formatTime(data.bird?.heureDebut?.toInt() ?? 0),
                                    style: GoogleFonts.nunito(),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Heure de fin",
                                    style: GoogleFonts.nunito(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if(data.type == 0)
                                  Text(
                                    data.animal!.heureFin == null
                                        ? "Inconnu"
                                        : Utils.formatTime(data.animal?.heureFin?.toInt() ?? 0),
                                    style: GoogleFonts.nunito(),
                                  ),
                                    if(data.type == 1)
                                  Text(
                                    data.bird!.heureFin == null
                                        ? "Inconnu"
                                        : Utils.formatTime(data.bird?.heureFin?.toInt() ?? 0),
                                    style: GoogleFonts.nunito(),
                                  ),
                                ],
                              ),
                           
                            ],
                          ),
                      
                            ],
                          ),
                        ),
                       if(data.type == 2)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date d'observation",
                                        style: GoogleFonts.nunito(
                                            decoration: TextDecoration.underline,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data.date == null
                                            ? "Non défini"
                                            :  Utils.formatDate(data.date!.toInt()),
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ],
                                  ),
                                       Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Heure d'observation",
                                    style: GoogleFonts.nunito(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data.waste!.heureDebut == null
                                        ? "Inconnu"
                                        : Utils.formatTime(data.waste?.heureDebut?.toInt() ?? 0),
                                    style: GoogleFonts.nunito(),
                                  ),
                                ],
                              ),
                            
                              ],
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Information sur les ${categorySpeciesController.selectedCateory.value.name!.toLowerCase()}",
                                    color: Constants.colorPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (data.type == 0)
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
                                        "Espèce (nom scientifique)",
                                        (data.animal!.espece == null ||
                                                data.animal!.espece!
                                                        .scientificName ==
                                                    null ||  data.animal!.espece!
                                                        .scientificName ==
                                                    "")
                                            ? "Non défini"
                                            : data.animal!.espece!
                                                .scientificName ?? "Non défini"),
                                    gridChild(
                                        "Espèce (nom vernaculaire)",
                                        (data.animal!.espece == null ||
                                                data.animal!.espece!
                                                        .commonName ==
                                                    null ||data.animal!.espece!
                                                        .commonName ==
                                                    "")
                                            ? "Non défini"
                                            : data
                                                .animal!.espece!.commonName!),
                                   if(data.animal!.taille != null && data.animal!.taille != "") gridChild(
                                        "Taille du poisson",
                                        data.animal!.taille == null
                                            ? "Non défini"
                                            : data.animal!.taille.toString()),          
                                    gridChild(
                                        "Nombre estimé",
                                        data.animal!.nbreEstime == null
                                            ? "Non défini"
                                            : data.animal!.nbreEstime.toString()),
                                    gridChild(
                                        "Nombre min",
                                        data.animal?.nbreMini == null
                                            ? "Non défini"
                                            : data.animal!.nbreMini.toString()),
                                    gridChild(
                                        "Nombre max",
                                        data.animal!.nbreMaxi == null
                                            ? "Non défini"
                                            : data.animal!.nbreMaxi.toString()),
                                    gridChild(
                                        "Présence de jeunes",
                                        (data.animal!.nbreJeunes != true)
                                            ? "Non"
                                            : "Oui"),
                                    gridChild(
                                        "Présence de nouvveaux nés",
                                        (data.animal!.nbreNouveauNe != true)
                                            ? "Non"
                                            : "Oui"),
                                    gridChild(
                                      "Structure du groupe",
                                        (data.animal!.structureGroupe == null || data.animal!.structureGroupe == "")
                                            ? "Non défini"
                                            : data.animal!.structureGroupe.toString()),
                                 gridChild(
                                      "Sous groupe",
                                        (data.animal!.sousGroup != true)
                                            ? "Non"
                                            : "Oui"),
                                      if(data.animal!.sousGroup == true)  gridChild(
                                        "Nombre de sous groupe",
                                        (data.animal!.nbreSousGroupes == null)
                                            ? "Non défini"
                                            : data.animal!.nbreSousGroupes.toString()),
                                      if(data.animal!.sousGroup == true) gridChild(
                                        "Nombre d'individu par sous groupe",
                                        (data.animal!.nbreIndivSousGroupe == null)
                                            ? "Non défini"
                                            : data.animal!.nbreIndivSousGroupe
                                                .toString()),
                                    gridChild(
                                        "Vitesse de nage",
                                        (data.animal!.vitesse == null ||
                                                data.animal!.vitesse == "")
                                            ? "Non défini"
                                            : data.animal!.vitesse.toString()),
                                    gridChild(
                                        "Gisement",
                                        (data.animal!.gisement == null ||
                                                data.animal!.gisement == "")
                                            ? "Non défini"
                                            : "${data.animal!.gisement}"),
                                    gridChild(
                                        "Elément détection",
                                        (data.animal!.elementDetection == null ||
                                                data.animal!.elementDetection == "")
                                            ? "Non défini"
                                            : data.animal!.elementDetection.toString()),
                                    gridChild(
                                        "Distance estimée",
                                        (data.animal!.distanceEstimee == null || data.animal!.distanceEstimee == "")
                                            ? "Non défini"
                                            : data.animal!.distanceEstimee!),
                                    gridChild( "Comportemment en surface",
                                        (data.animal!.comportementSurface == null ||
                                                data.animal!.comportementSurface == "")
                                            ? "Non défini"
                                            : "${data.animal!.comportementSurface}"),
                                    gridChild(
                                        "Réaction au bateau",
                                        (data.animal!.reactionBateau == null ||
                                                data.animal!.reactionBateau == "")
                                            ? "Non défini"
                                            : "${data.animal!.reactionBateau}"),
                                    gridChild(
                                        "Espèces associés",
                                        (data.animal!.especesAssociees == null ||
                                                data.animal!.especesAssociees!.isEmpty)
                                            ? "Non défini"
                                            : data.animal!.especesAssociees!),
                                    gridChild(
                                        "Activités humaines associées",
                                        (data.animal!.activitesHumainesAssociees ==
                                                    true)
                                                ?   ( data.animal!.activitesHumainesAssocieesPrecision ==  null ||  data.animal!.activitesHumainesAssocieesPrecision ==  '')
                                            ? "Oui, non défini"
                                            : "${data.animal!.activitesHumainesAssocieesPrecision}" : "Pas d'activité",),
                                    gridChild(
                                        "Observation avec effort",
                                        data.animal!.effort == true
                                            ? "Oui"
                                            : "Non"),
                                    gridChild(
                                        "Prise de photos",
                                         data.animal!.photos == true
                                                ? "Oui"
                                                : "Non"),
                                       if(data.animal!.photos == true) gridChild(
                                        "Nom du photographe",
                                         data.photograph == null
                                                ? "Non défini"
                                                : "${data.photograph?.name??""} ${data.photograph?.firstname}"),
                                   gridChild(
                                        "Vitesse du navire",
                                        (data.animal!.vitesseNavire == null ||
                                                data.animal!.vitesseNavire == "")
                                            ? "Non défini"
                                            : "${data.animal!.vitesseNavire} nds"),
                                  ],
                                ),
                               if (data.type == 1)
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
                                        "Espèce (nom scientifique)",
                                        (data.bird!.espece == null ||
                                                data.bird!.espece!
                                                        .scientificName ==
                                                    null ||  data.bird!.espece!
                                                        .scientificName ==
                                                    "")
                                            ? "Non défini"
                                            : data.bird!.espece!
                                                .scientificName ?? "Non défini"),
                                    gridChild(
                                        "Espèce (nom vernaculaire)",
                                        (data.bird!.espece == null ||
                                                data.bird!.espece!
                                                        .commonName ==
                                                    null ||data.bird!.espece!
                                                        .commonName ==
                                                    "")
                                            ? "Non défini"
                                            : data
                                                .bird!.espece!.commonName!),        
                                    gridChild(
                                        "Nombre estimé",
                                        data.bird!.nbreEstime == null
                                            ? "Non défini"
                                            : data.bird!.nbreEstime.toString()),
                                    gridChild(
                                        "Présence de jeunes",
                                         data.bird!.presenceJeune == true
                                                ? "Oui"
                                                : "Non"),
                                    gridChild(
                                      "Etat du groupe",
                                        (data.bird!.etatGroupe == null || data.bird!.etatGroupe == "")
                                            ? "Non défini"
                                            : data.bird!.etatGroupe.toString()),
                                    gridChild(
                                        "Distance estimée",
                                        (data.bird!.distanceEstimee == null || data.bird!.distanceEstimee == "")
                                            ? "Non défini"
                                            : data.bird!.distanceEstimee!),
                                    gridChild( "Comportemment en surface",
                                        (data.bird!.comportement == null ||
                                                data.bird!.comportement == "")
                                            ? "Non défini"
                                            : "${data.bird!.comportement}"),
                                    gridChild(
                                        "Réaction au bateau",
                                        (data.bird!.reactionBateau == null ||
                                                data.bird!.reactionBateau == "")
                                            ? "Non défini"
                                            : "${data.bird!.reactionBateau}"),
                                    gridChild(
                                        "Espèces associés",
                                        (data.bird!.especesAssociees == null ||
                                                data.bird!.especesAssociees!.isEmpty)
                                            ? "Non défini"
                                            : data.bird!.especesAssociees!),
                                               gridChild(
                                        "Activités humaines associées",
                                        (data.bird!.activitesHumainesAssociees ==
                                                    true)
                                                ?   ( data.bird!.activitesHumainesAssocieesPrecision ==  null ||  data.bird!.activitesHumainesAssocieesPrecision ==  '')
                                            ? "Oui, non défini"
                                            : "${data.bird!.activitesHumainesAssocieesPrecision}" : "Pas d'activité",),
                                    gridChild(
                                        "Observation avec effort",
                                        data.bird!.effort == true
                                            ? "Oui"
                                            : "Non"),
                                    gridChild(
                                        "Prise de photos",
                                         data.bird!.photos == true
                                                ? "Oui"
                                                : "Non"),
                                      if(data.bird!.photos == true) gridChild(
                                        "Nom du photographe",
                                         data.photograph == null
                                                ? "Non défini"
                                                : "${data.photograph?.name??""} ${data.photograph?.firstname}"),
                                   gridChild(
                                        "Vitesse du navire",
                                        (data.bird!.vitesseNavire == null ||
                                                data.bird!.vitesseNavire == "")
                                            ? "Non défini"
                                            : "${data.bird!.vitesseNavire} nds"),
                                  ],
                                ),
                              if (data.type == 2)
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
                                        "Nature du déchet",
                                        (data.waste!.matiere == null ||
                                                data.waste!.matiere == "")
                                            ? "Non défini"
                                            : data.waste!.matiere.toString()),
                                    gridChild(
                                        "Taille estimée",
                                        (data.waste!.estimatedSize == null ||
                                                data.waste!.estimatedSize == "")
                                            ? "Non défini"
                                            : data.waste!.estimatedSize.toString()),
                                    gridChild(
                                        "Matière",
                                        (data.waste!.matiere == null)
                                            ? "Non défini"
                                            : data.waste!.natureDeche!.commonName?? "Non défini"),
                                    gridChild(
                                        "Couleur",
                                        (data.waste!.color == null || data.waste!.color == "")
                                            ? "Non défini"
                                            : data.waste!.color.toString()),
                                    gridChild(
                                        "Déchets de la pêche",
                                        data.waste!.dechePeche == true
                                                ? "Oui"
                                                : "Non"),
                                    gridChild(
                                        "Déchets ramassés",
                                      data.waste!.picked == true
                                                ? "Oui"
                                                : "Non"),
                                      gridChild(
                                        "Prise de photos",
                                      data.waste!.photos == true
                                                ? "Oui"
                                                : "Non"),
                                        if(data.waste!.photos == true) gridChild(
                                        "Nom du photographe",
                                         data.photograph == null
                                                ? "Non défini"
                                                : "${data.photograph?.name??""} ${data.photograph?.firstname}"),
                                 gridChild(
                                        "Vitesse du nature",
                                        (data.waste!.vitesseNavire == null ||
                                                data.waste!.vitesseNavire == "")
                                            ? "Non défini"
                                            :' ${data.waste!.vitesseNavire} nds'),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      if(data.type == 0) Padding(
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
                                      text: "Paramètre de la météo",
                                      color: Constants.colorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                             data.animal!.weatherReport != null ?
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
                                      "Etat de la mer- Douglas",
                                      data.animal!.weatherReport == null
                                          ? "Non défini"
                                          : (data.animal!.weatherReport!.seaState !=
                                                      null &&
                                                  data.animal!.weatherReport!
                                                          .seaState!.nom !=
                                                      null  &&
                                                  data.animal!.weatherReport!
                                                          .seaState!.nom !=
                                                      "" )
                                              ? data.animal!.weatherReport!.seaState!.nom
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Couverture nuageuse",
                                      data.animal!.weatherReport == null
                                          ? "Non défini"
                                          : (data.animal!.weatherReport!.cloudCover !=
                                                      null &&
                                                  data.animal!.weatherReport!
                                                          .cloudCover!.nom !=
                                                      null  &&
                                                  data.animal!.weatherReport!
                                                          .cloudCover!.nom !=
                                                      "" )
                                              ? data.animal!.weatherReport!.cloudCover!.nom
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Visiilité",
                                     data.animal!.weatherReport == null
                                          ? "Non défini"
                                          : (data.animal!.weatherReport!.visibility !=
                                                      null &&
                                                  data.animal!.weatherReport!
                                                          .visibility!.nom !=
                                                      null  &&
                                                  data.animal!.weatherReport!
                                                          .visibility!.nom !=
                                                      "" )
                                              ? data.animal!.weatherReport!.visibility!.nom
                                                  .toString()
                                              :  "Non défini"
                                          ),
                                  gridChild(
                                      "Force du vent",
                                      data.animal!.weatherReport == null
                                          ? "Non défini"
                                          : (data.animal!.weatherReport!.windSpeed !=
                                                      null &&
                                                  data.animal!.weatherReport!
                                                          .windSpeed!.description !=
                                                      null  &&
                                                  data.animal!.weatherReport!
                                                          .windSpeed!.description !=
                                                      "" )
                                              ? data.animal!.weatherReport!.windSpeed!.description
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Direction du vent",
                                      data.animal!.weatherReport == null
                                          ? "Non défini"
                                          : (data.animal!.weatherReport!.windDirection !=
                                                      null &&
                                                  data.animal!.weatherReport!
                                                          .windDirection!.nomComplet !=
                                                      '' )
                                              ? data.animal!.weatherReport!.windDirection!.nomComplet
                                                  .toString()
                                              :  "Non défini"
                                              )
                                ],
                              )
                           : const Center(child: CustomText(text: "Non défini"))
                            ],
                          ),
                        ),
                       
                        if(data.type == 1) Padding(
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
                                      text: "Paramètre de la météo",
                                      color: Constants.colorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                             data.bird!.weatherReport != null ?
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
                                      "Etat de la mer- Douglas",
                                      data.bird!.weatherReport == null
                                          ? "Non défini"
                                          : (data.bird!.weatherReport!.seaState !=
                                                      null &&
                                                  data.bird!.weatherReport!
                                                          .seaState!.nom !=
                                                      null  &&
                                                  data.bird!.weatherReport!
                                                          .seaState!.nom !=
                                                      "" )
                                              ? data.bird!.weatherReport!.seaState!.nom
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Couverture nuageuse",
                                      data.bird!.weatherReport == null
                                          ? "Non défini"
                                          : (data.bird!.weatherReport!.cloudCover !=
                                                      null &&
                                                  data.bird!.weatherReport!
                                                          .cloudCover!.nom !=
                                                      null  &&
                                                  data.bird!.weatherReport!
                                                          .cloudCover!.nom !=
                                                      "" )
                                              ? data.bird!.weatherReport!.cloudCover!.nom
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Visiilité",
                                     data.bird!.weatherReport == null
                                          ? "Non défini"
                                          : (data.bird!.weatherReport!.visibility !=
                                                      null &&
                                                  data.bird!.weatherReport!
                                                          .visibility!.nom !=
                                                      null  &&
                                                  data.bird!.weatherReport!
                                                          .visibility!.nom !=
                                                      "" )
                                              ? data.bird!.weatherReport!.visibility!.nom
                                                  .toString()
                                              :  "Non défini"
                                          ),
                                  gridChild(
                                      "Force du vent",
                                      data.bird!.weatherReport == null
                                          ? "Non défini"
                                          : (data.bird!.weatherReport!.windSpeed !=
                                                      null &&
                                                  data.bird!.weatherReport!
                                                          .windSpeed!.description !=
                                                      null  &&
                                                  data.bird!.weatherReport!
                                                          .windSpeed!.description !=
                                                      "" )
                                              ? data.bird!.weatherReport!.windSpeed!.description
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Direction du vent",
                                      data.bird!.weatherReport == null
                                          ? "Non défini"
                                          : (data.bird!.weatherReport!.windDirection !=
                                                      null &&
                                                  data.bird!.weatherReport!
                                                          .windDirection!.nomComplet !=
                                                      '' )
                                              ? data.bird!.weatherReport!.windDirection!.nomComplet
                                                  .toString()
                                              :  "Non défini"
                                              )
                                ],
                              )
                           : const Center(child: CustomText(text: "Non défini"))
                            ],
                          ),
                        ),
                       
                        if(data.type == 2) Padding(
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
                                      text: "Paramètre de la météo",
                                      color: Constants.colorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                             data.waste!.weatherReport != null ?
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
                                      "Etat de la mer- Douglas",
                                      data.waste!.weatherReport == null
                                          ? "Non défini"
                                          : (data.waste!.weatherReport!.seaState !=
                                                      null &&
                                                  data.waste!.weatherReport!
                                                          .seaState!.nom !=
                                                      null  &&
                                                  data.waste!.weatherReport!
                                                          .seaState!.nom !=
                                                      "" )
                                              ? data.waste!.weatherReport!.seaState!.nom
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Couverture nuageuse",
                                      data.waste!.weatherReport == null
                                          ? "Non défini"
                                          : (data.waste!.weatherReport!.cloudCover !=
                                                      null &&
                                                  data.waste!.weatherReport!
                                                          .cloudCover!.nom !=
                                                      null  &&
                                                  data.waste!.weatherReport!
                                                          .cloudCover!.nom !=
                                                      "" )
                                              ? data.waste!.weatherReport!.cloudCover!.nom
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Visiilité",
                                     data.waste!.weatherReport == null
                                          ? "Non défini"
                                          : (data.waste!.weatherReport!.visibility !=
                                                      null &&
                                                  data.waste!.weatherReport!
                                                          .visibility!.nom !=
                                                      null  &&
                                                  data.waste!.weatherReport!
                                                          .visibility!.nom !=
                                                      "" )
                                              ? data.waste!.weatherReport!.visibility!.nom
                                                  .toString()
                                              :  "Non défini"
                                          ),
                                  gridChild(
                                      "Force du vent",
                                      data.waste!.weatherReport == null
                                          ? "Non défini"
                                          : (data.waste!.weatherReport!.windSpeed !=
                                                      null &&
                                                  data.waste!.weatherReport!
                                                          .windSpeed!.description !=
                                                      null  &&
                                                  data.waste!.weatherReport!
                                                          .windSpeed!.description !=
                                                      "" )
                                              ? data.waste!.weatherReport!.windSpeed!.description
                                                  .toString()
                                              :  "Non défini"
                                              ),
                                  gridChild(
                                      "Direction du vent",
                                      data.waste!.weatherReport == null
                                          ? "Non défini"
                                          : (data.waste!.weatherReport!.windDirection !=
                                                      null &&
                                                  data.waste!.weatherReport!
                                                          .windDirection!.nomComplet !=
                                                      '' )
                                              ? data.waste!.weatherReport!.windDirection!.nomComplet
                                                  .toString()
                                              :  "Non défini"
                                              )
                                ],
                              )
                           : const Center(child: CustomText(text: "Non défini"))
                            ],
                          ),
                        ),
                       
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: CustomText(
                                text: "Lieu de l'observation",
                                color: Constants.colorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                         if (data.type == 0)
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
                                      Text(
                                        "Début d'observation",
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                                (data.animal!.locationD == null ||
                                                data.animal!.locationD!.latitude == null ||
                                                        data.animal!.locationD!.latitude!
                                                                .degMinSec == null
                                                                )
                                                    ? "Inconnu"
                                                    : data.animal!.locationD!.latitude!
                                                                .degMinSec
                                                        .toString(),
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
                                                (data.animal!.locationD == null ||
                                                data.animal!.locationD!.longitude == null ||
                                                        data.animal!.locationD!.longitude!
                                                                .degMinSec == null)
                                                    ? "Inconnu"
                                                    : data
                                                        .animal!.locationD!.longitude!
                                                        .degMinSec
                                                        .toString(),
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
                              const SizedBox(
                                width: 5,
                              ),
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
                                      Text(
                                        "Fin d'observation",
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                                (data.animal!.locationF == null ||
                                                data.animal!.locationF!.latitude == null ||
                                                        data.animal!.locationF!.latitude!
                                                                .degMinSec == null)
                                                    ? "Inconnu"
                                                    : data.animal!.locationF!.latitude!.degMinSec
                                                        .toString(),
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
                                                (data.animal!.locationF == null ||
                                                data.animal!.locationF!.longitude == null ||
                                                        data.animal!.locationF!.longitude!
                                                                .degMinSec == null)
                                                    ? "Inconnu"
                                                    : data.animal!.locationF!.longitude!.degMinSec
                                                        .toString(),
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
                           if (data.type == 1)
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
                                      Text(
                                        "Début d'observation",
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                                (data.bird!.locationD == null ||
                                                data.bird!.locationD!.latitude == null ||
                                                        data.bird!.locationD!.latitude!
                                                                .degMinSec == null
                                                                )
                                                    ? "Inconnu"
                                                    : data.bird!.locationD!.latitude!
                                                                .degMinSec
                                                        .toString(),
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
                                                (data.bird!.locationD == null ||
                                                data.bird!.locationD!.longitude == null ||
                                                        data.bird!.locationD!.longitude!
                                                                .degMinSec == null)
                                                    ? "Inconnu"
                                                    : data
                                                        .bird!.locationD!.longitude!
                                                        .degMinSec
                                                        .toString(),
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
                              const SizedBox(
                                width: 5,
                              ),
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
                                      Text(
                                        "Fin d'observation",
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                                (data.bird!.locationF == null ||
                                                data.bird!.locationF!.latitude == null ||
                                                        data.bird!.locationF!.latitude!
                                                                .degMinSec == null)
                                                    ? "Inconnu"
                                                    : data.bird!.locationF!.latitude!.degMinSec
                                                        .toString(),
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
                                                (data.bird!.locationF == null ||
                                                data.bird!.locationF!.longitude == null ||
                                                        data.bird!.locationF!.longitude!
                                                                .degMinSec == null)
                                                    ? "Inconnu"
                                                    : data.bird!.locationF!.longitude!.degMinSec
                                                        .toString(),
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
                       if (data.type == 2)
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
                                                (data.waste!.location == null ||
                                                data.waste!.location!.latitude == null ||
                                                        data.waste!.location!.latitude!
                                                                .degMinSec ==
                                                            null)
                                                    ? "Inconnu"
                                                    : data.waste!.location!.latitude!.degMinSec
                                                        .toString(),
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
                                                (data.waste!.location == null ||
                                                data.waste!.location!.longitude == null ||
                                                        data.waste!.location!.longitude!
                                                                .degMinSec ==
                                                            null)
                                                    ? "Inconnu"
                                                    : data
                                                        .waste!.location!.longitude!.degMinSec
                                                        .toString(),
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
                       
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: CustomText(
                                text: "Autres données",
                                color: Constants.colorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 15, right: 10),
                          child: Column(
                            children: [
                           if (data.type == 0)
                             gridChild2(
                                  "Remarque / Commentaire",
                                  (data.animal!.commentaires == null)
                                      ? "Aucune remarque"
                                      : data.animal!.commentaires.toString()),
                          if (data.type == 1)
                             gridChild2(
                                  "Remarque / Commentaire",
                                  (data.bird!.commentaires == null)
                                      ? "Aucune remarque"
                                      : data.bird!.commentaires.toString()),
                          if (data.type == 2)
                             gridChild2(
                                  "Remarque / remarque",
                                  (data.waste!.commentaires == null)
                                      ? "Aucune remarque"
                                      : data.waste!.commentaires.toString()),
                                      
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
                                          observationController
                                              .deleteObservation(
                                                  widget.observationId);
                                          Get.back();
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
                                    onPressed: () {
                                      Get.to(() => ObservationScreen(
                                                shiping: widget.shipping,
                                                observation: data,
                                              ))!
                                          .then((value) {
                                        setState(() {
                                          observationController.getObservation(
                                              widget.observationId);
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
              )
            ],
          ),
        ));
  }

  Widget gridChild2(String title, String value) {
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
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.delete,
            size: 70,
          ),
          const CustomText(
            text: "Confirmez vous la suppression ?",
            fontSize: 18,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: const CustomText(text: "Non"))),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      child: const CustomText(text: "Oui"))),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
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
