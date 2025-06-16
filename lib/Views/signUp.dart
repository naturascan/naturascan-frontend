import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Views/LogingScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  RxBool naturascan = false.obs;
  bool isLogin = false;
  bool visile1 = true;
  bool visile2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Constants.colorPrimary,
          centerTitle: true,
          leading: const AppBarBack(),
          title: const CustomText(
            text: "Création de compte",
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Naturascan',
                        style: GoogleFonts.barriecito(
                          color: Constants.colorPrimary,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Veuillez remplir ces champs pour créer votre compte',
                        style: GoogleFonts.nunito(
                            color: Constants.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputField(
                        enabled: !isLogin,
                        label: "Nom",
                        controller: firstnameController,
                      ),
                      CustomInputField(
                        enabled: !isLogin,
                        label: "Prenom",
                        controller: nameController,
                      ),
                      CustomInputField(
                        enabled: !isLogin,
                        label: "Email",
                        controller: emailController,
                      ),
                      CustomInputField(
                        enabled: !isLogin,
                        label: "Pseudo",
                        controller: pseudoController,
                      ),
                      CustomInputField(
                        enabled: !isLogin,
                        label: "Adresse",
                        controller: adressController,
                      ),
                      CustomInputField(
                        enabled: !isLogin,
                        label: "Numéro de téléphone",
                        keyboardType: TextInputType.phone,
                        controller: telephoneController,
                      ),
                      CustomInputField(
                        label: "Mot de passe",
                        controller: passwordController,
                        enabled: !isLogin,
                        obscure: visile1,
                        suffix: InkWell(
                            onTap: () {
                              setState(() {
                                visile1 = !visile1;
                              });
                            },
                            child: Icon(
                              visile1 ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey.shade600,
                              size: 20,
                            )),
                      ),
                      CustomInputField(
                        label: "Confirmaton de mot de passe",
                        controller: passwordConfController,
                        enabled: !isLogin,
                        obscure: visile2,
                        suffix: InkWell(
                            onTap: () {
                              setState(() {
                                visile2 = !visile2;
                              });
                            },
                            child: Icon(
                              visile2 ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey.shade600,
                              size: 20,
                            )),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return CheckboxListTile.adaptive(
                                value: naturascan.value,
                                onChanged: (v) {
                                  naturascan.value = v!;
                                },
                                title: const Text("NaturaScan",),
                              );
                            }),
                          ),
                          Expanded(
                            child: Obx(() {
                              return CheckboxListTile.adaptive(
                                value: !naturascan.value,
                                onChanged: (v) {
                                  naturascan.value = !v!;
                                },
                                title: const Text("SuiviTrace"),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLogin
                          ? const Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )),
                            )
                          : InkWell(
                              onTap: () {
                                login();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Constants.colorPrimary,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'INSCRIPTION',
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Vous avez déjà un compte?"),
                          TextButton(
                            child: const Text(
                              "Connectez-vous",
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Get.offAll(() => const LoginScreen());
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }

  Future<void> login() async {
    if (firstnameController.text.isEmpty) {
      Utils.showToast("Veuillez entrer votre nom de famille");
    } else if (nameController.text.isEmpty) {
      Utils.showToast("Veuillez entrer votre prénom");
    } else if (emailController.text.isEmpty) {
      Utils.showToast("Veuillez entrer votre adresse mail");
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(emailController.text)) {
      Utils.showToast("Veuillez entrer une adresse mail valid");
    } else if (pseudoController.text.isEmpty) {
      Utils.showToast("Veuillez entrer un pseudo");
    } else if (passwordController.text.isEmpty) {
      Utils.showToast("Veuillez entrer un mot de passe");
    } else if (passwordController.text.isEmpty) {
      Utils.showToast("Veuillez confirmer votre mot de passe");
    } else if (passwordController.text != passwordConfController.text) {
      Utils.showToast(
          "Les champs <<mot de passe >> et <<confirmation de mot de passe>> ne sont pas conformes");
    } else if (passwordController.text.length < 8) {
      Utils.showToast("Votre mot de passe doit contenir au moins 8 caractère");
    } else {
      setState(() {
        isLogin = true;
      });
      Map<String, dynamic> body = {
        "name": nameController.text,
        "firstname": firstnameController.text,
        "email": emailController.text,
        "pseudo": pseudoController.text,
        "password": passwordConfController.text,
        "password_confirmation": passwordConfController.text,
        "access": naturascan.value ? '1': "2",
        if (telephoneController.text.isNotEmpty)
          "mobile_number": telephoneController.text,
        if (adressController.text.isNotEmpty) "adress": adressController.text
      };
      String? response = await ApiProvider.auth().inscription(body);
      if (response != null && response != "") {
        Utils.showToast("Compte crée avec succcès, veuillez vous connecter.");
        Get.offAll(() => const LoginScreen());
      } else {}
      setState(() {
        isLogin = false;
      });
      //  print("resssss ${response}");
    }
  }

}
