import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/windDirectionSelectWidget.dart';
import 'package:naturascan/controllers/etapeController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';

import '../../../Utils/Widgets/weaterReportWidgets/cloudCoverSelectWidget.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/Widgets/customText.dart';
import '../../../Utils/Widgets/weaterReportWidgets/seaStateSelectWidget.dart';
import '../../../Utils/timebox.dart';
import '../../../Utils/Widgets/weaterReportWidgets/visibilitySelectWidget.dart';
import '../../../Utils/Widgets/weaterReportWidgets/windBeaufortSelectWidget.dart';

class SeconPage extends StatefulWidget {
  final String title;
  final int step;
  const SeconPage({super.key, required this.title, required this.step});

  @override
  State<SeconPage> createState() => _SeconPageState();
}

class _SeconPageState extends State<SeconPage> {
  @override
  void initState() {
    takeTime();
    super.initState();
  }

  void takeTime() {
    if(widget.step  == 2){
    //   if (etapeController.cloudCoverA != null) {
    //     zoneController.selectedCloudCover.value = etapeController.cloudCoverA!.value;
    //   }else{
    //     etapeController.cloudCoverA = CloudCover().obs;
    //     etapeController.cloudCoverA!.value  =zoneController.selectedCloudCover.value;
    //   }
    //   if (etapeController.seaStateA != null) {
    //     zoneController.selectedSeaState.value = etapeController.seaStateA!.value;
    //   }else{
    //     etapeController.seaStateA = SeaState().obs;
    //     etapeController.seaStateA!.value  =zoneController.selectedSeaState.value;
    //   }
    //     if (etapeController.visibilityA != null) {
    //     zoneController.selectedVisibility.value = etapeController.visibilityA!.value;
    //   }else{
    //     etapeController.visibilityA = VisibiliteMer().obs;
    //     etapeController.visibilityA!.value  =zoneController.selectedVisibility.value;
    //   }
    //     if (etapeController.windDirectionA != null) {
    //     zoneController.selectedDirection.value = etapeController.windDirectionA!.value;
    //   }else{
    //     etapeController.windDirectionA = WindDirection().obs;
    //     etapeController.windDirectionA!.value  =zoneController.selectedDirection.value;
    //   }
    //     if (etapeController.windSpeedA != null) {
    //     zoneController.selectedWindForce.value = etapeController.windSpeedA!.value;
    //   }else{
    //     etapeController.windSpeedA = WindSpeedBeaufort().obs;
    //     etapeController.windSpeedA!.value  =zoneController.selectedWindForce.value;
    //   }
    // }else{
    //    if (etapeController.cloudCoverD != null) {
    //     zoneController.selectedCloudCover.value = etapeController.cloudCoverD!.value;
    //   }else{
    //     etapeController.cloudCoverD = CloudCover().obs;
    //     etapeController.cloudCoverD!.value  =zoneController.selectedCloudCover.value;
    //   }
    //   if (etapeController.seaStateD != null) {
    //     zoneController.selectedSeaState.value = etapeController.seaStateD!.value;
    //   }else{
    //     etapeController.seaStateD = SeaState().obs;
    //     etapeController.seaStateD!.value  =zoneController.selectedSeaState.value;
    //   }
    //     if (etapeController.visibilityD != null) {
    //     zoneController.selectedVisibility.value = etapeController.visibilityD!.value;
    //   }else{
    //     etapeController.visibilityD = VisibiliteMer().obs;
    //     etapeController.visibilityD!.value  =zoneController.selectedVisibility.value;
    //   }
    //     if (etapeController.windDirectionD != null) {
    //     zoneController.selectedDirection.value = etapeController.windDirectionD!.value;
    //   }else{
    //     etapeController.windDirectionD = WindDirection().obs;
    //     etapeController.windDirectionD!.value  =zoneController.selectedDirection.value;
    //   }
    //     if (etapeController.windSpeedD != null) {
    //     zoneController.selectedWindForce.value = etapeController.windSpeedD!.value;
    //   }else{
    //     etapeController.windSpeedD = WindSpeedBeaufort().obs;
    //     etapeController.windSpeedD!.value  =zoneController.selectedWindForce.value;
    //   }

    }
  //  ??= zoneController.selectedCloudCover;
  // etapeController.seaStateA ??= zoneController.selectedSeaState;
  //   etapeController.visibilityA ??= zoneController.selectedVisibility;
  //   etapeController.windDirectionA ??= zoneController.selectedDirection;
  //   etapeController.windSpeedA ??= windSpeedBeauforts[zoneController.selectedWindForce.value.id ?? 1].obs;
  //   }else{
  //     etapeController.cloudCoverD ??= cloudCovers[zoneController.selectedCloudCover.value.id ?? 1].obs;
  // etapeController.seaStateD ??= seaStates[zoneController.selectedSeaState.value.id ?? 1].obs;
  //   etapeController.visibilityD ??= visibilites2[zoneController.selectedVisibility.value.id! -1].obs;
  //   etapeController.windDirectionD ??= windDirections[zoneController.selectedDirection.value.id ?? 1].obs;
  //   etapeController.windSpeedD ??= windSpeedBeauforts[zoneController.selectedWindForce.value.id ?? 1].obs; 
  //   }
     
    // zoneController.selectedSeaState.value =
    // (widget.step == 3
    //             ? etapeController.seaStateD?.value
    //             : etapeController.seaStateA?.value)!; 
    // zoneController.selectedCloudCover.value =
    // (widget.step == 3
    //             ? etapeController.cloudCoverD?.value
    //             : etapeController.cloudCoverA?.value)!; 
    // zoneController.selectedVisibility.value =
    // (widget.step == 3
    //             ? etapeController.visibilityD?.value
    //             : etapeController.visibilityA?.value)!; 
    // zoneController.selectedWindForce.value =
    // (widget.step == 3
    //             ? etapeController.windSpeedD?.value
    //             : etapeController.windSpeedA?.value)!; 
    // zoneController.selectedDirection.value =
    // (widget.step == 3
    //             ? etapeController.windDirectionA?.value
    //             : etapeController.windDirectionA?.value)!; 

    DateTime time = DateTime.now();
    if(widget.step == 2){
  
    } else{
      etapeController.heureDController.text = Utils.formatTime(time.millisecondsSinceEpoch);
    }


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
                border: Border.all(color: Colors.grey.shade400, width: .5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "${widget.step}/3",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        textAlign: TextAlign.center,
                        text: widget.title,
                        fontSize: 22,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          timeBox(
            context,
            title: "Heure",
            controller: widget.step == 2 ? etapeController.heureAController : etapeController.heureDController,
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((value) {
                if (value != null) {
                  if(widget.step == 2){
                       DateTime dt = DateTime.now();
                        DateTime dateTime = DateTime(dt.year, dt.month, dt.day, value.hour, value.minute);
                        etapeController.heureAController.text =  "${dateTime.millisecondsSinceEpoch}";
                  }else{
                      DateTime dt = DateTime.now();
                        DateTime dateTime = DateTime(dt.year, dt.month, dt.day, value.hour, value.minute);
                        etapeController.heureDController.text =  "${dateTime.millisecondsSinceEpoch}";
                  }
                  
                  setState(() {});
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          //    SeaStateSelectWidget(
          //       selectedSeaState: widget.step == 2 ? etapeController.seaStateA?.value : etapeController.seaStateD?.value,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // CloudCoverSelectWidget(
          //       selectedCloudCover: widget.step == 2 ? etapeController.cloudCoverA?.value : etapeController.cloudCoverD?.value,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // VisibilitySelectWidget(
          //       selectedVisibility: widget.step == 2 ? etapeController.visibilityA?.value : etapeController.visibilityD?.value,
          //   ),
          // const SizedBox(
          //   height: 10,
          // ),
          // WindBeaufortSelectWidget(
          //       selectedWindForce: widget.step == 2 ? etapeController.windSpeedA?.value : etapeController.windSpeedD?.value,
    
          // ),
             SeaStateSelectWidget(
              step: widget.step,
          ),
          const SizedBox(
            height: 10,
          ),
           CloudCoverSelectWidget(
              step: widget.step,
          ),
          const SizedBox(
            height: 10,
          ),
           VisibilitySelectWidget(
              step: widget.step,
            ),
          const SizedBox(
            height: 10,
          ),
          WindBeaufortSelectWidget(
              step: widget.step,
          ),
          const SizedBox(
            height: 10,
          ),
          WindDirectionSelectWidget(
              step: widget.step,
          ),
        

        //   SeaStateSelectWidget(
        //     selectedSeaState: widget.step == 3
        //         ? etapeController.seaStateD?.value
        //         : etapeController.seaStateA?.value,
        //   ),
        //   const SizedBox(
        //     height: 10,
        //   ),
        //   CloudCoverSelectWidget(
        //     selectedCloudCover: widget.step == 3
        //         ? etapeController.cloudCoverD?.value
        //         : etapeController.cloudCoverA?.value,
        //   ),
        //   const SizedBox(
        //     height: 10,
        //   ),
        //   VisibilitySelectWidget(
        //       selectedVisibility: widget.step == 3
        //           ? etapeController.visibilityD?.value
        //           : etapeController.visibilityA?.value),
        //   const SizedBox(
        //     height: 10,
        //   ),
        //   WindBeaufortSelectWidget(
        //     selectedWindForce: widget.step == 3
        //         ? etapeController.windSpeedD?.value
        //         : etapeController.windSpeedA?.value,
        //   ),
        //   const SizedBox(
        //     height: 10,
        //   ),
        //   WindDirectionSelectWidget(
        //     selectedDirection: widget.step == 3
        //         ? etapeController.windDirectionD?.value
        //         : etapeController.windDirectionA?.value,
        //   ),
         ],
      ),
    );
  }
}
