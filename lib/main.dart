import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Views/SplashScreen.dart';
import 'package:naturascan/controllers/categotySpeciesController.dart';
import 'package:naturascan/controllers/etapeController.dart';
import 'package:naturascan/controllers/gpsTrackController.dart';
import 'package:naturascan/controllers/observationController.dart';
import 'package:naturascan/controllers/syncController.dart';
import 'package:naturascan/controllers/userController.dart';
import 'package:naturascan/controllers/zoneController.dart';

import 'controllers/sortieController.dart';

import 'package:flutter/foundation.dart'; 
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; 
import 'package:sqflite/sqflite.dart'; 


Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized(); 
  if (kIsWeb) {
    // Pour le web, initialisez le factory FFI
    databaseFactory = databaseFactoryFfiWeb; 
    // GoogleMapsFlutterPlatform.instance = GoogleMapsFlutterPlugin();

  } else if (defaultTargetPlatform == TargetPlatform.windows ||
             defaultTargetPlatform == TargetPlatform.linux ||
             defaultTargetPlatform == TargetPlatform.macOS) {
    // Pour le bureau, initialisez aussi le factory FFI
    sqfliteFfiInit(); // Initialise le support FFI pour le bureau
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

final box = GetStorage();
ProgressDialog progress = ProgressDialog(Get.context!);
SortieController sortieController = Get.put(SortieController());
UserController userController = Get.put(UserController());
EtapeController etapeController = Get.put(EtapeController());
GpsTrackController gpsTrackController = Get.put(GpsTrackController());
ObservationController observationController = Get.put(ObservationController());
CategorySpeciesController categorySpeciesController = Get.put(CategorySpeciesController());
ZoneController zoneController = Get.put(ZoneController());


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'naturascan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Constants.colorPrimary),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
        ],
       initialBinding: BindingsBuilder(() {
      //  Get.put(RefreshTokenController());
       Get.put(SyncController());
      }),
        home: const SplashScreen());
  }
}
