import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Views/forgotPassScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';
import 'package:naturascan/Views/signUp.dart';
import 'package:naturascan/controllers/syncController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLogin = false;
  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connectez-vous à votre compte',
                      style: GoogleFonts.nunito(
                        color: Constants.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
               const  SizedBox(height: 20,),
                CustomInputField(
                  controller: nameController,
                  label: "Votre adresse mail ou pseudo",
                  enabled: !isLogin,
                ),
                 CustomInputField(
                  label: "Mot de passe",
                  controller: passwordController,
                  enabled: !isLogin,
                  obscure: visible,
                  suffix: InkWell(
                    onTap: (){
                      setState(() {
                        visible = !visible;
                      });
                    },
                    child: Icon(visible? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600, size: 20,)),
                ),
               

                   isLogin?
                   const Center(
                     child: Padding(
                       padding: EdgeInsets.only(top: 30),
                       child: SizedBox(
                         height: 20,
                           width: 20,
                           child: CircularProgressIndicator(strokeWidth: 2,)),
                     ),
                   )
                   :
                   Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.to(()=> const ForgotPassScreen());
                      },
                      child: const Text('Mot de passe oublié?',),
                    ),
                      const SizedBox(
                  height: 10,
                ),
            
               InkWell(
                  onTap:(){
                    login();
                   // Get.to(()=> ListExpeditionScreen());
                  },
                  child:Card(
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
                        child:Center(
                          child: Text('CONNEXION',
                            style: GoogleFonts.nunito(
                                fontSize: 15,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Vous n'avez pas de compte?"),
                    TextButton(
                      child: const Text(
                        "Créer un compte",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                       Get.to(()=> const SignUpScreen());
                      },
                    )
                  ],
                ),
              
                  ],
                ),
              ]
            ),
          ),
        ),
      )
    );
 
  }


  Future<void> login()async{
    if(nameController.text.isEmpty){
      Utils.showToast("Veuillez entrer votre email ou votre pseudo");
    } else if(passwordController.text.isEmpty){
      Utils.showToast("Veuillez entrer votre mot de passe");
    }else{
      setState(() {
        isLogin = true;
      });
      Map<String, dynamic> body = {
        "email": nameController.text,
        "password": passwordController.text
      };
      print("eegegge");
      String? response = await ApiProvider.auth().connexion(body);
      if(response != null && response != ""){
        Utils().getUser();
        PrefManager.putBool(Constants.connected, true);
        PrefManager.putString(Constants.email, nameController.text);
        PrefManager.putString(Constants.accessTokenAuth, response);
           await SyncController().sync();
        Get.offAll(()=> const ListExpeditionScreen(step: 0,));
      }else{
      }
      setState(() {
        isLogin = false;
      });
      //  print("resssss ${response}");
    }
  }

}
