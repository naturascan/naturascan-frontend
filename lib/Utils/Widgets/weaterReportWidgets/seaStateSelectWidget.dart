import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/main.dart';

import '../../../models/seaState.dart';
import '../customDropDown.dart';
import '../customText.dart';

class SeaStateSelectWidget extends StatefulWidget {
  final SeaState? selectedSeaState;
  final int? step;
  const SeaStateSelectWidget({super.key, this.selectedSeaState, this.step});

  @override
  State<SeaStateSelectWidget> createState() => _SeaStateSelectWidgetState();
}

class _SeaStateSelectWidgetState extends State<SeaStateSelectWidget> {
@override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22),
          child: CustomText(
            text: "Etat de la mer - Douglas",
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
              boxShadow: const []),
          child: DropdownButtonFormField<SeaState>(
              value: widget.selectedSeaState ?? zoneController.selectedSeaState.value,
              items: seaStates
                  .map<DropdownMenuItem<SeaState>>((SeaState value) {
                return DropdownMenuItem<SeaState>(
                    value: value,
                    enabled: value.id == 0 ? false : true,
                  child: value.id == 0 ? 
                     const  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Etat",
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    CustomText(
                      text: "Hauteur des vagues",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ],
                )
                  :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       CustomText(
                        text: value.nom ?? "",
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),

                      CustomText(
                        text: "${value.houleMin} à ${value.houleMax} m",
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ));
            }).toList(),
              selectedItemBuilder: (p0) {
                return seaStates.map((SeaState value) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                   CustomText(
                        text: value.nom ?? "",
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),
                      CustomText(
                        text:
                            "  ${value.houleMin} à ${value.houleMax} m",
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  );
                }).toList();
              },
              autovalidateMode: AutovalidateMode.always,
              onChanged: (p0) {
                 PrefManager.putString(Constants.seaState, jsonEncode(p0));
                setState(() {
                  zoneController.selectedSeaState.value = p0!;
                     if(widget.step != null){
        if(widget.step ==2){
          etapeController.seaStateA.value = p0;
        }else{
          etapeController.seaStateD.value = p0;
        }
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
                  enabledBorder: InputBorder.none)),
        ),
     
      ],
    );
  }

    getData() async{
      if(await PrefManager.getString(Constants.seaState) != "") {
        var dtl = jsonDecode(await PrefManager.getString(Constants.seaState));
         if(dtl != null && dtl.isNotEmpty ){
          var d = SeaState.fromJson(dtl);
      zoneController.selectedSeaState.value = seaStates[d.id ?? 1];
      if(widget.step != null){
             if(widget.step ==2){
            if(etapeController.seaStateA.value.id == null){
              etapeController.seaStateA.value = seaStates[d.id ?? 1];
            }else{
              zoneController.selectedSeaState.value = seaStates.firstWhere((element) => element.id == etapeController.seaStateA.value.id, orElse:()=> seaStates[d.id ?? 1]);
            } 
        }else{
             if(etapeController.seaStateD.value.id == null){
              etapeController.seaStateD.value = seaStates[d.id ?? 1];
            }else{
              zoneController.selectedSeaState.value = seaStates.firstWhere((element) => element.id == etapeController.seaStateD.value.id, orElse:()=> seaStates[d.id ?? 1]);
            } 
        }
      }
    }
    setState(() {
      
    });
      }
  }
}
