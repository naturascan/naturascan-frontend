import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Views/detailsObservationScreen.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/userModel.dart';

import '../../../../../Views/addUserScreen.dart';

class SelectAndAddUserWidget extends StatefulWidget {
  final List<UserModel>? selectedUser;
  final int type;
  const SelectAndAddUserWidget({super.key, this.selectedUser, required this.type});

  @override
  State<SelectAndAddUserWidget> createState() => _SelectAndAddUserWidgetState();
}

class _SelectAndAddUserWidgetState extends State<SelectAndAddUserWidget> {
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
              child: FutureBuilder(
                  future: userController.fetchUsers(widget.type),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      return ListView(
                        children: userController.userList
                            .where((element) =>(element.name!
                                .toLowerCase()
                                .contains(searchValue.toLowerCase()) || element.firstname!.toLowerCase().contains(searchValue.toLowerCase())))
                            .map((e) => GestureDetector(
                                  onTap: () async {
                                    if (!widget.selectedUser!.any(
                                        (element) => element.name == e.name)) {
                                      widget.selectedUser!.add(e);
                                      setState(() {});
                                    }

                                    Get.back();
                                  },
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            title: CustomText(
                                                text: "${e.name!} ${e.firstname!}"),
                                          ),
                                        ),
                                         Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                       Get.to(() =>  AddUserScreen(userModel: e, type: widget.type))?.then((value) {
                              Get.back();
                           
                        });
                        },
                        child: Card(
                          elevation: 2,
                          shape: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Constants.colorPrimary),
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
                          Get.dialog(const DeleteDialog()).then((value) {
                            if (value == true) {
                              userController.deleteUser(e.id!, widget.type);
                            }
                          });
                        },
                        child: Card(
                          elevation: 2,
                          shape: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color.fromARGB(255, 163, 11, 11)),
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
                                ))
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child:
                            CustomText(text: "Aucun participant enregistré"),
                      );
                    }
                  })),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                        // Get.to(() => const AddUserScreen())?.then((value) {
                        //   if(value != null){
                        //      if (!widget.selectedUser!.any(
                        //                 (element) => element.name == value.name)) {
                        //               widget.selectedUser!.add(value);
                        //               setState(() {});
                        //               Get.back();
                        //             }
                        //   }
                           
                        // });

                             Get.to(() => AddUserScreen(type: widget.type))?.then((value) {
                              Get.back();
                           
                        });
                        
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    height: 45,
                    decoration: BoxDecoration(
                        color: Constants.colorPrimary,
                        borderRadius: BorderRadius.circular(10)),
                    child:  Center(
                      child: Text(
                        "Nouveau ${widget.type == 1 ? "participant" : widget.type == 2 ? "référent secteur" : "patrouilleur"}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
