import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/Widgets/customInputField.dart';
import '../../../Utils/Widgets/customText.dart';

class FirstPage extends StatefulWidget {
  final SortieModel shiping;
  const FirstPage({super.key, required this.shiping});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: etapeController,
        builder: (etapeControl) {
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
                                  "Veuillez fournir des informations sur l'étape",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 22),
                            child: CustomText(
                              text: "Nom de l'étape",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                   Get.bottomSheet(
                              SelectPassagePointWidget(widget: widget));
                              },
                              icon: const Icon(
                                Icons.add_box,
                                color: Constants.colorPrimary,
                                size: 22,
                              ))
                        ],
                      ),
                    ),
                    Obx(() {
                      return CustomInputField(
                        readOnly: true,
                        hint: zoneController.selectedPoint.value.name ?? "",
                        onTap: () {
                          Get.bottomSheet(
                              SelectPassagePointWidget(widget: widget));
                        },
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class SelectPassagePointWidget extends StatefulWidget {
  const SelectPassagePointWidget({
    super.key,
    required this.widget,
  });

  final FirstPage widget;

  @override
  State<SelectPassagePointWidget> createState() =>
      _SelectPassagePointWidgetState();
}

class _SelectPassagePointWidgetState extends State<SelectPassagePointWidget> {
  String searchValue = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          CustomInputField(
            hint: "Recherche",
            suffix: const Icon(Icons.search),
            onChanged: (p0) {
              setState(() {
                searchValue = p0;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
                  child: ListView(
                  children: zoneController.selectedZone.value.points!
                      .where((element) => element.name!
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()))
                      .map((e) => GestureDetector(
                            onTap: () {
                              zoneController.selectedPoint.value = e;
                              Get.back();
                            },
                            child: Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: e.name!,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                       CustomText(
                                      text: "(${e.description})",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                subtitle: CustomText(
                                    text:
                                        "lat: ${e.latitudeDegMinSec},   long: ${e.longitudeDegMinSec}"),
                              ),
                            ),
                          ))
                      .toList(),
                ))
              
          ],
      ),
    );
  }
}
