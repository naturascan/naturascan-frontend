import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Utils/timebox.dart';
import 'package:naturascan/Views/pincodeScreen.dart';
import 'package:naturascan/controllers/observationController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/specieModel.dart';

import '../../../Utils/constants.dart';
import '../../../Utils/Widgets/customDropDown.dart';
import '../../../Utils/Widgets/customInputField.dart';
import '../../../Utils/Widgets/customText.dart';

class InfoDechet extends StatefulWidget {
  final bool edit;
  const InfoDechet({super.key, required this.edit});

  @override
  State<InfoDechet> createState() => _InfoDechetState();
}

class _InfoDechetState extends State<InfoDechet> {
  bool loading = true;
  String nature = "";
@override
  void initState() {
    getData();
    if(!widget.edit){
      getPosition();
    }else{
      loading = false;
    }
    super.initState();
  }

 void getData(){
  if(observationController.typeList.contains("Autre")){
   setState(() {
      nature = "Autre";
   });
  }
 }

   void getPosition() async{
  try{
      await Geolocation().determinePosition().then((value) {
      setState(() {
        observationController
            .startLongDegDecController
            .text = value.longitude.toString();
        observationController
                .startLongDegMinSecController.text =
            Utils().convertToDms(value.longitude, false);
        observationController.startLatDegDecController
            .text = value.latitude.toString();
        observationController
                .startLatDegMinSecController.text =
            Utils().convertToDms(value.latitude, true);
            loading = false;
      });
    });
  } catch(e){
    Utils.showToastBlack("Nous n'avons pas pu récupérer votre position actuelle.");
        loading = false;
  }
}
 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Constants.colorPrimary, width: .5)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "1/2",
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        textAlign: TextAlign.center,
                        text: "Début de l'observation",
                        fontSize: 22,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
              const SizedBox(
            height: 50,
          ),

           timeBox(
                context,
                title: "Heure de l'observation",
                controller: observationController.heureDController,
                fontWeight: FontWeight.w700,
                onTap: () {
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                      .then((value) {
                    if (value != null) {
                      DateTime dt = DateTime.now();
                      DateTime dateTime = DateTime(
                          dt.year, dt.month, dt.day, value.hour, value.minute);
                      observationController.heureDController.text =
                          "${dateTime.millisecondsSinceEpoch}";
                      setState(() {});
                    }
                  });
                },
              ),

                const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            text: "Localisation",
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          InkWell(
                            onTap: () {
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
                                      " Ma position actuelle",
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
                                controller: observationController
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
                                controller: observationController
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
                                controller: observationController
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
                                controller: observationController
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
                  text: "Matière",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
               const SizedBox(
                  height: 10,
                ),
                    GridView.builder(
                  itemCount: Constants.typeList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.typeList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.typeList
                            .contains(data)) {
                                 if(data == 'Autre'){
                            nature = "";
                        }
                          observationController.typeList.remove(data);
                        } else {
                            if(data == 'Autre'){
                            nature = data;
                        }
                          observationController.typeList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.typeList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.typeList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            text: data,                           
                            textAlign: TextAlign.center,
                            color: observationController.typeList
                                    .contains(data)
                                ? Colors.white
                                : Colors.grey.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),             
           
            ],
          ),
             if (nature == "Autre")
            autreContainer(observationController.natureController),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Taille estimée en cm",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                controller: observationController.tailleEstmController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
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
                        text: "Type de déchet",
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
                      child: DropdownButtonFormField<SpecieModel>(
                          value: categorySpeciesController.selectedSpecie.value,
                          items: categorySpeciesController
                              .selectedCateory.value.especes!
                              .map<DropdownMenuItem<SpecieModel>>(
                                  (SpecieModel value) {
                            return DropdownMenuItem<SpecieModel>(
                                value: value,
                                child: Text(
                                  value.commonName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(),
                                ));
                          }).toList(),
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: (p0) {
                            categorySpeciesController.selectedSpecie.value =
                                p0!;
                          },
                          decoration: InputDecoration(
                              errorMaxLines: 3,
                              isDense: false,
                              errorStyle: GoogleFonts.nunito(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 16.0, right: 8.0),
                              labelStyle:
                                  GoogleFonts.nunito(color: Colors.black),
                              hintStyle:
                                  GoogleFonts.nunito(color: Colors.black),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: CustomText(
                  text: "Couleur",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
               const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  itemCount: Constants.colorList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2.5,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.colorList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.colorList
                            .contains(data)) {
                          observationController.colorList.remove(data);
                        } else {
                          observationController.colorList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.colorList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.colorList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: data,
                            color: observationController.colorList
                                    .contains(data)
                                ? Colors.white
                                : Colors.grey.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),             
           
              //        CustomDropDownInputField(
              //   value: observationController.colorController.text.isEmpty ? Constants.colorList.first : observationController.colorController.text,
              //   items: Constants.colorList
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           overflow: TextOverflow.ellipsis,
              //           style: const TextStyle(),
              //         ));
              //   }).toList(),
              //   onChanged: (p0) {
              //     setState(() {
              //      observationController.colorController.text =
              //             p0;
              //     });
              //   },
              // ),
           
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => SizedBox(
                height: 35,
                child: CheckboxListTile.adaptive(
                  value: observationController.dechePeche.value,
                  onChanged: (v) {
                    observationController.dechePeche.value = v!;
                  },
                  title: const CustomText(
                    text: "Déchet de la pêche",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Obx(() => SizedBox(
                height: 35,
                child: CheckboxListTile.adaptive(
                  value: observationController.picked.value,
                  onChanged: (v) {
                    observationController.picked.value = v!;
                  },
                  title: const CustomText(
                    text: "Ramassé",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

    Widget autreContainer(TextEditingController controller) {
    return 
    Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 22),
            child: CustomText(
              text: "Préciser",
              fontSize: 18,
              color: Constants.colorPrimary,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          CustomInputField(
            brdColor: Colors.grey.shade400,
            controller: controller,
          ),
        ],
      ),
    );
  }

}
