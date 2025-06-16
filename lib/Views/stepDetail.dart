import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/etapeModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';

import '../Utils/constants.dart';
import 'stedForm/stepScreen.dart';

class StepDetailScreen extends StatefulWidget {
  final SortieModel shiping;
  final String stepID;
  const StepDetailScreen(
      {super.key, required this.shiping, required this.stepID});

  @override
  State<StepDetailScreen> createState() => _StepDetailScreenState();
}

class _StepDetailScreenState extends State<StepDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: etapeController.getEtape(widget.stepID),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                   EtapeModel etape = snapshot.data;
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
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/expedition.jpg")),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(60))),
                                  child: InkWell(
                                    onTap: (){
                                       if(etape.nom == null || etape.nom!.isEmpty){
                                        Get.to(() => StepScreen(
                                              etape: etape,
                                              shiping: widget.shiping))!.then((value) {
                                                setState(() {
                                                etapeController.getEtape(widget.stepID);
                                                });
                                              });
                                       }
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: double.maxFinite,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.7),
                                            borderRadius: const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(60))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 60, left: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: CustomText(
                                              text: (etape.pointDePassage?.name == null || etape.pointDePassage!.name!.isEmpty) ? "Donnez un nom à votre étape" :etape.pointDePassage?.name?? "Etape",
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
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
                                            color:
                                                Colors.black.withOpacity(0.3)),
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    CustomText(
                                          text: "Point de passage",
                                          color: Constants.colorPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        )
                                     ],
                                    ),

                                     (etape.pointDePassage == null || (etape.pointDePassage != null && etape.pointDePassage?.name == null && etape.pointDePassage?.latitudeDegMinSec == null && etape.pointDePassage?.longitudeDegMinSec== null)) ?
                                     const CustomText(text: "Non défini", fontSize: 16, )
                                    
                                     :
                                      Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Nom",
                                                style: GoogleFonts.nunito(
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                              etape.pointDePassage!.name ?? "Point",
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
                                     "Latitude",
                                     style: GoogleFonts.nunito(
                                         decoration: TextDecoration.underline,
                                         fontSize: 16,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   Text(
                                    etape.pointDePassage!.latitudeDegMinSec == null ? 
                                    "Inconnu":
                                   etape.pointDePassage!.latitudeDegMinSec.toString(),
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
                                     "Longitude",
                                     style: GoogleFonts.nunito(
                                         decoration: TextDecoration.underline,
                                         fontSize: 16,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   Text(
                                    etape.pointDePassage!.longitudeDegMinSec == null ? "Inconnu"
                                    :
                                   etape.pointDePassage!.longitudeDegMinSec.toString(),
                                     style: GoogleFonts.nunito(),
                                   ),
                                 ],
                               ),
                      
                                      ],
                                    ),
                                 
                              
                                  const SizedBox(
                                    height: 10,
                                  ),
                               
                                ],
                              ),
                            ),
                           
                           
                             Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: "Paramètre d'arrivée",
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
                                  gridChild("Heure d'arrivée",
                                  etape.heureArriveePort == null ? "Non défini"
                                  :
                                      Utils.formatTime(etape.heureArriveePort?.toInt() ?? 0)),
                                  gridChild("Etat de la mer- Douglas",
                                  etape.arrivalWeatherReport == null ? "Non défini" :
                                      etape.arrivalWeatherReport?.seaState?.nom ?? "Non défini"),
                                  gridChild("Couverture nuageuse",
                                     etape.arrivalWeatherReport == null ? "Non défini" :
                                   etape.arrivalWeatherReport!.cloudCover == null ?  "Non défini"
                                      : "${etape.arrivalWeatherReport!.cloudCover!.nom}"),
                                  gridChild("Visiilité",
                                     etape.arrivalWeatherReport == null ? "Non défini" :
                                      etape.arrivalWeatherReport!.visibility?.nom ?? "Non défini"),
                                  gridChild("Force du vent",
                                     etape.arrivalWeatherReport == null ? "Non défini" :
                                      etape.arrivalWeatherReport!.windForce?.description ?? "Non défini"),
                                  gridChild("Direction du vent",
                                     etape.arrivalWeatherReport == null ? "Non défini" :
                                      etape.arrivalWeatherReport!.windDirection?.nomComplet ?? "Non défini")
                                ],
                              ),
                             
                            
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                           
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: "Paramètre de départ ",
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
                                  gridChild("Heure de départ",
                                      etape.heureDepartPort  == null ? "Non défini"
                                      : Utils.formatTime(etape.heureDepartPort?.toInt() ?? 0)
                                      ),
                                  gridChild("Etat de la mer- Douglas",
                                  etape.departureWeatherReport == null ? "Non défini" :
                                      etape.departureWeatherReport!.seaState?.nom ?? "Non défini"),
                                  gridChild("Couverture nuageuse",
                                     etape.departureWeatherReport == null ? "Non défini" :
                                   etape.departureWeatherReport!.cloudCover == null ?  "Non défini"
                                      : "${etape.departureWeatherReport!.cloudCover?.nom}"),
                                  gridChild("Visiilité",
                                     etape.departureWeatherReport == null ? "Non défini" :
                                      etape.departureWeatherReport!.visibility?.nom ?? "Non défini"),
                                  gridChild("Force du vent",
                                     etape.departureWeatherReport == null ? "Non défini" :
                                      etape.departureWeatherReport!.windForce?.description ?? "Non défini"),
                                  gridChild("Direction du vent",
                                     etape.departureWeatherReport == null ? "Non défini" :
                                      etape.departureWeatherReport!.windDirection?.nomComplet ?? "Non défini")
                                ],
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
                                          etapeController
                                              .deleteEtape(
                                                  widget.stepID);
                                          Get.back();
                                        }
                                      });
                                        
                                        },
                                        child: const CustomText(
                                            text: "Supprimer")),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => StepScreen(
                                              etape: etape,
                                              shiping: widget.shiping))!.then((value) {
                                                setState(() {
                                                etapeController.getEtape(widget.stepID);
                                                });
                                              });
                                        },
                                        child:
                                            const CustomText(text: "Modifier")),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                }else{
                  return  const Center(
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
            border: Border.all(
              color: Colors.grey.shade500,
              width: 0.5
            ),
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
