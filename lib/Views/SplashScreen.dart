
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Views/LogingScreen.dart';
import 'package:naturascan/Views/list_expedition_screen.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // Get.offAll(()=> const LoginScreen());

      redirection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorPrimary,
      body: Center(
        child: Text(
          'NaturaScan',
          style: GoogleFonts.barriecito(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),
    );
  }

  Future<void> redirection() async {
    await 0.2.delay();
    if (await PrefManager.getBool(Constants.connected) == true) {
      Get.offAll(() => const ListExpeditionScreen(step: 0,));
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
