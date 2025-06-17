import 'dart:developer';
// import 'dart:ffi';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/controllers/zoneController.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import '../../Utils/constants.dart';
import '../../main.dart';
import '../../models/local/etapeModel.dart';
import 'components/firstPage.dart';
import 'components/secondPage.dart';
import 'components/thirdPage.dart';

class StepScreen extends StatefulWidget {
  final SortieModel shiping;
  final EtapeModel? etape;
  const StepScreen(
      {super.key, required this.shiping, this.etape});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  final PageController _controller = PageController(initialPage: 0);
  @override
  void initState() {
      DateTime time = DateTime.now();
    if(etapeController.heureAController.text.isEmpty){
    etapeController.heureAController.text = time.millisecondsSinceEpoch.toString();
    }
    super.initState();
   
    if (widget.etape != null) {
      etapeController.titleController.text = widget.etape!.pointDePassage!.name!;
      etapeController.descriptionController.text = widget.etape!.description!;
      zoneController.selectedPoint.value = widget.etape!.pointDePassage!;
      if(widget.etape?.departureWeatherReport != null){
      etapeController.cloudCoverD.value =
          widget.etape!.departureWeatherReport!.cloudCover ?? CloudCover();
      etapeController.seaStateD.value =
          widget.etape!.departureWeatherReport!.seaState ?? SeaState();
      etapeController.visibilityD.value =
          widget.etape!.departureWeatherReport!.visibility ?? VisibiliteMer();
      etapeController.windSpeedD.value =
          widget.etape!.departureWeatherReport!.windSpeed ?? WindSpeedBeaufort();
      etapeController.windDirectionD.value =
          widget.etape!.departureWeatherReport!.windDirection ?? WindDirection();
      }
       if(widget.etape?.arrivalWeatherReport != null){
      etapeController.cloudCoverA.value =
          widget.etape!.arrivalWeatherReport!.cloudCover ?? CloudCover();
      etapeController.seaStateA.value =
          widget.etape!.arrivalWeatherReport!.seaState ?? SeaState();
      etapeController.visibilityA.value =
          widget.etape!.arrivalWeatherReport!.visibility ?? VisibiliteMer();
      etapeController.windSpeedA.value =
          widget.etape!.arrivalWeatherReport!.windSpeed ?? WindSpeedBeaufort();
      etapeController.windDirectionA.value =
          widget.etape!.arrivalWeatherReport!.windDirection ?? WindDirection();
       }
      etapeController.heureAController.text = widget.etape!.heureArriveePort.toString();
      etapeController.heureDController.text =  widget.etape!.heureDepartPort.toString();

    }
  }


  int selectPage = 0;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    etapeController.currentShippingID.value = widget.shiping.id!;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Constants.colorPrimary,
        centerTitle: true,
        leading: const AppBarBack(),
        title:  CustomText(
          text: widget.etape != null ? "Modifier une étape" : "Ajouter une étape",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            log(value.toString());
            setState(() {
              selectPage = value;
            });
          },
          children: [
            FirstPage(shiping: widget.shiping),
              const SeconPage(
              step: 2,
        title: "Paramètre d'Arrivée",
            ),
            const SeconPage(step: 3, title: "Paramètre de Départ"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectPage != 0)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        },
                        child: const CustomText(
                          fontWeight: FontWeight.w600,
                          text: "     Précedent",
                          fontSize: 16,
                        )),
                    Positioned(
                      left: -25,
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.colorPrimary),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (selectPage != 2) {
                        //  etapeController.cloudCoverA ??= cloudCovers[zoneController.selectedCloudCover.value.id ?? 1].obs;
                        //  etapeController.seaStateA ??= seaStates[zoneController.selectedSeaState.value.id ?? 1].obs;
                        //     etapeController.visibilityA ??= visibilites2[zoneController.selectedVisibility.value.id! -1].obs;
                        //     etapeController.windDirectionA ??= windDirections[zoneController.selectedDirection.value.id ?? 1].obs;
                        //     etapeController.windSpeedA ??= windSpeedBeauforts[zoneController.selectedWindForce.value.id ?? 1].obs;
                        //       etapeController.cloudCoverD ??= cloudCovers[zoneController.selectedCloudCover.value.id ?? 1].obs;
                        //  etapeController.seaStateD ??= seaStates[zoneController.selectedSeaState.value.id ?? 1].obs;
                        //     etapeController.visibilityD ??= visibilites2[zoneController.selectedVisibility.value.id! -1].obs;
                        //     etapeController.windDirectionD ??= windDirections[zoneController.selectedDirection.value.id ?? 1].obs;
                        //     etapeController.windSpeedD ??= windSpeedBeauforts[zoneController.selectedWindForce.value.id ?? 1].obs;
                          _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        } else {
                          widget.etape == null ? createStep() : updateStep();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              text:
                                  selectPage != 2 ? "Suivant     " : "Valider     "),
                        ],
                      )),
                 Positioned(
                    right: -25,
                    child: InkWell(
                      onTap: () {
                        if (selectPage != 2) {
                          _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        } else {
                          createObservation();
                        }
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.colorPrimary),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  void createStep() async{
   progress = ProgressDialog(context);
    progress.show();
    await 1.delay();
    etapeController.addEtape();
  }
  void updateStep() async{
    progress = ProgressDialog(context);
    progress.show();
    await 1.delay();
    etapeController.updateEtape(widget.etape!.id!);
  }

  void createObservation() {}
}
