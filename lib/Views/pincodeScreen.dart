import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Views/LogingScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/Views/resetPassScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:naturascan/Utils/Utils.dart';




class PinCodeScreen extends StatefulWidget {
  final String email;
  const PinCodeScreen({super.key, required this.email});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String email = "";
  bool isLogin = false;
  bool isLogin2 = false;
  bool visible = true;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

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
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: ListView(
              padding: const EdgeInsets.only(
                  top: 50, left: 10, right: 10, bottom: 30),
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                      text:
                          "Entrez le code que vous avez reçu à l'adresse mail ",
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 2),
                        ),
                        const TextSpan(
                          text: ' et créer un nouveau mot de passe',
                          style: TextStyle(
                              color: Colors.black, fontSize: 15, height: 2),
                        ),
                      ],
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 30,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: Colors.white,
                      pastedTextStyle: const TextStyle(
                        color: Constants.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        activeColor: Constants.colorPrimary,
                        selectedColor: Constants.colorPrimary,
                        inactiveColor: Colors.grey.shade600,
                        inactiveFillColor: Colors.grey.shade400,
                        selectedFillColor:
                            const Color.fromARGB(255, 114, 165, 160),
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {},
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    hasError ? "*Veuillez remplir tous les champs" : "",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                CustomInputField(
                  label: "Nouveau mot de passe",
                  controller: passwordController,
                  enabled: !isLogin,
                  obscure: visible,
                  suffix: InkWell(
                      onTap: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: Icon(
                        visible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade600,
                        size: 20,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vous n'avez pas reçu de code? ",
                      style: TextStyle(color: Colors.black54, fontSize: 15),
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
                        : TextButton(
                            onPressed: () => askCode(),
                            child: const Text(
                              "RENVOYER",
                              style: TextStyle(
                                color: Color(0xFF91D3B3),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                isLogin2
                        ? const Center(
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )),
                          )
                        :Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Constants.colorPrimary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ButtonTheme(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        formKey.currentState!.validate();
                        if (currentText.length != 6) {
                          errorController!.add(ErrorAnimationType.shake);
                          setState(() => hasError = true);
                        } else {
                         newPassWord();
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Valider",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          textEditingController.clear();
                        },
                        child: const Text("Effacer")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future askCode() async {
    setState(() {
      isLogin = true;
    });
    Map<String, dynamic> data = {"email": widget.email};
    int? response = await ApiProvider.auth().askCode(data);
    setState(() {
      isLogin = false;
    });
    if (response == 200) {
    } else {}
  }

  Future newPassWord() async {
     if (passwordController.text.length < 8) {
      Utils.showToast("Votre mot de passe doit contenir au moins 8 caractère");
    }else{
         setState(() {
      isLogin2 = true;
    });
    Map<String, dynamic> data = {"code": currentText, "password": passwordController.text, "email": widget.email};
    int? response = await ApiProvider.auth().newPassWord(data);
    setState(() {
      isLogin2 = false;
    });
    if (response == 200) {
      Get.offAll(()=> const LoginScreen());
    } else {

    }
    }
 
  }
}
