// import 'dart:developer';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:naturascan/Utils/backButton.dart';
// import 'package:flutter/material.dart';
// import 'package:naturascan/Utils/customText.dart';
// import 'package:naturascan/Views/observationForm/observForm.dart';
// import '../../../Utils/constants.dart';
// import 'package:get/get.dart';

// import '../../../main.dart';

// class ThisrdPage extends StatefulWidget {
//   const ThisrdPage({super.key});

//   @override
//   State<ThisrdPage> createState() => _ThisrdPageState();
// }

// class _ThisrdPageState extends State<ThisrdPage> {
//   bool withObser = false;
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//         init: observationController,
//         builder: (observationControl) {
//           return SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border:
//                           Border.all(color: Colors.grey.shade400, width: .5)),
//                   child: const Column(
//                     children: [
//                       CustomText(
//                         text: "3/4",
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 20, top: 20),
//                         child: Align(
//                             alignment: Alignment.center,
//                             child: CustomText(
//                               textAlign: TextAlign.center,
//                               text: "Ajouter des observations",
//                               fontSize: 22,
//                             )),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
                
//               ],
//             ),
//           );
//         });
  
//   }

//   Widget getItem() {
//     return Padding(
//       padding: const EdgeInsets.only(right: 5.0),
//       child: InkWell(
//           onTap: () {},
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//               //set border radius more than 50% of height and width to make circle
//             ),
//             elevation: 1,
//             child: Container(
//               width: 130,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(15)),
//               child: Column(
//                 children: <Widget>[
//                   ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(15),
//                           topRight: Radius.circular(15)),
//                       child: Container(
//                         width: 140,
//                         height: 70,
//                         decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15),
//                               topRight: Radius.circular(15)),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey.shade500, width: 0.5),
//                                   right: BorderSide(
//                                       color: Colors.grey.shade500, width: 0.5),
//                                 )),
//                                 child: Container(
//                                     padding: const EdgeInsets.all(7),
//                                     margin: const EdgeInsets.only(
//                                         right: 5, bottom: 5),
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: Colors.grey.shade400,
//                                         ),
//                                         shape: BoxShape.circle),
//                                     child: Icon(
//                                       Icons.visibility_outlined,
//                                       color: Colors.grey.shade400,
//                                     )),
//                               ),
//                             ),
//                             Expanded(
//                                 child: Column(
//                               children: [
//                                 Container(
//                                   margin:
//                                       const EdgeInsets.only(left: 5, top: 5),
//                                   child: const Row(
//                                     children: [
//                                       Text(
//                                         "Min:  ",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12),
//                                       ),
//                                       Text(
//                                         "14",
//                                         style: TextStyle(fontSize: 12),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   margin:
//                                       const EdgeInsets.only(left: 5, top: 3),
//                                   child: const Row(
//                                     children: [
//                                       Text(
//                                         "Max:  ",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12),
//                                       ),
//                                       Text(
//                                         "25",
//                                         style: TextStyle(fontSize: 12),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   margin:
//                                       const EdgeInsets.only(left: 5, top: 3),
//                                   child: const Row(
//                                     children: [
//                                       Icon(
//                                         Icons.check_circle_outline,
//                                         size: 10,
//                                         color: Colors.teal,
//                                       ),
//                                       Text(
//                                         "  Jeune",
//                                         style: TextStyle(fontSize: 12),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ))
//                           ],
//                         ),
//                       )),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(bottom: 5, left: 3, right: 3),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.calendar_month_outlined,
//                           size: 10,
//                           color: Colors.teal,
//                         ),
//                         Text(
//                           "  24/01/2024",
//                           style: GoogleFonts.nunito(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                             color: Colors.black,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(bottom: 3, left: 3, right: 3),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Début",
//                               style: GoogleFonts.nunito(
//                                   decoration: TextDecoration.underline,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.timer,
//                                   size: 10,
//                                   color: Colors.teal,
//                                 ),
//                                 Text(
//                                   "  12:30",
//                                   style: GoogleFonts.nunito(
//                                     fontSize: 10,
//                                     color: Colors.black,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Fin",
//                               style: GoogleFonts.nunito(
//                                   decoration: TextDecoration.underline,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.timer,
//                                   size: 10,
//                                   color: Colors.teal,
//                                 ),
//                                 Text(
//                                   "  12:30",
//                                   style: GoogleFonts.nunito(
//                                     fontSize: 10,
//                                     color: Colors.black,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Card(
//                         elevation: 2,
//                         shape: const CircleBorder(),
//                         child: Container(
//                           padding: const EdgeInsets.all(7),
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle, color: Colors.white),
//                           child: Icon(
//                             Icons.edit,
//                             size: 15,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 30,
//                       ),
//                       Card(
//                         elevation: 2,
//                         shape: const CircleBorder(),
//                         child: Container(
//                           padding: const EdgeInsets.all(7),
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle, color: Colors.white),
//                           child: Icon(
//                             Icons.delete,
//                             size: 15,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }

// }
