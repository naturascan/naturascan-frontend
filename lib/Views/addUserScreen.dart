import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/models/local/roleModel.dart';
import 'package:naturascan/models/local/userModel.dart';

import '../Utils/Widgets/backButton.dart';
import '../Utils/constants.dart';
import '../Utils/Widgets/customInputField.dart';
import '../Utils/Widgets/customText.dart';
import '../Utils/progress_dialog.dart';
import '../main.dart';
class AddUserScreen extends StatefulWidget {
  final int type;
  final UserModel? userModel;
  const AddUserScreen({super.key, this.userModel, required this.type});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  RxBool oservateur = false.obs, referent = false.obs, patrouilleur = false.obs;
  @override
  void initState() {
    getData();
    super.initState();
  }
   
   @override
  void dispose() {
   userController.reset();
    super.dispose();
  }

  void getData() {
    if(widget.type == 1){
      oservateur.value = true;
    }
    if(widget.type == 2){
      referent.value = true;
    }
    if(widget.type == 3){
      patrouilleur.value = true;
    }
    if (widget.userModel != null) {
      userController.firstnameController.text =
          widget.userModel?.firstname ?? "";
      userController.nameController.text = widget.userModel?.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Constants.colorPrimary,
        centerTitle: true,
        leading: const AppBarBack(),
        title: CustomText(
          text: widget.userModel == null
              ? "Créer un ${widget.type == 1 ? "participant" : widget.type == 2 ? "référent" : "patrouilleur"}"
              : "Modifier un ${widget.type == 1 ? "participant" : widget.type == 2 ? "référent" : "patrouilleur"}",
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                hint: "Prénom",
                controller: userController.nameController,
              ),
              CustomInputField(
                hint: "Nom",
                controller: userController.firstnameController,
              ),
              Column(
                children: [
                  Obx(() {
                    return CheckboxListTile.adaptive(
                      value: oservateur.value,
                      onChanged: (v) {
                        oservateur.value = v!;
                      },
                      title: const Text(
                        "Observateur naturaScan",
                      ),
                    );
                  }),
                  Obx(() {
                    return CheckboxListTile.adaptive(
                      value: referent.value,
                      onChanged: (v) {
                        referent.value = v!;
                      },
                      title: const Text("Référent"),
                    );
                  }),
                  Obx(() {
                    return CheckboxListTile.adaptive(
                      value: patrouilleur.value,
                      onChanged: (v) {
                        patrouilleur.value = v!;
                      },
                      title: const Text("Patrouilleur"),
                    );
                  }),
                ],
              ),

              // CustomInputField(
              //   hint: "Email",
              //   controller: userController.emailController,
              // ),
              // CustomInputField(
              //   hint: "Téléphone",
              //   keyboardType: TextInputType.phone,
              //   controller: userController.mobileNumberController,
              // ),
              // CustomInputField(
              //   hint: "Adresse",
              //   controller: userController.addressController,
              // ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  if (userController.nameController.text.isEmpty) {
                    Utils.showToast(
                        "Veuillez entrer le nom du nouveau participant");
                  } else if (userController.firstnameController.text.isEmpty) {
                    Utils.showToast(
                        "Veuillez entrer le prénom du nouveau participant");
                    // } else if (userController.emailController.text.isEmpty) {
                    //   Utils.showToast(
                    //       "Veuillez entrer l'adresse mail du nouveau participant");
                    // } else if (!RegExp(
                    //         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    //     .hasMatch(userController.emailController.text)) {
                    //   Utils.showToast("Veuillez entrer un email valid");
                  } else {
                    progress = ProgressDialog(context);
                    progress.show();
                    await 1.delay();
                    if (widget.userModel != null) {
                      userController.updateUser(
                          widget.userModel!.id!,
                          {
                            "id": widget.userModel!.id!,
                            "name": userController.nameController.text,
                            "firstname":
                                userController.firstnameController.text,
                            "roles":jsonEncode([
                              if(oservateur.value || (!oservateur.value && !referent.value && !patrouilleur.value)) RoleModel(
                                id: 1,
                                name: 'Observateur',
                                description: 'Administrator Role',
                                enabled: true,
                                isSysRole: true,
                              ),
                              if(referent.value) RoleModel(
                                id: 2,
                                name: 'référent',
                                description: 'Administrator Role',
                                enabled: true,
                                isSysRole: true,
                              ).toJson(),
                             if(patrouilleur.value)  RoleModel(
                                id: 3,
                                name: 'patrouilleur',
                                description: 'Administrator Role',
                                enabled: true,
                                isSysRole: true,
                              ).toJson(),
                            ])
                        
                          },
                          widget.type);
                    } else {
                      userController.addUser2({
                        "name": userController.nameController.text,
                        "firstname": userController.firstnameController.text,
                        "roles": jsonEncode([
                              if(oservateur.value || (!oservateur.value && !referent.value && !patrouilleur.value)) RoleModel(
                                id: 1,
                                name: 'Observateur',
                                description: 'Administrator Role',
                                enabled: true,
                                isSysRole: true,
                              ),
                              if(referent.value) RoleModel(
                                id: 2,
                                name: 'référent',
                                description: 'Administrator Role',
                                enabled: true,
                                isSysRole: true,
                              ).toJson(),
                             if(patrouilleur.value)  RoleModel(
                                id: 3,
                                name: 'patrouilleur',
                                description: 'Administrator Role',
                                enabled: true,
                                isSysRole: true,
                              ).toJson(),
                              
                            ])
                        
                      }, widget.type);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Constants.colorPrimary,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Enregistrer',
                            style: GoogleFonts.nunito(
                                fontSize: 15, color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
