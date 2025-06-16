import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Views/Obstraces/AddProspection/components/endPage.dart';
import 'package:naturascan/Views/Obstraces/AddProspection/components/firstPage.dart';
import 'package:naturascan/Views/Obstraces/AddProspection/components/secondPage.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/prospectionModel.dart';
import 'package:naturascan/models/local/secteur.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:uuid/uuid.dart';

class EditProspectionScreen extends StatefulWidget {
  final SortieModel shiping;
  final int? level;
  const EditProspectionScreen(
      {super.key, required this.shiping, required this.level});

  @override
  State<EditProspectionScreen> createState() => _EditProspectionScreenState();
}

class _EditProspectionScreenState extends State<EditProspectionScreen> {
  final PageController _controller = PageController(initialPage: 0);
  @override
  void initState() {
    Future.delayed(Duration.zero, (){
     getData();
    });
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
          text: widget.level != 3 ? "Modifier une prospection" : "Finaliser une prospection",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              infosEdit(),
                   const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: InkWell(
                  onTap: () {
                    updateSortie();
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.colorPrimary,
                      ),
                      child: Center(
                        child: Text(
                          widget.level == 4 ? "Finaliser" : "Valider",
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
          )
        ),
  
     ),
    );
  }

   Widget infosEdit() {
    switch (widget.level) {
      case 1:
      //modification de secteur, plage , nbre d'observateurs et observateurs et de position de départ
        return const FirstPageObstrace(edit: true,);
      case 2:
      //modification de la météo de dépat et remarque
        return const SecondPageObstrace();
      case 3:
      // finalisation de l prospection
        return const EndPageObstrace(level: 3, edit: false,);
      case 4:
      // modification de paramètre de fin (heure de fin et position de fin)
        return const EndPageObstrace(level: 4, edit: true,);
      default:
        return Container();
    }
  }

void getData(){
    sortieController.seaState = zoneController.selectedSeaState;
    sortieController.cloudCover = zoneController.selectedCloudCover;
    sortieController.windSpeed = zoneController.selectedWindForce;
    if(widget.shiping.obstrace!.prospection != null){
      ProspectionModel dt = widget.shiping.obstrace!.prospection!;
      sortieController.heureDebutController.text = dt.heureDebut != null ? dt.heureDebut.toString() : '';
      sortieController.heureFinController.text = dt.heureFin != null ? dt.heureFin.toString() : '';
      sortieController.remark1Controller.text = dt.remark1 ?? "";
      sortieController.remark2Controller.text = dt.remark2 ?? "";
      sortieController.modeController.text = dt.mode ?? "";
      if(dt.end1 != null && dt.end1!.longitude != null){
        MapPosition long = dt.end1!.longitude!;
      sortieController.startLongDegMinSecController.text = long.degMinSec ?? "";
      sortieController.startLongDegDecController.text = long.degDec?.toString() ?? "";
      }
       if(dt.end1 != null && dt.end1!.latitude != null){
        MapPosition lat = dt.end1!.latitude!;
      sortieController.startLatDegMinSecController.text = lat.degMinSec ?? "";
      sortieController.startLatDegDecController.text = lat.degDec?.toString() ?? "";
      }
      if(dt.end2 != null && dt.end2!.longitude != null){
        MapPosition long = dt.end1!.longitude!;
      sortieController.endLongDegMinSecController.text = long.degMinSec ?? "";
      sortieController.endLongDegDecController.text = long.degDec?.toString() ?? "";
      }
     if(dt.end2 != null && dt.end2!.latitude != null){
        MapPosition lat = dt.end2!.longitude!;
      sortieController.endLatDeglMinSecController.text = lat.degMinSec ?? "";
      sortieController.endLatDegDecController.text = lat.degDec?.toString() ?? "";
      }
      sortieController.modeController.text = dt.mode?.toString() ?? "0";
      if(dt.secteur != null){
        zoneController.selectedSecteur.value = secteurLists.firstWhere((element) => element.id == dt.secteur?.id, orElse: (()=> secteurLists.first));
      }
       if(dt.sousSecteur != null){
        zoneController.selectedSousSecteur.value = zoneController.selectedSecteur.value.sousSecteurs!.firstWhere((element) => element.id == dt.sousSecteur?.id, orElse: (()=> zoneController.selectedSecteur.value.sousSecteurs!.first));
      }
       if(dt.sousSecteur != null){
        zoneController.selectedPlage.value = zoneController.selectedSousSecteur.value.plage!.firstWhere((element) => element.id == dt.plage?.id, orElse: (()=> zoneController.selectedSousSecteur.value.plage!.first));
      }
      sortieController.selectedPat.value  = [];
      sortieController.selectedRefs.value = [];
      if(dt.patrouilleurs != null && dt.patrouilleurs!.isNotEmpty){
        for (var element in dt.patrouilleurs!) {
           sortieController.selectedPat.add(element!);
        }
      }
     if(dt.referents != null && dt.referents!.isNotEmpty){
        for (var element in dt.referents!) {
           sortieController.selectedRefs.add(element!);
        }
      }
      sortieController.suivi.value = dt.suivi ?? false;
      setState(() {
        
      });
    }

}

 void updateSortie() async{
    progress = ProgressDialog(context);
     progress.show();
    await 0.2.delay();
    int dt = int.tryParse(sortieController.heureDebutController.text) ?? DateTime.now().millisecondsSinceEpoch;
    int dt2 = int.tryParse(sortieController.heureFinController.text) ?? DateTime.now().millisecondsSinceEpoch;
     int? duration;
    if(widget.level == 3){
    DateTime statTime =
        DateTime.fromMillisecondsSinceEpoch(dt);
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(dt2);
    duration = endTime.difference(statTime).inSeconds;
    }
    WeatherReportModel? dataWeather = WeatherReportModel(
        id: const Uuid().v4(),
       seaState:sortieController.seaState?.value,
        cloudCover:sortieController.cloudCover?.value,
        windForce: sortieController.windSpeed?.value,
        windSpeed: sortieController.windSpeed?.value
        );
      print("patttt23 ${sortieController.selectedRefs} ${sortieController.selectedPat}");
    setState(() {});
     final SortieModel data = SortieModel(
        id: widget.shiping.id,
        date: dt,
        type: "Prospection",
        photo: widget.shiping.photo == null ? null : Utils().compressString(base64Encode(File(widget.shiping.photo!).readAsBytesSync())),
        obstrace: ObstraceModel(
          prospection: ProspectionModel(
            id: widget.shiping.obstrace?.prospection?.id,
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
            heureFin: dt2,
            dureeSortie: duration,
            referents: widget.level == 3  ? widget.shiping.obstrace?.prospection?.referents ?? [] :sortieController.selectedRefs.isEmpty ? null : sortieController.selectedRefs,
            patrouilleurs: widget.level == 3  ? widget.shiping.obstrace?.prospection?.patrouilleurs ?? [] : sortieController.selectedPat.isEmpty ? null : sortieController.selectedPat,
            suivi: sortieController.suivi.value,
            weatherReport: dataWeather,
            remark1: sortieController.remark1Controller.text.isNotEmpty ? sortieController.remark1Controller.text : null
        )
        ),
        createdAt: widget.shiping.createdAt,
        finished: widget.level == 3 ? true : widget.shiping.finished,
        );
        await 0.5.delay();
        setState(() {
          
        });
    sortieController.updateSortie(data.id!, data).then((value){
      // Get.back();
        if(widget.level == 3){
       SyncController().sendSortie(data, 21, naturascan: data.naturascan, obstraceModel: data.obstrace);
      } else{
        Get.back();
      }
    });
  }

}
