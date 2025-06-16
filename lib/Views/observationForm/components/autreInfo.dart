import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/photographNameWidget.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/controllers/observationController.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/userModel.dart';

import '../../../Utils/Widgets/weaterReportWidgets/cloudCoverSelectWidget.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/Widgets/customInputField.dart';
import '../../../Utils/Widgets/customText.dart';
import '../../../Utils/Widgets/weaterReportWidgets/seaStateSelectWidget.dart';
import '../../../Utils/timebox.dart';
import '../../../Utils/Widgets/weaterReportWidgets/visibilitySelectWidget.dart';
import '../../../Utils/Widgets/weaterReportWidgets/windBeaufortSelectWidget.dart';
import '../../../Utils/Widgets/weaterReportWidgets/windDirectionSelectWidget.dart';
import '../../../main.dart';

class AutreInfo extends StatefulWidget {
  final bool edit;
  final SortieModel shiping;
  const AutreInfo({
    super.key,
    required this.edit,
    required this.shiping,
  });

  @override
  State<AutreInfo> createState() => _AutreInfoState();
}

class _AutreInfoState extends State<AutreInfo> {
  List<UserModel> photograph = [];
    List<UserModel> lists = [];
    bool loading1 = true, loading2 = true;
    TextEditingController potographeController = TextEditingController();
  @override
  void initState() {
   Future.delayed(Duration.zero, (){
     getData();
   });
    super.initState();
  }

void getPosition2() async{
  try{
      await Geolocation().determinePosition().then((value) {
      setState(() {
       observationController.endLongDegDecController.text =
            value.longitude.toString();
        observationController.endLongDegMinSecController.text =
            Utils().convertToDms(value.longitude, false);
        observationController.endLatDegDecController.text =
            value.latitude.toString();
        observationController.endLatDeglMinSecController.text =
            Utils().convertToDms(value.latitude, true);
            loading2 = false;
      });
    });
  } catch(e){
   Utils.showToastBlack("Nous n'avons pas pu récupérer votre position actuelle.");
      loading2 = false;
  }
}
  
  void getData() {
    if (widget.shiping.naturascan!.photographe != null &&
        widget.shiping.naturascan!.photographe!.isNotEmpty) {
      photograph = widget.shiping.naturascan!.photographe!;
    }
    if (widget.shiping.naturascan!.responsable != null &&
        widget.shiping.naturascan!.responsable!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.responsable!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if (widget.shiping.naturascan!.observateurs != null &&
        widget.shiping.naturascan!.observateurs!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.observateurs!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if (widget.shiping.naturascan!.skipper != null &&
        widget.shiping.naturascan!.skipper!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.skipper!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if (widget.shiping.naturascan!.otherUser != null &&
        widget.shiping.naturascan!.otherUser!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.otherUser!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if(lists.isNotEmpty){
    observationController.photograph.value = photograph.isNotEmpty? photograph.first : lists.first;
    }
    if(!widget.edit){
      getPosition2();
       observationController.heureAController.text =
        DateTime.now().millisecondsSinceEpoch.toString();
     if (observationController.type.value != 2){
      int duree = (int.tryParse(observationController.heureAController.text) ?? DateTime.now().millisecondsSinceEpoch) - (int.tryParse(observationController.heureDController.text) ?? DateTime.now().millisecondsSinceEpoch);
       observationController.dureeController.text = formatSeconds2(duree~/1000);
       }
    }else{
      setState(() {
          loading1 = false;
          loading2 = false;
        });
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Constants.colorPrimary, width: .5)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "2/2",
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        textAlign: TextAlign.center,
                        text: "Fin de l'observation ",
                        fontSize: 22,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (observationController.type.value != 2)
                timeBox(
                  context,
                  title: "Fin de l'observation",
                  fontWeight: FontWeight.w700,
                  controller: observationController.heureAController,
                  onTap: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      if (value != null) {
                        DateTime dt = DateTime.now();
                        DateTime dateTime = DateTime(dt.year, dt.month, dt.day,
                            value.hour, value.minute);
                        observationController.heureAController.text =
                            "${dateTime.millisecondsSinceEpoch}";
                        setState(() {});
                      }
                    });
                  },
                ),
             const SizedBox(
            height: 20,
          ),
            ],
          ),
      
