import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/patListWidgets.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/refsLisWidgets.dart';
import 'package:naturascan/Utils/Widgets/customDropDown.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/secteur.dart';

class FirstPageObstrace extends StatefulWidget {
  final bool edit;
  const FirstPageObstrace({super.key, required this.edit});

  @override
  State<FirstPageObstrace> createState() => _FirstPageObstraceState();
}

class _FirstPageObstraceState extends State<FirstPageObstrace> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      if(!widget.edit){
      getPosition();
      }else{
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

void getPosition() async{
  try{
      await Geolocation().determinePosition().then((value) {
      setState(() {
        sortieController.startLongDegDecController.text =
            value.longitude.toString();
        sortieController.startLongDegMinSecController.text =
            Utils().convertToDms(value.longitude, false);
        sortieController.startLatDegDecController.text =
            value.latitude.toString();
        sortieController.startLatDegMinSecController.text =
            Utils().convertToDms(value.latitude, true);
            loading = false;
      });
    });
  } catch(e){
   Utils.showToast("Nous n'avons pas pu récupérer votre position actuelle.");
      loading = false;
  }
}
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: sortieController,
        builder: (sortieControl) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          Border.all(color: Colors.grey.shade400, width: .5)),
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
                                  "Veuillez fournir des informations sur la prospection",
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
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    
                     Obx(
                        () => Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 22),
                                  child: CustomText(
                                    text: "Secteur",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                      boxShadow: const []),
                                  child: DropdownButtonFormField<Secteur>(
                                      value: zoneController
                                          .selectedSecteur.value,
                                      items: secteurLists
                                          .map<DropdownMenuItem<Secteur>>(
                                              (Secteur value) {
                                        return DropdownMenuItem<Secteur>(
                                            value: value,
                                            child: Text(
                                              value.name?.toUpperCase() ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(),
                                            ));
                                      }).toList(),
                                      autovalidateMode: AutovalidateMode.always,
                                      onChanged: (p0) {
                                        setState(() {
                                          zoneController
                                              .selectedSecteur.value = secteurLists.firstWhere((element) => element.id == p0?.id);
                                          zoneController
                                              .selectedSousSecteur.value = zoneController.selectedSecteur.value.sousSecteurs!.first;
                                           zoneController
                                              .selectedPlage.value = zoneController.selectedSousSecteur.value.plage!.first;
                                    
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          isDense: false,
                                          errorStyle: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              left: 16.0, right: 8.0),
                                          labelStyle: GoogleFonts.nunito(
                                              color: Colors.black),
                                          hintStyle: GoogleFonts.nunito(
                                              color: Colors.black),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 22),
                                  child: CustomText(
                                    text: "Sous Secteur",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                      boxShadow: const []),
                                  child: DropdownButtonFormField<SousSecteur>(
                                      value: zoneController
                                          .selectedSousSecteur.value,
                                      items: zoneController.selectedSecteur.value.sousSecteurs!
                                          .map<DropdownMenuItem<SousSecteur>>(
                                              (SousSecteur value) {
                                        return DropdownMenuItem<SousSecteur>(
                                            value: value,
                                            child: Text(
                                              value.name ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(),
                                            ));
                                      }).toList(),
                                      autovalidateMode: AutovalidateMode.always,
                                      onChanged: (p0) {
                                        setState(() {
                                          zoneController
                                              .selectedSousSecteur.value = zoneController.selectedSecteur.value.sousSecteurs!.firstWhere((element) => element.id == p0?.id);
                                           zoneController
                                              .selectedPlage.value = zoneController.selectedSousSecteur.value.plage!.first;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          isDense: false,
                                          errorStyle: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              left: 16.0, right: 8.0),
                                          labelStyle: GoogleFonts.nunito(
                                              color: Colors.black),
                                          hintStyle: GoogleFonts.nunito(
                                              color: Colors.black),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 22),
                                  child: CustomText(
                                    text: "Plage",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                      boxShadow: const []),
                                  child: DropdownButtonFormField<Plage>(
                                      value:
                                          zoneController.selectedPlage.value,
                                      items: zoneController
                                          .selectedSousSecteur.value.plage!
                                          .map<DropdownMenuItem<Plage>>(
                                              (Plage value) {
                                        return DropdownMenuItem<Plage>(
                                            value: value,
                                            child: Text(
                                              value.name ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(),
                                            ));
                                      }).toList(),
                                      autovalidateMode: AutovalidateMode.always,
                                      onChanged: (p0) {
                                        setState(() {
                                           zoneController
                                              .selectedPlage.value = zoneController.selectedSousSecteur.value.plage!.firstWhere((element) => element.id == p0?.id);
                                    
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          isDense: false,
                                          errorStyle: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              left: 16.0, right: 8.0),
                                          labelStyle: GoogleFonts.nunito(
                                              color: Colors.black),
                                          hintStyle: GoogleFonts.nunito(
                                              color: Colors.black),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
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
                    text: "Mode de prospection",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomDropDownInputField(
                  value: sortieController.modeController.text.isEmpty ? Constants.mode.first : Constants.mode.firstWhere((element) => element == sortieController.modeController.text, orElse: ()=> Constants.mode.first),
                  items: Constants.mode
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(),
                        ));
                  }).toList(),
                  onChanged: (p0) {
                    sortieController.modeController.text = p0;
                  },
                ),
              ],
            ),
        
                    const SizedBox(
                      height: 10,
                    ),
                    RefsListWidget(selectedUser: sortieController.selectedRefs),
                    const SizedBox(
                      height: 20,
                    ),
                     PatListWidget(selectedUser: sortieController.selectedPat),
                    const SizedBox(
                      height: 20,
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
                            text: "Ma position actuelle",
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                loading = true;     
                              });                             
                              getPosition();
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
                                      " Actualiser",
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
                    loading ?
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
                                readOnly: loading,
                                controller: sortieController
                                    .startLatDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Lat (degré min sec)",
                                ),
                              ),
                              CustomInputField(
                                readOnly: loading,
                                controller: sortieController
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
                                  text: "Long (degré dec)",
                                ),
                              ),
                              CustomInputField(
                                readOnly: loading,
                                controller: sortieController
                                    .startLongDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Long (degré min sec)",
                                ),
                              ),
                              CustomInputField(
                                readOnly: loading,
                                controller: sortieController
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
                 const SizedBox(
                      height: 50,
                    ),

                  ],
                ),
              ],
            ),
          );
        });
  }
}
