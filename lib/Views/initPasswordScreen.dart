// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:naturascan/Network/ApiProvider.dart';
// import 'package:naturascan/Utils/PrefManager.dart';
// import 'package:naturascan/Utils/Utils.dart';
// import 'package:naturascan/Utils/constants.dart';
// import 'package:naturascan/Utils/Widgets/customInputField.dart';
// import 'package:naturascan/Views/list_expedition_screen.dart';

// import '../Utils/Widgets/otpWidget.dart';

// class ResetPassScreen extends StatefulWidget {
//   final int? code;
//   const ResetPassScreen({super.key, required this.code});

//   @override
//   State<ResetPassScreen> createState() => _ResetPassScreenState();
// }

// class _ResetPassScreenState extends State<ResetPassScreen> {
//   TextEditingController emailController = TextEditingController();
//   bool isLogin = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 30, right: 30),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Naturascan',
//                       style: GoogleFonts.barriecito(
//                         color: Constants.colorPrimary,
//                         fontSize: 40,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Validation',
//                         style: GoogleFonts.nunito(
//                             color: Constants.textColor,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     const OtpWidget(),
//                     CustomInputField(
//                       label: "Nouveau mot de passe",
//                       controller: emailController,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     isLogin
//                         ? const Center(
//                             child: SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 )),
//                           )
//                         : InkWell(
//                             onTap: () {
//                               // Get.to(()=> ListExpeditionScreen());
//                             },
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                 ),
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Constants.colorPrimary,
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 50,
//                                     child: Center(
//                                       child: Text(
//                                         'Enregistrer',
//                                         style: GoogleFonts.nunito(
//                                             fontSize: 15, color: Colors.white),
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                   ]),
//             ),
//           ),
//         ));
//   }

//   Future getUser() async {
//     String? response = await ApiProvider().userInfos();

//     //var dtl = jsonDecode(await PrefManager.getString(Constants.partenaireInfo));
//     //payCheck.Partenaire partenaireInfos = payCheck.Partenaire.fromJson(dtl);
//     // PrefManager.putString(Constants.partenaireInfo, jsonEncode(bean.data));
//   }
// }
