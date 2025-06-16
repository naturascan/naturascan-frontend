import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/main.dart';

import '../../../models/windSpeed.dart';
import '../customDropDown.dart';
import '../customText.dart';

class WindBeaufortSelectWidget extends StatefulWidget {
  final WindSpeedBeaufort? selectedWindForce;
  final int? step;
  const WindBeaufortSelectWidget({
    super.key,
    this.selectedWindForce,
    this.step
  });

  @override
  State<WindBeaufortSelectWidget> createState() => _WindBeaufortSelectWidgetState();
}

class _WindBeaufortSelectWidgetState extends State<WindBeaufortSelectWidget> {
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
            text: "Force du Vent (Beaufort)",
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
          child: DropdownButtonFormField<WindSpeedBeaufort>(
              value: widget.selectedWindForce ?? zoneController.selectedWindForce.value,
              items: windSpeedBeauforts
                  .map<DropdownMenuItem<WindSpeedBeaufort>>((WindSpeedBeaufort value) {
                return DropdownMenuItem<WindSpeedBeaufort>(
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
                      text: "Vitesse en nds",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ],
                )
                  :
                   ListTile(
                    title: CustomText(
                      text: value.description ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: CustomText(
                      text: value.waveEffect ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: CustomText(
                        text: "${value.minSpeed}-${value.maxSpeed}"),
                  )
                  );
                  
            }).toList(),
             selectedItemBuilder: (p0) {
            return windSpeedBeauforts.map((WindSpeedBeaufort value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                            text: value.description ??"",
                            overflow: TextOverflow.ellipsis,
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          // CustomText(
                          //     text: "(${value.minSpeed} - ${value.maxSpeed})")
                ],
              );
            }).toList();
          },
              autovalidateMode: AutovalidateMode.always,
              onChanged: (p0) {
                 PrefManager.putString(Constants.windForce, jsonEncode(p0));
                setState(() {
                  zoneController.selectedWindForce.value = p0!;  
               if(widget.step != null){
        if(widget.step ==2){
          etapeController.windSpeedA.value = p0;
        }else{
          etapeController.windSpeedD.value = p0;
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
    if(await PrefManager.getString(Constants.windForce) != ""){
     var dtl = jsonDecode(await PrefManager.getString(Constants.windForce));
    if(dtl != null && dtl.isNotEmpty){
      var d = WindSpeedBeaufort.fromJson(dtl);
      zoneController.selectedWindForce.value = windSpeedBeauforts[d.id?? 1];
          if(widget.step != null){
         if(widget.step ==2){
            if(etapeController.windSpeedA.value.id == null){
              etapeController.windSpeedA.value = windSpeedBeauforts[d.id ?? 1];
            }else{
              zoneController.selectedWindForce.value = windSpeedBeauforts.firstWhere((element) => element.id == etapeController.windSpeedA.value.id, orElse:()=> windSpeedBeauforts[d.id ?? 1]);
            } 
        }else{
             if(etapeController.windSpeedD.value.id == null){
              etapeController.windSpeedD.value = windSpeedBeauforts[d.id ?? 1];
            }else{
              zoneController.selectedWindForce.value = windSpeedBeauforts.firstWhere((element) => element.id == etapeController.windSpeedD.value.id, orElse:()=> windSpeedBeauforts[d.id ?? 1]);
            } 
        }
      }
    }
    setState(() {});
    }
  }
  
}
