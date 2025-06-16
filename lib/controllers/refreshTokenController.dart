// import 'dart:async';

// import 'package:get/get.dart';
// import 'package:naturascan/Network/ApiProvider.dart';
// import 'package:naturascan/Utils/PrefManager.dart';
// import 'package:naturascan/Utils/constants.dart';
// class RefreshTokenController extends GetxController {
//  static RefreshTokenController instance = Get.find();
//  var change = 0.obs;
//   Timer? timer;
//  @override
//   void onInit() { 
//     print("refresssh ${change.value}");
//     ever(change, (_) {
//       refreshToken();
//     });
//     timerCalling();
//     super.onInit();
//   }

//    timerCalling() {
//     timer = Timer.periodic(const Duration(minutes: 55), (Timer t) => changeCount());
//   }

//   changeCount() async {
//     String token = await PrefManager.getString(Constants.accessTokenAuth);
//     if (token.isNotEmpty) {
//         change.value++;
//     }
//   }

//   Future<void> refreshToken() async{
//     try{
//         String? response = await ApiProvider().refreshTok();
//       if(response != null && response != ""){
//       await  PrefManager.putString(Constants.accessTokenAuth, response);
//       }
//     }catch(e){

//     }
    
//   }
// }
