import 'package:flutter/material.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';

import '../../../models/windDirection.dart';
import '../customDropDown.dart';

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/main.dart';


class WindDirectionSelectWidget extends StatefulWidget {
  final WindDirection? selectedDirection;
  final int? step;
  const WindDirectionSelectWidget(
      {super.key, this.selectedDirection,  this.step});

  @override
  State<WindDirectionSelectWidget> createState() => _WindDirectionSelectWidgetState();
}

class _WindDirectionSelectWidgetState extends State<WindDirectionSelectWidget> {
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
            text: "Direction du Vent",
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
          child: DropdownButtonFormField<WindDirection>(
              value: widget.selectedDirection ?? zoneController.selectedDirection.value,
              items: windDirections
                  .map<DropdownMenuItem<WindDirection>>((WindDirection value) {
                return DropdownMenuItem<WindDirection>(
                    value: value,
                     enabled: value.id == 0 ? false : true,
                  child: value.id == 0 ? 
                     const  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Description",
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    CustomText(
                      text: "Abréviation",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ],
                )
                  :
                   ListTile(
                    title: CustomText(
                      text: value.id == 10 ? "Inconnu" :value.id == 1 ? value.nomDepart??"" : value.nomComplet,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: CustomText(text:"(${value.id == 10 ? "?" : value.id == 1 ? "?"  : value.abreviation})"),
                  )
                  );
                  
            }).toList(),
              selectedItemBuilder: (p0) {
            return windDirections.map((WindDirection value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 CustomText(
                            text: value.id == 10 ? "Inconnu" :value.id == 1 ? value.nomDepart??"" : value.nomComplet,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          // CustomText(text: "(${value.abreviation})")
                ],
              );
            }).toList();
          },
              autovalidateMode: AutovalidateMode.always,
              onChanged: (p0) {
                 PrefManager.putString(Constants.windDirection, jsonEncode(p0));
                setState(() {
                  zoneController.selectedDirection.value = p0!;
                                        if(widget.step != null){
        if(widget.step ==2){
          etapeController.windDirectionA.value = p0;
        }else{
          etapeController.windDirectionD.value = p0;
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
      if(await PrefManager.getString(Constants.windDirection) != ""){
             var dtl = jsonDecode(await PrefManager.getString(Constants.windDirection));
    if(dtl != null && dtl.isNotEmpty){
      var d = WindDirection.fromJson(dtl);
      zoneController.selectedDirection.value = windDirections[d.id ?? 1];
               if(widget.step != null){
                         if(widget.step ==2){
            if(etapeController.windDirectionA.value.id == null){
              etapeController.windDirectionA.value = windDirections[d.id ?? 1];
            }else{
              zoneController.selectedDirection.value = windDirections.firstWhere((element) => element.id == etapeController.windDirectionA.value.id, orElse:()=> windDirections[d.id ?? 1]);
            } 
        }else{
             if(etapeController.windDirectionD.value.id == null){
              etapeController.windDirectionD.value = windDirections[d.id ?? 1];
            }else{
              zoneController.selectedDirection.value = windDirections.firstWhere((element) => element.id == etapeController.windDirectionD.value.id, orElse:()=> windDirections[d.id ?? 1]);
            } 
        }
      }
    }
    setState(() {});
      }
    }
}
