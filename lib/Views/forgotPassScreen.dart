import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/Views/pincodeScreen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
        // backgroundColor: Constants.colorPrimary,
        centerTitle: true,
        leading: const AppBarBack(),
        title: const CustomText(
          text: "Réintialisation de mot de passe",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Veuillez entrer l\'adresse mail que vous avez rensigné lors de la création de votre compte',
                        style: GoogleFonts.nunito(
                            color: Constants.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                            textAlign: TextAlign.justify,
                      ),
                    ),
                     const SizedBox(
                      height: 30,
                    ),
                    CustomInputField(
                      label: "Email",
                      controller: emailController,
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
                              askCode();
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
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Valider',
                                        style: GoogleFonts.nunito(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                  ]),
            ),
          ),
        ));
  }

  Future askCode() async {
    setState(() {
      isLogin = true;
    });
     if (emailController.text.isEmpty) {
      Utils.showToast("Veuillez entrer votre adresse mail");
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(emailController.text)) {
      Utils.showToast("Veuillez entrer une adresse mail valid");
    }else{
          Map<String, dynamic> data = {
      "email" : emailController.text
    };
    int? response = await ApiProvider.auth().askCode(data);
       setState(() {
        isLogin = false;
      });
    if(response == 200){
         Get.to(()=> PinCodeScreen(email: emailController.text,));
    }else{



    }
   
    }
  }

}
