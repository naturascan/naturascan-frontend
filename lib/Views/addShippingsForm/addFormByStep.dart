import 'dart:developer';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Views/addShippingsForm/components/addForm3.dart';
import 'package:naturascan/controllers/sortieController.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/cloudCover.dart';
import 'package:naturascan/models/local/naturascanModel.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';
import 'package:naturascan/models/local/zone.dart';
import 'package:naturascan/models/seaState.dart';
import 'package:naturascan/models/visibiliteMer.dart';
import 'package:naturascan/models/windDirection.dart';
import 'package:naturascan/models/windSpeed.dart';
import 'package:uuid/uuid.dart';
import '../../Utils/constants.dart';
import 'components/addForm1.dart';
import 'components/addForm2.dart';

class AddShippingScreen extends StatefulWidget {
  const AddShippingScreen({super.key});

  @override
  State<AddShippingScreen> createState() => _AddShippingScreenState();
}

class _AddShippingScreenState extends State<AddShippingScreen> {
  TextEditingController nbController = TextEditingController();
  TextEditingController remarkController  = TextEditingController();
  TextEditingController remarkController2 = TextEditingController();
  TextEditingController typeBController = TextEditingController();
  TextEditingController nomBController = TextEditingController();
  TextEditingController heureDController = TextEditingController();
  TextEditingController portController = TextEditingController();
  Rx<CloudCover>? cloudCover;
  Rx<VisibiliteMer>? visibility;
  Rx<SeaState>? seaState;
  Rx<WindSpeedBeaufort>? windSpeed;
  Rx<WindDirection>? windDirection;
  TextEditingController hauteurBateauController = TextEditingController();
  TextEditingController selectedZoneId = TextEditingController(text: "${listZone.first.id ?? 1}");
  final PageController _controller = PageController(initialPage: 0);
  List<UserModel> selectedUser = [];
  List<UserModel> responsable = [];
  List<UserModel> skipper = [];
  List<UserModel> photograph = [];
  List<UserModel> otherUser = [];
  bool creating = false;
  int selectPage = 0;

  @override
  void initState() {
   DateTime time = DateTime.now();
  heureDController.text = time.millisecondsSinceEpoch.toString();
   zoneController.fetchZoneList();
   userController.fetchUsers(1);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Constants.colorPrimary,
        centerTitle: true,
        leading: const AppBarBack(),
        title: const CustomText(
          text: "Créer une nouvelle sortie",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            log(value.toString());
            setState(() {
              selectPage = value;
            });
          },
          children: [
            AddForm1(
              edit: false,
              selectedZoneId: selectedZoneId,
              typeBateau: typeBController,
              nomBateau: nomBController,
              portController: portController,
              hauteurBateauController: hauteurBateauController,
              selectedZone: listZone.first,
            ),
            AddForm2(
              title: "Informations sur les participants",
              nbController: nbController,
              selectedUser: selectedUser,
              responsable: responsable,
              skipper: skipper,
              photograph: photograph,
              otherUser: otherUser,
              edit: false,
            ),
            AddForm3(
              heureDController: heureDController,
              remarkController: remarkController,
              title: "Paramètre de Départ",
              cloudCoverr: cloudCover?.value,
              seaState: seaState?.value,
              visibility: visibility?.value,
              windSpeedr: windSpeed?.value,
              windDirection: windDirection?.value,
              edit: false,
              level: 10
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectPage != 0)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        },
                        child: const CustomText(
                          fontWeight: FontWeight.w600,
                          text: "     Précedent",
                          fontSize: 16,
                        )),
                    Positioned(
                      left: -25,
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.colorPrimary),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (selectPage != 2) {
                          _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        } else {
                          createSortie();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              text: selectPage != 2
                                  ? "Suivant     "
                                  : "Valider     "),
                        ],
                      )),
                  Positioned(
                    right: -25,
                    child: InkWell(
                      onTap: () {
                        if (selectPage != 2) {
                          _controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        } else {
                          createSortie();
                        }
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.colorPrimary),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  void createSortie() async{
    seaState = zoneController.selectedSeaState;
    cloudCover = zoneController.selectedCloudCover;
    visibility = zoneController.selectedVisibility;
    windSpeed = zoneController.selectedWindForce;
    windDirection = zoneController.selectedDirection;
    progress = ProgressDialog(context);
    progress.show();
    int dt = int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch;
    WeatherReportModel? dataWeather = WeatherReportModel(
        id: const Uuid().v4(),
       seaState:seaState?.value,
        cloudCover:cloudCover?.value,
        visibility: visibility?.value,
        windForce: windSpeed?.value,
        windDirection: windDirection?.value,
        windSpeed: windSpeed?.value,
        );
    setState(() {});
print('dataweater ${dataWeather.toJson()}');
      SortieModel data = SortieModel(
        date: dt,
        type: "NaturaScan",
        naturascan:
        NaturascanModel(
            zone: zoneController.selectedZone.value,
            portDepart: portController.text.isEmpty ? null : portController.text,
            heureDepartPort: heureDController.text.isEmpty ? DateTime.now().millisecondsSinceEpoch : int.tryParse(heureDController.text) ?? DateTime.now().millisecondsSinceEpoch,
            responsable: responsable.isEmpty ? null : responsable,
            skipper: skipper.isEmpty ? null : skipper,
            photographe: photograph.isEmpty ? null : photograph,
            observateurs: selectedUser.isEmpty ? null : selectedUser,
            otherUser: otherUser.isEmpty ? null : otherUser,
            nbreObservateurs: int.tryParse(nbController.text) ?? 0,
            typeBateau: typeBController.text.isEmpty ? null : typeBController.text,
            nomBateau: nomBController.text.isEmpty ? null : nomBController.text,
            hauteurBateau:hauteurBateauController.text.isEmpty ? null : double.tryParse(hauteurBateauController.text),
            remarqueDepart: remarkController.text.isEmpty ? null : remarkController.text,
            departureExtraComment:  remarkController.text.isEmpty ? null :  remarkController.text,
            departureWeatherReport: dataWeather,
        ),
        );
   Map<String, dynamic> futureJson = await data.toJson();
    SortieController().addSortie(futureJson);
//Get.to(()=> const DetailsExpeditionScreen(idShiiping: 1,));
  }

}
