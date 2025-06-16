import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Utils/timebox.dart';
import 'package:naturascan/main.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/Widgets/customDropDown.dart';
import '../../../Utils/Widgets/customInputField.dart';
import '../../../Utils/Widgets/customText.dart';
import '../../../models/comportement.dart';
import '../../../models/local/specieModel.dart';

class InfoEspeceMarine extends StatefulWidget {
  final bool edit;
  const InfoEspeceMarine({
    super.key,
    required this.edit
  });

  @override
  State<InfoEspeceMarine> createState() => _InfoEspeceMarineState();
}

class _InfoEspeceMarineState extends State<InfoEspeceMarine> {
  String structure = "",
      comport = "",
      vitesse = "",
      reaction = "",
      distance = "",
      element = "";
       bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      getData();
      if(!widget.edit){
      getPosition();
      }else{
        loading = false;
      }
    });
    super.initState();
  }

 void getData(){
  if(observationController.groupState.contains("Autre")){
   setState(() {
      structure = "Autre";
   });
  }
 if(observationController.comportementList.contains(comportementList.last)){
   setState(() {
      comport = "Autre";
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
                        text:  "Début de l'observation",
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
                title: "Début de l'observation",
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
                 const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Localisation",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                  ),
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
                            text: "Début",
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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
                                  text: "Espèce",
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
                                child: DropdownButtonFormField<SpecieModel>(
                                    value: categorySpeciesController
                                        .selectedSpecie.value,
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
                                      setState(() {
                                        categorySpeciesController
                                            .selectedSpecie.value = p0!;
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: CustomText(
                                            text: "Nom vernaculaire",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                            height: 50,
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey.shade200,
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                text: categorySpeciesController
                                                        .selectedSpecie
                                                        .value
                                                        .commonName ??
                                                    "",
                                                color: Colors.black54,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: CustomText(
                                            text: "Nom scientifique",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                            height: 50,
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey.shade200,
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                text: categorySpeciesController
                                                        .selectedSpecie
                                                        .value
                                                        .scientificName ??
                                                    '',
                                                color: Colors.black54,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
         
          if (observationController.type.value == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Taille en ${categorySpeciesController.selectedCateory.value.id == 11 ? "m" : "cm"}",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomInputField(
                  controller: observationController.tailleController,
                  keyboardType: TextInputType.number,
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
                  text: "Nombre estimé",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                keyboardType: TextInputType.number,
                controller: observationController.nbreEstimeController,
              ),
              if (observationController.type.value == 0)
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        hint: "Min",
                        controller: observationController.minController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: CustomInputField(
                        hint: "Max",
                        controller: observationController.maxController,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
            ],
          ),
          if (observationController.type.value == 0)
            const SizedBox(
              height: 20,
            ),
          if (observationController.type.value != 0)
            Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile.adaptive(
                    value: observationController.jeunes.value,
                    onChanged: (v) {
                      observationController.jeunes.value = v!;
                    },
                    title: const Text("Présence de jeunes"),
                  ),
                ],
              );
            }),
          if (observationController.type.value == 0)
               Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile.adaptive(
                    value: observationController.jeunesO.value,
                    onChanged: (v) {
                      observationController.jeunesO.value = v!;
                    },
                    title: const Text("Présence de jeunes"),
                  ),
                ],
              );
            }),
         
          if (observationController.type.value == 0)
            const SizedBox(
              height: 10,
            ),
          if (observationController.type.value == 0)
              Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile.adaptive(
                    value: observationController.nnO.value,
                    onChanged: (v) {
                      observationController.nnO.value = v!;
                    },
                    title: const Text("Présence de nouveaux nés"),
                  ),
                ],
              );
            }),
          const SizedBox(
            height: 10,
          ),
          if (observationController.type.value == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Structure du groupe",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                  const SizedBox(
            height: 20,
          ),
                   GridView.builder(
                  itemCount: Constants.structureList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2.5,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.structureList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.groupState
                            .contains(data)) {
                                if(data == 'Autre'){
                            structure = "";
                        }
                          observationController.groupState.remove(data);
                        } else {
                            if(data == 'Autre'){
                            structure = data;
                        }
                          observationController.groupState.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.groupState
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.groupState
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            text: data,                            
                            textAlign: TextAlign.center,
                            color: observationController.groupState
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
          if (observationController.type.value != 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Etat du groupe",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                      GridView.builder(
                  itemCount: Constants.etatList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2.5,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.etatList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.groupState
                            .contains(data)) {
                                if(data == 'Autre'){
                            structure = "";
                        }
                          observationController.groupState.remove(data);
                        } else {
                            if(data == 'Autre'){
                            structure = data;
                        }
                          observationController.groupState.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.groupState
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.groupState
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            text: data,
                            textAlign: TextAlign.center,
                            color: observationController.groupState
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
          if (structure == "Autre")
            autreContainer(observationController.groupStateAController),
          const SizedBox(
            height: 20,
          ),
          if (observationController.type.value == 0)
            Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile.adaptive(
                    value: observationController.sousGroupe.value,
                    onChanged: (v) {
                      observationController.sousGroupe.value = v!;
                    },
                    title: const Text("Sous groupe"),
                  ),
                  if (observationController.sousGroupe.value)
                    Column(
                      children: [
                        CustomInputField(
                          hint: "Nbres",
                          controller:
                              observationController.nbreSousGroupController,
                          keyboardType: TextInputType.number,
                        ),
                        CustomInputField(
                          hint: "Nbres d'individus par sous groupe",
                          controller: observationController
                              .nbreIndivSousGroupeController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    )
                ],
              );
            }),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: CustomText(
                  text: observationController.type.value == 0
                      ? "Comportement en surface"
                      : "Comportement",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (observationController.type.value == 0)
                GridView.builder(
                  itemCount: comportementList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2.5,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ComportementEnSurface data = comportementList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.comportementList
                            .contains(data)) {
                              if(data.nom == "Autre"){
                                comport = '';
                              }
                          observationController.comportementList.remove(data);
                        } else {
                           if(data.nom == "Autre"){
                                comport = data.nom;
                              }
                          observationController.comportementList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: observationController.comportementList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                            color: observationController.comportementList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    :Colors.grey.shade300),
                        child: Center(
                          child: CustomText(
                            text: data.nom,
                            textAlign: TextAlign.center,
                            color: observationController.comportementList
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
              if (observationController.type.value != 0)
                GridView.builder(
                  itemCount: comportementOiseauList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2.5,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ComportementEnSurface data = comportementOiseauList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.comportementList
                            .contains(data)) {
                          observationController.comportementList.remove(data);
                        } else {
                          observationController.comportementList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: observationController.comportementList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                            color:  observationController.comportementList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300),
                        child: Center(
                          child: CustomText(
                            text: data.nom,
                            textAlign: TextAlign.center,
                            color: observationController.comportementList
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
          if (comport == "Autre")
            autreContainer(observationController.comportement),
          const SizedBox(
            height: 20,
          ),
          if (observationController.type.value == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Vitesse de nage",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                 GridView.builder(
                  itemCount: Constants.etatList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2.5,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.vitesseList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.vitesseList
                            .contains(data)) {
                          observationController.vitesseList.remove(data);
                        } else {
                          observationController.vitesseList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.vitesseList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.vitesseList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            text: data,
                            textAlign: TextAlign.center,
                            color: observationController.vitesseList
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
                  text: "Vitesse du navire en nds  ",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                keyboardType: TextInputType.number,
                controller: observationController.bateauVitesseController,
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
                  text: "Réaction au bateau",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
                 GridView.builder(
                  itemCount: Constants.reactionList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.reactionList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.reactionList
                            .contains(data)) {
                          observationController.reactionList.remove(data);
                        } else {
                          observationController.reactionList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.reactionList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.reactionList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            text: data,
                            textAlign: TextAlign.center,
                            color: observationController.reactionList
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
                  text: "Distance estimée",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomDropDownInputField(
                value: observationController.distanceDuBateauController.text.isEmpty ? Constants.distanceList.first : observationController.distanceDuBateauController.text,
                items: Constants.distanceList
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
                  setState(() {
                   observationController.distanceDuBateauController.text =
                          p0;
                  });
                },
              ),
            ],
          ),
        
          const SizedBox(
            height: 20,
          ),
          if (observationController.type.value == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Gisement",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomInputField(
                  controller: observationController.gisementController,
                ),
              ],
            ),
          if (observationController.type.value == 0)
            const SizedBox(
              height: 20,
            ),
          if (observationController.type.value == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: "Elément détection",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                 GridView.builder(
                  itemCount: Constants.detectionList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String data = Constants.detectionList[index];
                    return InkWell(
                      onTap: () {
                        if (observationController.detectionList
                            .contains(data)) {
                          observationController.detectionList.remove(data);
                        } else {
                          observationController.detectionList.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : observationController.detectionList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey.shade300,
                            border: Border.all(
                                color: observationController.detectionList
                                        .contains(data)
                                    ? Constants.colorPrimary
                                    : Colors.grey),
                          ),
                        child: Center(
                          child: CustomText(
                            text: data,
                            textAlign: TextAlign.center,
                            color: observationController.detectionList
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
          
          if (observationController.type.value == 0)
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
                  text: "Espèces associées",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomInputField(
                hint: "",
                controller: observationController.especesAssocieesController,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
              if (observationController.type.value != 2)
                 Obx(() {
                             return Column(
                               children: [
                                 CheckboxListTile.adaptive(
                                   value: observationController.activity.value,
                                   onChanged: (v) {
                                     observationController.activity.value = v!;
                                   },
                                   title: const Text("Activités humaines associées"),
                                 ),
                                if(observationController.activity.value) autreContainer(observationController.activitesHumainesAssociees)

                               ],
                             );
                           }),
              Obx(() {
            return CheckboxListTile.adaptive(
              value: observationController.avecEffort.value,
              onChanged: (v) {
                observationController.avecEffort.value = v!;
              },
              title: const Text("Observation avec effort"),
            );
          }),
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