          if (observationController.type.value != 2)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Localisation",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Fin",
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          InkWell(
                            onTap: () {
                            setState(() {
                              loading2 = true;
                            });
                            getPosition2();
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.colorPrimary,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Constants.colorPrimary,
                                      size: 13,
                                    ),
                                    Text(
                                      " Ma position actuelle",
                                      style: TextStyle(
                                          color: Constants.colorPrimary),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                      loading2 ?
                  const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(
                        child: SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 1,),),
                      ),
                  ):
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Lat (degré dec)",
                                ),
                              ),
                              CustomInputField(
                                controller: observationController
                                    .endLatDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Lat (degré min sec)",
                                ),
                              ),
                              CustomInputField(
                                controller: observationController
                                    .endLatDeglMinSecController,
                                hint: "Exp: 48° 51' 41\" N",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Long (degré dec)",
                                ),
                              ),
                              CustomInputField(
                                controller: observationController
                                    .endLongDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Long (degré min sec)",
                                ),
                              ),
                              CustomInputField(
                                controller: observationController
                                    .endLongDegMinSecController,
                                hint: "Exp: 48° 51' 41\" N",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                 const SizedBox(height: 20,),
              ],
            ),
  
              if(observationController.type.value != 2) Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Durée totale de l'observation",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomInputField(
                  controller: observationController.dureeController,
                ),
              ],
            ),

          if (observationController.type.value == 2)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Localisation",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      InkWell(
                        onTap: () {
                          Geolocation().determinePosition().then((value) {
                            setState(() {
                              observationController.startLongDegDecController
                                  .text = value.longitude.toString();
                              observationController.startLongDegMinSecController
                                  .text = Utils().convertToDms(value.longitude, false);
                              observationController.startLatDegDecController
                                  .text = value.latitude.toString();
                              observationController.startLatDegMinSecController
                                  .text = Utils().convertToDms(value.latitude, true);
                            });
                          });
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Constants.colorPrimary, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: Constants.colorPrimary,
                                  size: 13,
                                ),
                                Text(
                                  " Ma position actuelle",
                                  style:
                                      TextStyle(color: Constants.colorPrimary),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Lat",
                                ),
                              ),
                              CustomInputField(
                                controller: observationController
                                    .startLatDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              CustomInputField(
                                controller: observationController
                                    .startLatDegMinSecController,
                                hint: "Exp: 48° 51' 41\" N",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Long",
                                ),
                              ),
                              CustomInputField(
                                controller: observationController
                                    .startLongDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              CustomInputField(
                                controller: observationController
                                    .startLongDegMinSecController,
                                hint: "Exp: 48° 51' 41\" N",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
      
           const SeaStateSelectWidget(),
           const CloudCoverSelectWidget(),
           const VisibilitySelectWidget(),
           const WindBeaufortSelectWidget(),
           const WindDirectionSelectWidget(),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Remarque / Commentaire",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                controller: observationController.remarqueController,
                minLines: 5,
                maxLines: 5,
              ),
            ],
          ),
          Obx(() {
            return Column(
              children: [
                CheckboxListTile.adaptive(
                  value: observationController.desPhotos.value,
                  onChanged: (v) {
                    observationController.desPhotos.value = v!;
                  },
                  title: const Text("Avez-vous pris des photos?"),
                ),
                    if(observationController.desPhotos.value)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Nom de celui qui a pris les photos",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                readOnly: true,
                controller: potographeController,
                label: "Définir le photographe",
                suffix: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Constants.colorPrimary,
                ),
                onTap: () {
                  Get.bottomSheet(PhotographNameWidget(
                    selectedUser: observationController.photograph.value.id != null ? observationController.photograph.value : null,
                    shiping: widget.shiping,
                  )).then((value){
                           print("l'objet est ${value}");
                             if(value != null){
                      potographeController.text = "${observationController.photograph.value.name} ${observationController.photograph.value.firstname}";
                      print("l'objet est ${potographeController.text}");
                    }
                  }
                );
                },
              ),
            ],
          )
      
              ],
            );
          }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
   String formatSeconds2(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    String h = "", m = "", s = "";

    if (formattedHours != "00") {
      h = "$formattedHours h";
    }
    if (formattedMinutes != "00") {
      m = "$formattedMinutes min";
    }
    s = "$formattedSeconds s";
    return '$h$m$s';
  }


}
