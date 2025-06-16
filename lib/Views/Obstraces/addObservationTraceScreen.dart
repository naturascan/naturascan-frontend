import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/cloudCoverSelectWidget.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/seaStateSelectWidget.dart';
import 'package:naturascan/Utils/Widgets/weaterReportWidgets/windBeaufortSelectWidget.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Utils/timebox.dart';
import 'package:naturascan/controllers/obstraceController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/secteur.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:uuid/uuid.dart';

class AddObservationTracesScreen extends StatefulWidget {
  final ObservationTrace? trace;
  final SortieModel? sortie;
  const AddObservationTracesScreen(
      {super.key, this.trace, required this.sortie});

  @override
  State<AddObservationTracesScreen> createState() =>
      _AddObservationTracesScreenState();
}

class _AddObservationTracesScreenState
    extends State<AddObservationTracesScreen> {
  final PageController _controller = PageController(initialPage: 0);
  ObstracesController obstracesController = Get.put(ObstracesController());
 bool loading = true;
  String? imageFile;

  @override
  void initState() {
      Future.delayed(Duration.zero, (){
        if(widget.trace == null){
          getPosition();
    if (obstracesController.heureAController.text.isEmpty) {
      obstracesController.heureAController.text =
          "${DateTime.now().millisecondsSinceEpoch}";
    }
        } else{
          setState(() {
          loading = false;
        });
          getData();
        }
    
    } );
    super.initState();
  }

  void getPosition() async{
  try{
      await Geolocation().determinePosition().then((value) {
      setState(() {
        obstracesController.startLongDegDecController.text =
            value.longitude.toString();
        obstracesController.startLongDegMinSecController.text =
            Utils().convertToDms(value.longitude, false);
        obstracesController.startLatDegDecController.text =
            value.latitude.toString();
        obstracesController.startLatDegMinSecController.text =
            Utils().convertToDms(value.latitude, true);
            loading = false;
      });
    });
  } catch(e){
    Utils.showToast("Nous n'avons pas pu récupérer votre position actuelle.");
      loading = false;
  }
}

  int selectPage = 0;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const AppBarBack(),
          title: CustomText(
            text: widget.trace != null
                ? "Modifier une observation de trace"
                : "Ajouter une observation de trace",
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Stack(children: [
                    (widget.trace != null && widget.trace!.photos != null && imageFile == null) ?
                    Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: FileImage(File(widget.trace!.photos!)),
                                    fit: BoxFit.cover)),
                          ) :

                    (imageFile == null)
                        ? Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                openBottomSheetDialog();
                              },
                              child: const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.black54,
                                size: 60,
                              ),
                            ),
                          )
                        : Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: FileImage(File(imageFile!)),
                                    fit: BoxFit.cover)),
                          ),
                     if(imageFile != null || widget.trace == null || widget.trace!.photos != null)
                      Positioned(
                          bottom: 10,
                          right: 10,
                          child: InkWell(
                            onTap: () {
                              openBottomSheetDialog();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                )),
                          ))
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                timeBox(
                  context,
                  title: "Heure",
                  controller: obstracesController.heureAController,
                  onTap: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      if (value != null) {
                        DateTime dt = DateTime.now();
                        DateTime dateTime = DateTime(dt.year, dt.month, dt.day,
                            value.hour, value.minute);
                        obstracesController.heureAController.text =
                            "${dateTime.millisecondsSinceEpoch}";
                        setState(() {});
                      }
                    });
                  },
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
                        text: "Remarques",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomInputField(
                      controller: obstracesController.descriptionController,
                      minLines: 5,
                      maxLines: 5,
                    ),
                  ],
                ),
                if (widget.sortie == null ||  widget.sortie!.obstrace == null  || widget.sortie!.obstrace!.prospection == null)
                  Column(
                    children: [
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
                      
                      SeaStateSelectWidget(
                        selectedSeaState: obstracesController.seaState?.value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CloudCoverSelectWidget(
                        selectedCloudCover:
                            obstracesController.cloudCover?.value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WindBeaufortSelectWidget(
                        selectedWindForce: obstracesController.windSpeed?.value,
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
                  ):Row(
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
                                controller: obstracesController
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
                                controller: obstracesController
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
                                controller: obstracesController
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
                                controller: obstracesController
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
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: InkWell(
                    onTap: () {
                      createSortie();
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constants.colorPrimary,
                        ),
                        child: Center(
                          child: Text(
                            "Valider",
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ])),
        ));
  }

  openBottomSheetDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: Wrap(
            children: [
              ListTile(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 75,
                      requestFullMetadata: false);
                  Get.back();
                  if (image != null) {
                    setState(() {
                      imageFile = image.path;
                    });
                  }
                },
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Prendre une photo avec la caméra'),
              ),
              ListTile(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 75,
                      requestFullMetadata: false);
                  Get.back();
                  if (image != null) {
                    setState(() {
                      imageFile = image.path;
                    });
                  }
                },
                leading: const Icon(Icons.image),
                title: const Text('Prendre une photo dans la galerie'),
              ),
            ],
          ),
        );
      },
    );
  }

  _getFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
      imageQuality: 75,
      requestFullMetadata: false,
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        imageFile = image.path;
      });
    }
  }

  _getFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        requestFullMetadata: false);
    if (image != null) {
      setState(() {
        imageFile = image.path;
      });
    }
  }

   void getData() {
    obstracesController.heureAController.text = widget.trace?.heure?.toString() ?? "";
    obstracesController.descriptionController.text = widget.trace?.remark ?? "";
    if (widget.trace?.weatherReport != null) {
      obstracesController.cloudCover?.value = cloudCovers.firstWhere(
          (element) =>
              element.id == widget.trace?.weatherReport?.cloudCover?.id,
          orElse: (() => zoneController.selectedCloudCover.value));
      obstracesController.seaState?.value = seaStates.firstWhere(
          (element) => element.id == widget.trace?.weatherReport?.seaState?.id,
          orElse: (() => zoneController.selectedSeaState.value));
      obstracesController.windSpeed?.value = windSpeedBeauforts.firstWhere(
          (element) => element.id == widget.trace?.weatherReport?.windSpeed?.id,
          orElse: (() => zoneController.selectedWindForce.value));
          
      if (widget.trace!.location != null &&
          widget.trace!.location!.latitude != null) {
        obstracesController.startLatDegDecController.text =
            widget.trace?.location?.latitude?.degDec?.toString() ?? "";
        obstracesController.startLatDegMinSecController.text =
            widget.trace?.location?.latitude?.degMinSec ?? "";
      }
      if (widget.trace!.location != null &&
          widget.trace!.location!.longitude != null) {
        obstracesController.startLongDegDecController.text =
            widget.trace?.location?.longitude?.degDec?.toString() ?? "";
        obstracesController.startLongDegMinSecController.text =
            widget.trace?.location?.longitude?.degMinSec ?? "";
      }
      if (widget.trace!.secteur != null) {
        zoneController.selectedSecteur.value = secteurLists.firstWhere(
            (element) => element.id == widget.trace!.secteur?.id,
            orElse: (() => secteurLists.first));
      }
      if (widget.trace!.sousSecteur != null) {
        zoneController.selectedSousSecteur.value =
            zoneController.selectedSecteur.value.sousSecteurs!.firstWhere(
                (element) => element.id == widget.trace!.sousSecteur?.id,
                orElse: (() =>
                    zoneController.selectedSecteur.value.sousSecteurs!.first));
      }
      if (widget.trace!.sousSecteur != null) {
        zoneController.selectedPlage.value = zoneController
            .selectedSousSecteur.value.plage!
            .firstWhere((element) => element.id == widget.trace!.plage?.id,
                orElse: (() =>
                    zoneController.selectedSousSecteur.value.plage!.first));
      }
    }
    setState(() {
      
    });
  }


  void createSortie() async {
    obstracesController.seaState = zoneController.selectedSeaState;
    obstracesController.cloudCover = zoneController.selectedCloudCover;
    obstracesController.windSpeed = zoneController.selectedWindForce;
    progress = ProgressDialog(context);
    progress.show();
    await 0.2.delay();
    int dt = int.tryParse(obstracesController.heureAController.text) ??
        DateTime.now().millisecondsSinceEpoch;
    WeatherReportModel? dataWeather = WeatherReportModel(
      id: const Uuid().v4(),
      seaState: obstracesController.seaState?.value,
      cloudCover: obstracesController.cloudCover?.value,
      windForce: obstracesController.windSpeed?.value,
      windSpeed: obstracesController.windSpeed?.value,
    );
    setState(() {});
    ObservationTrace data = ObservationTrace(
      id: widget.trace == null ? const Uuid().v4() : widget.trace!.id!,
      secteur:  (widget.sortie == null || widget.sortie!.obstrace == null || widget.sortie!.obstrace!.prospection == null )
          ? zoneController.selectedSecteur.value
          : widget.sortie!.obstrace!.prospection!.secteur,
      sousSecteur:(widget.sortie == null || widget.sortie!.obstrace == null || widget.sortie!.obstrace!.prospection == null )
          ? zoneController.selectedSousSecteur.value
          : widget.sortie!.obstrace!.prospection!.sousSecteur,
      plage: (widget.sortie == null || widget.sortie!.obstrace == null || widget.sortie!.obstrace!.prospection == null )
          ? zoneController.selectedPlage.value
          : widget.sortie!.obstrace!.prospection!.plage,
      heure: dt,
      weatherReport: (widget.sortie == null || widget.sortie!.obstrace == null || widget.sortie!.obstrace!.prospection == null )
          ? dataWeather
          : widget.sortie!.obstrace!.prospection!.weatherReport,
      remark: obstracesController.descriptionController.text.isEmpty
          ? null
          : obstracesController.descriptionController.text,
      location: (obstracesController.startLatDegDecController.text.isEmpty &&
              obstracesController.startLatDegMinSecController.text.isEmpty &&
              obstracesController.startLongDegDecController.text.isEmpty &
                  obstracesController.startLongDegMinSecController.text.isEmpty)
          ? null
          : PositionS(
              latitude:
                  (obstracesController.startLatDegDecController.text.isEmpty &&
                          obstracesController
                              .startLatDegMinSecController.text.isEmpty)
                      ? null
                      : MapPosition(
                          degDec: obstracesController
                                  .startLatDegDecController.text.isEmpty
                              ? null
                              : double.tryParse(obstracesController
                                      .startLatDegDecController.text) ??
                                  0,
                          degMinSec: obstracesController
                                  .startLatDegMinSecController.text.isEmpty
                              ? null
                              : obstracesController
                                  .startLatDegMinSecController.text,
                        ),
              longitude:
                  (obstracesController.startLongDegDecController.text.isEmpty &&
                          obstracesController
                              .startLongDegMinSecController.text.isEmpty)
                      ? null
                      : MapPosition(
                          degDec: obstracesController
                                  .startLongDegDecController.text.isEmpty
                              ? null
                              : double.tryParse(obstracesController
                                      .startLongDegDecController.text) ??
                                  0,
                          degMinSec: obstracesController
                                  .startLongDegMinSecController.text.isEmpty
                              ? null
                              : obstracesController
                                  .startLongDegMinSecController.text,
                        ),
            ),
      presenceNid: widget.trace?.presenceNid,
      emergence: widget.trace?.emergence,
      esclavation: widget.trace?.esclavation,
      photos: imageFile == null ? (widget.trace == null || widget.trace!.photos == null) ?  null  :  Utils().compressString(base64Encode(File(widget.trace?.photos ?? "").readAsBytesSync())) : Utils().compressString(base64Encode(File(imageFile!).readAsBytesSync())),
      prospectionId: widget.sortie?.obstrace?.prospection?.id,
      shippingId: widget.sortie?.id,
      createdAt: widget.trace?.createdAt
    );
    SortieModel sortie = SortieModel(
        date: dt,
        type: "SuiviTrace",
        photo: imageFile == null ? null :  Utils().compressString(base64Encode(File(imageFile!).readAsBytesSync())),
        );
  if(widget.trace == null){
  if (widget.sortie == null) {
     obstracesController.addObservationTrace(data, true, sortie);
    } else {
      obstracesController.addObservationTrace(data,false, widget.sortie);
    }
  } else{
    obstracesController.updateObservationTrace(widget.trace!.id!, data).then((value) {
      progress = ProgressDialog(context);
      progress.show();
          SyncController().sendSortie(widget.sortie!, 31, obstraceModel: widget.sortie!.obstrace);
    });
  }
  
  }
}
