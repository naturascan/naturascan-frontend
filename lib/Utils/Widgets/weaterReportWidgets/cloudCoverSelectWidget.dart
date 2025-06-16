import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/main.dart';
import '../../../models/cloudCover.dart';

class CloudCoverSelectWidget extends StatefulWidget {
  final CloudCover? selectedCloudCover;
  final int? step;
  const CloudCoverSelectWidget({super.key, this.selectedCloudCover, this.step});

  @override
  State<CloudCoverSelectWidget> createState() => _CloudCoverSelectWidgetState();
}

class _CloudCoverSelectWidgetState extends State<CloudCoverSelectWidget> {
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
            text: "Couverture nuageuse",
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
          child: DropdownButtonFormField<CloudCover>(
              value: widget.selectedCloudCover ?? zoneController.selectedCloudCover.value,
              items: cloudCovers
                  .map<DropdownMenuItem<CloudCover>>((CloudCover value) {
                return DropdownMenuItem<CloudCover>(
                    value: value,
                    enabled: value.id == 0 ? false : true,
                    child: value.id == 0
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "Description",
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              CustomText(
                                text: "Valeur/ 10",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: value.nom ?? "",
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                              ),
                              CustomText(
                                text: (value.pourcentageMin == value.pourcentageMax)?
                                '${value.pourcentageMin?.toInt()}' :
                                       "${value.pourcentageMin?.toInt()} - ${value.pourcentageMax?.toInt()}",
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ));
              }).toList(),
              selectedItemBuilder: (p0) {
                return cloudCovers.map((CloudCover value) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: value.nom ?? "",
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),
                     const SizedBox(width: 10,),
                    CustomText(
                                text: (value.pourcentageMin == value.pourcentageMax)?
                                '${value.pourcentageMin?.toInt()}' :
                                       "${value.pourcentageMin?.toInt()} - ${value.pourcentageMax?.toInt()}",
                                fontWeight: FontWeight.w300,
                              ),
                    ],
                  );
                }).toList();
              },
              autovalidateMode: AutovalidateMode.always,
              onChanged: (p0) {
                PrefManager.putString(Constants.cloudCover, jsonEncode(p0));
                setState(() {
                  zoneController.selectedCloudCover.value = p0!;
                      if(widget.step != null){
        if(widget.step ==2){
          etapeController.cloudCoverA.value = p0;
        }else{
          etapeController.cloudCoverD.value = p0;
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

  getData() async {
    if(await PrefManager.getString(Constants.cloudCover) != ''){
          var dtl = jsonDecode(await PrefManager.getString(Constants.cloudCover));
    if(dtl != null && dtl.isNotEmpty){
      var d = CloudCover.fromJson(dtl);
      zoneController.selectedCloudCover.value = cloudCovers[d.id ?? 1];
         if(widget.step != null){
        if(widget.step ==2){
            if(etapeController.cloudCoverA.value.id == null){
              etapeController.cloudCoverA.value = cloudCovers[d.id ?? 1];
            }else{
              zoneController.selectedCloudCover.value = cloudCovers.firstWhere((element) => element.id == etapeController.cloudCoverA.value.id, orElse:()=> cloudCovers[d.id ?? 1]);
            } 
        }else{
             if(etapeController.cloudCoverD.value.id == null){
              etapeController.cloudCoverD.value = cloudCovers[d.id ?? 1];
            }else{
              zoneController.selectedCloudCover.value = cloudCovers.firstWhere((element) => element.id == etapeController.cloudCoverD.value.id, orElse:()=> cloudCovers[d.id ?? 1]);
            } 
        }
      }
    }
       setState(() {
         
       });
  }
    }
}
