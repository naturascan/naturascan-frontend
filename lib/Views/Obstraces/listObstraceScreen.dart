import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/res.dart';
import 'package:naturascan/Utils/showInfosDialog.dart';
import 'package:naturascan/Views/Obstraces/addObservationTraceScreen.dart';
import 'package:naturascan/Views/Obstraces/observationTraceDetailsScreen.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/Views/stedForm/stepScreen.dart';
import 'package:naturascan/controllers/obstraceController.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';

class ListObstracesScreen extends StatefulWidget {
  final SortieModel shiping;
  const ListObstracesScreen({super.key, required this.shiping});

  @override
  State<ListObstracesScreen> createState() => _ListObstracesScreenState();
}

class _ListObstracesScreenState extends State<ListObstracesScreen> {
  ObstracesController obstracesController = Get.put(ObstracesController());
  @override
  void initState() {
    obstracesController.fetchObservationsTracesByShippingId(
      limit: 100, offset: 0, shippingId: widget.shiping.id!);
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.colorPrimary,
          centerTitle: true,
          leading: const AppBarBack(),
          title: const CustomText(
            text: "Liste des observations de traces",
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Constants.colorPrimary,
          onPressed: () {
            obstracesController.reset();
            addObstraces();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: GetBuilder(
            init: obstracesController,
            builder: (obsControll) {
              if (obsControll.observationTraceList.isEmpty) {
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
                          "Aucune observation de trace ajoutée.",
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
                              obsControll.reset();
                                addObstraces();
                             
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
                                      'Ajouter une trace',
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
                return 
                GridView.builder(
                         gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.9,
                        ),
                  padding: const EdgeInsets.only(bottom: 50, top: 15, left: 10, right: 10),
                  itemCount: obsControll.observationTraceList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return getItem(obsControll.observationTraceList[index]);
                  },
                );
              }
            }));
  }

   Widget getItem(ObservationTrace item) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: InkWell(
          onTap: () {
            Get.to(()=> ObservationTraceDetails(traceId: item.id!, sortie: widget.shiping,));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              //set border radius more than 50% of height and width to make circle
            ),
            elevation: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
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
                                    image: FileImage(File(item.photos!)))),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 3, right: 3),
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
                            Utils.formatDate1(item.heure?.toInt() ?? 0),
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
                    padding:
                        const EdgeInsets.only(bottom: 3, left: 3, right: 3),
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
                            (item.location?.latitude?.degMinSec == null && item.location?.longitude?.degMinSec == null)?
                            'Non défini' :
                            "lat: ${item.location?.latitude?.degMinSec?? ''},  long: ${item.location?.longitude?.degMinSec?? ''}",
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
  }


void addObstraces(){
    if(widget.shiping.finished == true){
      ShowInfosDialog().show(context, "Cette prospection est déjà finalisée. Vous ne pouvez plus ajouter des observations de traces");
    }else{
         Get.to(() => AddObservationTracesScreen(
              trace: null,
                sortie: widget.shiping,
              ))!.then((value) => obstracesController.fetchObservationsTracesByShippingId(
      limit: 100, offset: 0, shippingId: widget.shiping.id!));
    }
  }
}
