import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/dummy-data/user.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/sortieModel.dart';
import 'package:naturascan/models/local/userModel.dart';

import '../../../../../Views/addUserScreen.dart';

class PhotographNameWidget extends StatefulWidget {
  final UserModel? selectedUser;
  final SortieModel shiping;
  const PhotographNameWidget(
      {super.key,  this.selectedUser, required this.shiping});

  @override
  State<PhotographNameWidget> createState() => _PhotographNameWidgetState();
}

class _PhotographNameWidgetState extends State<PhotographNameWidget> {
  String searchValue = "";
  List<UserModel> photograph = [];
  List<UserModel> lists = [];
  List<UserModel> lists2 = [];
  bool more = false;
  bool loading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (widget.shiping.naturascan!.photographe != null &&
        widget.shiping.naturascan!.photographe!.isNotEmpty) {
      photograph = widget.shiping.naturascan!.photographe!;
    }
    if (widget.shiping.naturascan!.responsable != null &&
        widget.shiping.naturascan!.responsable!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.responsable!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if (widget.shiping.naturascan!.observateurs != null &&
        widget.shiping.naturascan!.observateurs!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.observateurs!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if (widget.shiping.naturascan!.skipper != null &&
        widget.shiping.naturascan!.skipper!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.skipper!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
    if (widget.shiping.naturascan!.otherUser != null &&
        widget.shiping.naturascan!.otherUser!.isNotEmpty) {
      for (var element in widget.shiping.naturascan!.otherUser!) {
        if (!lists.contains(element)) {
          lists.add(element);
        }
      }
    }
      setState(() {
      
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
            Column(
              children: [
                if(photograph.isNotEmpty)
                Column(
                  children: [
                    Column(
                      children: [
                        const CustomText(text: 'Photographe(s) de la sortie', color: Constants.colorPrimary,
                        fontSize: 20, fontWeight: FontWeight.bold,),
                     const SizedBox(height: 5,),
                        SizedBox(
                          height: photograph.length * 130,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: photograph.length,
                            itemBuilder: (context, index){
                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: photograph
                                .where((element) => (element.name!
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase()) ||
                                    element.firstname!
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase())))
                                .map((e) => GestureDetector(
                                      onTap: () async {
                                       observationController.photograph.value = e;
                                        Get.back(result: e);
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: CustomText(
                                                    text:
                                                        "${e.name!} ${e.firstname!}"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                            }
                            ),
                        )
                      ],
                    )
                  ],
                ),
               if(photograph.isEmpty && lists.isNotEmpty)
              CustomText(
              textAlign: TextAlign.justify,
              fontSize: 16,
              text: "Vous n'avez pas défini de photographe pour cette sortie.\n Vous pouvez sélectionner le photoraphe parmis les autres participants de la sortie ou cliquer sur le bouton <<Voir plus>> pour charger d'autres éventuels participants.",
              color: Colors.grey.shade600,
              ),
                 if(lists.isNotEmpty)
              Column(
                  children: [
                    Column(
                      children: [
                        const CustomText(text: 'Autres participants de la sortie', color: Constants.colorPrimary,
                        fontSize: 20, fontWeight: FontWeight.bold,),
                       const SizedBox(height: 5,),
                        SizedBox(
                          height: lists.length * 130 ,
                          child: ListView.builder(
                            itemCount: lists.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                            return ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            children: lists
                                .where((element) => (element.name!
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase()) ||
                                    element.firstname!
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase())))
                                .map((e) => GestureDetector(
                                      onTap: () async {
                                       observationController.photograph.value = e;
                                        Get.back(result: e);
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: CustomText(
                                                    text:
                                                        "${e.name!} ${e.firstname!}"),
                                              ),
                                            ),
                                         ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                                               
                            }
                            ),
                        )
                      ],
                    )
                  ],
                )     ,
                  if(photograph.isEmpty && lists.isEmpty)
                  Column(
                    children: [
                      CustomText(
                      textAlign: TextAlign.justify,
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      text: "Vous n'avez pas défini de photographe ni d'autres participants pour cette sortie.\n Cliquez sur le bouton <<Voir plus>> pour charger d'autres éventuels participants ou aller dans les détails de la sortie pour ajouter des participants et définir un photographe."),
                   
                    ],
                  ),
                    const SizedBox(height: 10,),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                                  onTap: () {
                                    setState(() {
                                      more = !more;
                                      loading = true;
                                   
                                    });
                                       if(more && lists2.isEmpty){
                                        userController.fetchUsers(1);
                                      lists2 = userController.userList ;
                                     
                                      }
                                     if(lists2.isNotEmpty){
                                        setState(() {
                                          loading = false;
                                        });
                                      }
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
                                      child:  Row(
                                        children: [                                
                                          Text( more ? "Voir moins":
                                            "Voir plus  ",
                                            style: const TextStyle(
                                                color: Constants.colorPrimary),
                                          ),
                                           Icon( more? Icons.arrow_drop_up :
                                            Icons.arrow_drop_down,
                                            color: Constants.colorPrimary,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                      ],
                    ),
                  const SizedBox(height: 10,),
                  if(more)
                    SizedBox(
                      child:
                       Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          child:  loading ? 
                      const Center(
                        child: SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 1,))
                      ) : SizedBox(
                        height:lists2.length * 130,
                        child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: lists2.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                               return ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              children: lists2
                                  .where((element) => (element.name!
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase()) ||
                                      element.firstname!
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase())))
                                  .map((e) => GestureDetector(
                                        onTap: () async {
                                         observationController.photograph.value = e;
                                        Get.back(result: e);
                                        },
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  title: CustomText(
                                                      text:
                                                          "${e.name!} ${e.firstname!}"),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => AddUserScreen(
                                                            userModel: e, type: 1,
                                                          ))?.then((value) {
                                                       Get.back(result: e);
                                                      });
                                                    },
                                                    child: Card(
                                                      elevation: 2,
                                                      shape: const CircleBorder(),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(7),
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                                color: Constants
                                                                    .colorPrimary),
                                                        child: const Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.dialog(const DeleteDialog())
                                                          .then((value) {
                                                        if (value == true) {
                                                          userController
                                                              .deleteUser(e.id!, 1);
                                                        }
                                                      });
                                                    },
                                                    child: Card(
                                                      elevation: 2,
                                                      shape: const CircleBorder(),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(7),
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                                color: Color.fromARGB(
                                                                    255,
                                                                    163,
                                                                    11,
                                                                    11)),
                                                        child: const Icon(
                                                          Icons.close,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )).toList(),
                            );
                                                 
                              }
                              ),
                      ),
                        )
                      ],
                    )
                  ],
                )
                    )
                  
                
              ],
            ),
        ],
        ),
      ),
    );
  }
}
