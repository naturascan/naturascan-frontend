import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/zone.dart';
import '../../../../Utils/constants.dart';
import '../../../Utils/Widgets/customInputField.dart';
import '../../../Utils/Widgets/customText.dart';

class AddForm1 extends StatefulWidget {
  const AddForm1(
      {super.key,
      required this.selectedZoneId,
      required this.typeBateau,
      required this.nomBateau,
      required this.portController,
      required this.hauteurBateauController,
      required this.edit,
      required this.selectedZone});

  final TextEditingController selectedZoneId;
  final TextEditingController typeBateau;
  final TextEditingController nomBateau;
  final TextEditingController portController;
  final TextEditingController hauteurBateauController;
  final ZoneModel selectedZone;
  final bool edit;

  @override
  State<AddForm1> createState() => _AddForm1State();
}

class _AddForm1State extends State<AddForm1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.edit)
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Constants.colorPrimary, width: .5)),
                  child: const Column(
                    children: [
                      CustomText(
                        text: "1/3",
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Align(
                            alignment: Alignment.center,
                            child: CustomText(
                              textAlign: TextAlign.center,
                              text:
                                  "Veuillez fournir quelques informations sur la nouvelle sortie",
                              fontSize: 22,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 50,
          ),
      
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Zone attribuée",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
     Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
          boxShadow: const [
          ]),
      child: DropdownButtonFormField<ZoneModel>(
        value: listZone.first ,
        items: listZone.map<DropdownMenuItem<ZoneModel>>((ZoneModel value) {
                  return DropdownMenuItem<ZoneModel>(
                      value: value,
                      child: Text(
                        value.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(),
                      ));
                }).toList(),
        autovalidateMode:  AutovalidateMode.always,
        onChanged:  (p0) {
                   setState(() {
                    zoneController.selectedZone.value = p0!;
                    if(p0.points != null && p0.points!.isNotEmpty){
                      zoneController.selectedPoint.value = p0.points!.first;
                    }
                  });
                  },
        decoration: InputDecoration(
            errorMaxLines: 3,
            isDense: false,
            errorStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
            labelStyle: GoogleFonts.nunito(color: Colors.black),
            hintStyle: GoogleFonts.nunito(color: Colors.black),
            border: InputBorder.none,
            enabledBorder: InputBorder.none
            )
      ),
    ),
            ],
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
                  text: "Port de départ",
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
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Type du bateau",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                controller: widget.typeBateau,
              ),
            ],
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
                  text: "Nom du bateau",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                controller: widget.nomBateau,
              ),
            ],
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
                  text: "Hauteur de pont (en m)",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                hint: "exp: 10.3",
                keyboardType: TextInputType.number,
                controller: widget.hauteurBateauController,
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
