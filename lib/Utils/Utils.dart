import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
// import 'package:flutter_map_math/flutter_map_math.dart';
import 'package:flutter/services.dart';
import 'package:naturascan/Network/ApiProvider.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/progress_dialog.dart';
import 'package:naturascan/Views/LogingScreen.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:flutter_local_storage/flutter_local_storage.dart';

import '../models/local/gpsTrackModel.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    return diff.inDays <= 0
        ? "aujourd'hui"
        : "en ${diff.inDays.toString()} jours";
  }

  static jsonStringToMap(String data) {
    List<String> str = data.replaceAll("{", "").replaceAll("}", "").split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split("=");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }

  static String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  static String formatDate(int date) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    var formatter = DateFormat("yMMMMEEEEd", 'fr_FR');
    return formatter.format(dateTime);
  }

  static String formatDate1(int date) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    var formatter = DateFormat("yMMMd", 'fr_FR');
    return formatter.format(dateTime);
  }

  static String formatDateTime(int date) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(date);
    return tsdate.toString();
  }

  static String formatDateAndTime(int date) {
    return "${formatDate(date)} ${formatTime(date)}";
  }

  static String formatTime(int date) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    var formatter = DateFormat("Hm", 'fr_FR');
    return formatter.format(dateTime);
  }

  static showToast(String msg) {
    if (msg == "null") return;
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static showToastBlack(String msg) {
    if (msg == "null") return;
    Fluttertoast.showToast(
      msg: msg,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static String getEmojiFlag(String emojiString) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    final firstChar = emojiString.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = emojiString.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  static Widget getLoader() {
    return const CircularProgressIndicator();
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print("${match.group(0)}"));
  }

  static String getFormattedAmount(num solde) {
    return NumberFormat.currency(
      locale: ui.window.locale.languageCode,
      decimalDigits: 2,
      symbol:
          '', // if you want to add currency symbol then pass that in this else leave it empty.
    ).format(solde);
  }

  static String getFormattedAmountSimple(num solde) {
    return NumberFormat.currency(
      locale: ui.window.locale.languageCode,
      decimalDigits: 0,
      symbol:
          '', // if you want to add currency symbol then pass that in this else leave it empty.
    ).format(solde);
  }

  static String getFormattedAmountTree(num solde) {
    return NumberFormat.currency(
      locale: ui.window.locale.languageCode,
      decimalDigits: 3,
      symbol:
          '', // if you want to add currency symbol then pass that in this else leave it empty.
    ).format(solde);
  }

  static String getLocale() => ui.window.locale.languageCode;

  static String rebuildGrade(String grade) {
    if (grade == "Diamant Elite") return "D. Elite";
    return grade;
  }

  static Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  double calculateDistance(List<GpsTrackModel> gpsTrackList) {
    // Trier la liste par longitude (ou latitude)
    gpsTrackList.sort((a, b) => (a.longitude ?? 0).compareTo(b.longitude ?? 0));

    double distance = 0;

    // Calcul de l'aire sous la courbe (Méthode du trapèze)
    for (int i = 0; i < gpsTrackList.length - 1; i++) {
      double longitude1 = gpsTrackList[i].longitude ?? 0;
      double longitude2 = gpsTrackList[i + 1].longitude ?? 0;
      double latitude1 = gpsTrackList[i].latitude ?? 0;
      double latitude2 = gpsTrackList[i + 1].latitude ?? 0;
      double dis = Geolocator.distanceBetween(
          latitude1, longitude1, latitude2, longitude2);
      print("la distance 1hh $dis");
      distance +=
          dis.abs(); // Ajouter l'aire du trapèze à l'aire échantillonnée
    }
    print("la distance final $distance");

    return distance / 1000;
  }

  String convertToDms(double latitude, bool lat) {
    int degrees = latitude.truncate();
    double decimalPart = latitude - degrees;
    int minutes = (decimalPart * 60).truncate();
    double remainingDecimal = decimalPart * 60 - minutes;
    int seconds = (remainingDecimal * 60).truncate();
    degrees = degrees.abs();
    minutes = minutes.abs();
    seconds = seconds.abs();
    return '$degrees° $minutes\' $seconds" ${lat ? 'N' : 'E'}';
  }

  double calculateArea(List<GpsTrackModel> gpsTrackList) {
    // Trier la liste par longitude (ou latitude)
    gpsTrackList.sort((a, b) => (a.longitude ?? 0).compareTo(b.longitude ?? 0));

    double area = 0;

    // Calcul de l'aire sous la courbe (Méthode du trapèze)
    for (int i = 0; i < gpsTrackList.length - 1; i++) {
      double base1 = gpsTrackList[i].longitude ?? 0;
      double base2 = gpsTrackList[i + 1].longitude ?? 0;
      double height1 = gpsTrackList[i].latitude ?? 0;
      double height2 = gpsTrackList[i + 1].latitude ?? 0;
      double width = base2 - base1;
      double averageHeight = (height1 + height2) / 2;
      double areah = width * averageHeight;

      area += areah.abs(); // Ajouter l'aire du trapèze à l'aire échantillonnée
    }
    return area;
  }

  String getTypeSortie(int type) {
    switch (type) {
      case 0:
        return "NaturaScan";
      case 1:
        return "SuiviTrace";
      default:
        return "NaturaScan";
    }
  }

  String getmodeProspection(String type) {
    switch (type) {
      case "0":
        return "A pied";
      case "1":
        return "A vélo";
      case "2":
        return "A drône";
      default:
        return type;
    }
  }

  String getTypeObservation(int type) {
    switch (type) {
      case 0:
        return "Animal marin";
      case 1:
        return "Oiseaux";
      case 2:
        return "Déchets";
      default:
        return "Inconnu";
    }
  }

  Future<UserModel?> getUser() async {
    String dt = await PrefManager.getString(Constants.me);
    if (dt.isNotEmpty) {
      UserModel userModel = UserModel.fromJson(jsonDecode(dt));
      return userModel;
    } else {
      UserModel? response = await ApiProvider("a").userInfos();
      if (response != null) {
        await PrefManager.putInt(
            Constants.role, int.tryParse(response.access ?? "1") ?? 1);

        await PrefManager.putString(
            Constants.me, jsonEncode(response.toJson()));
        return response;
      }
    }
  }

  sendExcel() async {
    try{
    progress.show();
    int? response = await ApiProvider("le fichier excel n'a pas été envoyé.").sendExcel();
    if(response == 200){
         
    }
    }catch(e){
    }
  }

  void logout() async {
    try{
    progress = ProgressDialog(Get.context!);
    progress.show();
    int? response = await ApiProvider("La déconnexion a échouée.").deconnexion();
    if(response == 200){
      localLogout();
    }
    }catch (e){
     localLogout(); 
    }
  }

  void localLogout() async {
    PrefManager.clear();
    progress.hide();
    Get.offAll(() => const LoginScreen());
  } 

  String compressString(String json){
    final encodedJson = utf8.encode(json);
    final gZipJson = gzip.encode(encodedJson);
    final compressData = base64.encode(gZipJson);
    return compressData;
  }


     storeImage(Uint8List bytes) async{
  final filePath =  await LocalStorage.i.saveAsBytes("${DateTime.now().microsecondsSinceEpoch}.png", bytes);
  print("fileeee $filePath");
    return filePath;
  }

  String deCompressJson(String compressData){
    final decodeBase64Json = base64.decode(compressData);
    final decodegZipJson = gzip.decode(decodeBase64Json);
    final originalData = utf8.decode(decodegZipJson);
    return originalData;
  }

  void helpRole() {
    /// role 0 = administrateur (peut tout faire)
    /// role 1 = user naturascan
    /// role 2 = user obstrace
    /// role 3 = user sorie pecheur
  }
}
