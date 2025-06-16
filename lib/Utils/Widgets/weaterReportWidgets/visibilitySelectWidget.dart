import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/main.dart';
import '../../../models/visibiliteMer.dart';
import '../customText.dart';

class VisibilitySelectWidget extends StatefulWidget {
  final VisibiliteMer? selectedVisibility;
  final int? step;
  const VisibilitySelectWidget({
    super.key,
    this.selectedVisibility,
    this.step
  });

  @override
  State<VisibilitySelectWidget> createState() => _VisibilitySelectWidgetState();
}

class _VisibilitySelectWidgetState extends State<VisibilitySelectWidget> {
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
            text: "Visibilité",
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
          child: DropdownButtonFormField<VisibiliteMer>(
              value: widget.selectedVisibility ?? zoneController.selectedVisibility.value,
              items: visibilites2
                  .map<DropdownMenuItem<VisibiliteMer>>((VisibiliteMer value) {
                return DropdownMenuItem<VisibiliteMer>(
                    value: value,
                     child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value.nom ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(),
                      ),
                  
                    ],
                  ));
            }).toList(),
            selectedItemBuilder: (p0) {
            return visibilites2.map((VisibiliteMer value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value.nom ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              );
            }).toList();
          },
              autovalidateMode: AutovalidateMode.always,
              onChanged: (p0) {
                 PrefManager.putString(Constants.visibility, jsonEncode(p0));
                setState(() {
                  zoneController.selectedVisibility.value = p0!;
                                 if(widget.step != null){
        if(widget.step ==2){
          etapeController.visibilityA.value = p0;
        }else{
          etapeController.visibilityD.value = p0;
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
    if(await PrefManager.getString(Constants.visibility) != ''){
        var dtl = jsonDecode(await PrefManager.getString(Constants.visibility));
    if(dtl != null && dtl.isNotEmpty){
      var d = VisibiliteMer.fromJson(dtl);
      zoneController.selectedVisibility.value = visibilites2[d.id! - 1];
        if(widget.step != null){
                    if(widget.step ==2){
            if(etapeController.visibilityA.value.id == null){
              etapeController.visibilityA.value = visibilites2[d.id! - 1];
            }else{
              zoneController.selectedVisibility.value = visibilites2.firstWhere((element) => element.id == etapeController.visibilityA.value.id, orElse:()=> visibilites2[d.id! - 1]);
            } 
        }else{
             if(etapeController.visibilityD.value.id == null){
              etapeController.visibilityD.value = visibilites2[d.id! - 1];
            }else{
              zoneController.selectedVisibility.value = visibilites2.firstWhere((element) => element.id == etapeController.visibilityD.value.id, orElse:()=> visibilites2[d.id! - 1]);
            } 
        }
      }
    }
    setState(() {});
    }

  }
  }

