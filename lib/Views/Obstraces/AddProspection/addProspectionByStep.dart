import 'dart:developer';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Views/Obstraces/AddProspection/components/secondPage.dart';
import 'package:naturascan/controllers/sortieController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/prospectionModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:uuid/uuid.dart';
import 'components/firstPage.dart';

class AddProspectionStep extends StatefulWidget {
  final SortieModel? shiping;
  const AddProspectionStep(
      {super.key, required this.shiping});

  @override
  State<AddProspectionStep> createState() => _AddProspectionStepState();
}

class _AddProspectionStepState extends State<AddProspectionStep> {
  final PageController _controller = PageController(initialPage: 0);
  @override
  void initState() {
    sortieController.heureDebutController.text =  "${DateTime.now().millisecondsSinceEpoch}";
        super.initState();
  }


  int selectPage = 0;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBarBack(),
        title:  CustomText(
          text: widget.shiping != null ? "Modifier une prospection" : "Ajouter une prospection",
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
          children: const [
           FirstPageObstrace(edit: false,),
           SecondPageObstrace(),
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
                     if(selectPage != 1){
                      _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                     }else{
                      createSortie();
                     }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              text:
                                  selectPage != 1 ? "Suivant     " : "Valider     "),
                        ],
                      )),
                 Positioned(
                    right: -25,
                    child: InkWell(
                      onTap: () {
                        if (selectPage != 1) {
                          _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        } else {
                          createSortie();
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

 void createSortie() async{
    sortieController.seaState = zoneController.selectedSeaState;
    sortieController.cloudCover = zoneController.selectedCloudCover;
    sortieController.windSpeed = zoneController.selectedWindForce;
    progress = ProgressDialog(context);
    progress.show();
    int dt = int.tryParse(sortieController.heureDebutController.text) ?? DateTime.now().millisecondsSinceEpoch;
    WeatherReportModel? dataWeather = WeatherReportModel(
        id: const Uuid().v4(),
       seaState:sortieController.seaState?.value,
        cloudCover:sortieController.cloudCover?.value,
        windForce: sortieController.windSpeed?.value,
        windSpeed: sortieController.windSpeed?.value,
        );
    setState(() {});
      SortieModel data = SortieModel(
        date: dt,
        type: "Prospection",
        obstrace: ObstraceModel(
          prospection: ProspectionModel(
            id: const Uuid().v4(),
            secteur: zoneController.selectedSecteur.value,
            sousSecteur: zoneController.selectedSousSecteur.value,
            plage: zoneController.selectedPlage.value,
            mode: sortieController.modeController.text.isEmpty ? null : sortieController.modeController.text,
            end1: (sortieController.startLatDegDecController.text.isEmpty && sortieController.startLatDegMinSecController.text.isEmpty && sortieController.startLongDegDecController.text.isEmpty & sortieController.startLongDegMinSecController.text.isEmpty)? null :
           PositionS(
            latitude: (sortieController.startLatDegDecController.text.isEmpty && sortieController.startLatDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: sortieController.startLatDegDecController.text.isEmpty? null : double.tryParse(sortieController.startLatDegDecController.text) ?? 0,
              degMinSec: sortieController.startLatDegMinSecController.text.isEmpty? null : sortieController.startLatDegMinSecController.text,
            ),
            longitude:  (sortieController.startLongDegDecController.text.isEmpty && sortieController.startLongDegMinSecController.text.isEmpty) ? null : MapPosition(
              degDec: sortieController.startLongDegDecController.text.isEmpty? null : double.tryParse(sortieController.startLongDegDecController.text) ?? 0,
              degMinSec: sortieController.startLongDegMinSecController.text.isEmpty? null : sortieController.startLongDegMinSecController.text,
            ),
          ),
            heureDebut: dt,
            referents: sortieController.selectedRefs.isEmpty ? null : sortieController.selectedRefs,
            patrouilleurs: sortieController.selectedPat.isEmpty ? null : sortieController.selectedPat,
            suivi: sortieController.suivi.value,
            weatherReport: dataWeather,
            remark1: sortieController.remark1Controller.text.isNotEmpty ? sortieController.remark1Controller.text : null
        )
        )
        );  
        Map<String, dynamic> futureJson = await data.toJson();
    SortieController().addSortie(futureJson);
//Get.to(()=> const DetailsExpeditionScreen(idShiiping: 1,));
  }

}
