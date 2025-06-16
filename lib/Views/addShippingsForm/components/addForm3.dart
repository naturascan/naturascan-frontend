import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/windDirectionSelectWidget.dart';
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
import '../../../Utils/Widgets/customInputField.dart';

class AddForm3 extends StatefulWidget {
  final TextEditingController heureDController;
  final TextEditingController remarkController;
  final CloudCover? cloudCoverr;
  final SeaState? seaState;
  final VisibiliteMer? visibility;
  final WindSpeedBeaufort? windSpeedr;
  final WindDirection? windDirection;
  final TextEditingController? portController;
  final bool edit;
  final String title;
  final int level;
  const AddForm3(
      {super.key,
      required this.heureDController,
      required this.remarkController,
      required this.cloudCoverr,
      required this.seaState,
      required this.visibility,
      required this.windSpeedr,
      required this.windDirection,
      required this.title,
      required this.edit,
      required this.level,
      this.portController});

  @override
  State<AddForm3> createState() => _AddForm3State();
}

class _AddForm3State extends State<AddForm3> {
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
                border: Border.all(color: Constants.colorPrimary, width: .5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!widget.edit)
                  const CustomText(
                    text: "3/3",
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
            title: (widget.level == 4 || widget.level == 5)
                ? "Heure de retour"
                : "Heure de départ",
            controller: widget.heureDController,
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then((value) {
                  if (value != null) {
                        DateTime dt = DateTime.now();
                        DateTime dateTime = DateTime(dt.year, dt.month, dt.day, value.hour, value.minute);
                        widget.heureDController.text =  "${dateTime.millisecondsSinceEpoch}";
                    setState(() {});
                  }
                });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          if (widget.level == 4 || widget.level == 5)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Port de Retour",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomInputField(
                  controller: widget.portController,
                ),
              ],
            ),
          const SizedBox(
            height: 15,
          ),
           SeaStateSelectWidget(
            selectedSeaState:widget.seaState?.id == null ? null : widget.seaState,
          ),
          const SizedBox(
            height: 15,
          ),
           CloudCoverSelectWidget(
            selectedCloudCover: widget.cloudCoverr?.id == null ? null : widget.cloudCoverr,
          ),
          const SizedBox(
            height: 15,
          ),
         VisibilitySelectWidget(
          selectedVisibility: widget.visibility?.id == null ? null : widget.visibility,
          ),
          const SizedBox(
            height: 15,
          ),
          WindBeaufortSelectWidget(
            selectedWindForce: widget.windSpeedr?.id == null ? null : widget.windSpeedr,
          ),
          const SizedBox(
            height: 15,
          ),
           WindDirectionSelectWidget(
            selectedDirection: widget.windDirection?.id == null ? null : widget.windDirection,
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: CustomText(
                  text: (widget.level == 4 || widget.level == 5)
                      ? "Remarques au retour"
                      : "Remarques au départ",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                minLines: 5,
                maxLines: 9,
                controller: widget.remarkController,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
