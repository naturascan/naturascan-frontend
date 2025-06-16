import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/cloudCoverSelectWidget.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/seaStateSelectWidget.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/visibilitySelectWidget.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/windBeaufortSelectWidget.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/windDirectionSelectWidget.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Utils/timebox.dart';
import 'package:naturascan/controllers/sortieController.dart';
import 'package:naturascan/main.dart';

class SecondPageObstrace extends StatefulWidget {
  const SecondPageObstrace({super.key});

  @override
  State<SecondPageObstrace> createState() => _SecondPageObstraceState();
}

class _SecondPageObstraceState extends State<SecondPageObstrace> {
  @override
  void initState() {
    takeTime();
    super.initState();
  }

  void takeTime() {


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
                        text: "Paramètre de début",
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
            title: "Heure de début",
            controller: sortieController.heureDebutController,
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((value) {
                if (value != null) {
                      DateTime dt = DateTime.now();
                        DateTime dateTime = DateTime(dt.year, dt.month, dt.day, value.hour, value.minute);
                        sortieController.heureDebutController.text =  "${dateTime.millisecondsSinceEpoch}";
                  setState(() {});
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SeaStateSelectWidget(
            selectedSeaState: sortieController.seaState?.value,
          ),
          const SizedBox(
            height: 10,
          ),
         CloudCoverSelectWidget(
            selectedCloudCover: sortieController.cloudCover?.value,
          ),
          const SizedBox(
            height: 10,
          ),
          WindBeaufortSelectWidget(
            selectedWindForce: sortieController.windSpeed?.value,
          ),
          const SizedBox(
                    height: 10,
                  ),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Remarque au départ",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                controller: sortieController.remark1Controller,
                minLines: 5,
                maxLines: 5,
              ),
            ],
          ),
         
         ],
      ),
    );
  }
}
