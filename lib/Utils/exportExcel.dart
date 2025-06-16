/*

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naturascan/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:excel/excel.dart' as p_excel;

import '../models/local/etapeModel.dart';
import '../models/local/observationModel.dart';
import '../models/local/userModel.dart';

class ExportExcel {
  Future saveAndShare(byte, String title) async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final image = File('${directory.path}/$title');
    image.writeAsBytesSync(byte);
    await Share.shareFiles([image.path]);
  }

  exportAll() async {
    var excel = p_excel.Excel.createExcel();
    // await exportUserModelToExcel(excel);
    await exportEtapeModelToExcel(excel);
    await exportObservationModelToExcel(excel);
    var bytes = excel.encode();
    var date = DateTime.now()
        .toIso8601String()
        .replaceAll(":", "-")
        .replaceAll(".", "-");
    saveAndShare(bytes, 'naturascan-$date.xlsx');
  }

  exportUserModelToExcel(p_excel.Excel excel) async {
    var sheet = excel['Utilisateur'];
    // titres de colonnes
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = const p_excel.TextCellValue('Noms');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = const p_excel.TextCellValue('ID');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = const p_excel.TextCellValue('Name');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = const p_excel.TextCellValue('Firstname');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = const p_excel.TextCellValue('Email');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = const p_excel.TextCellValue('Mobile Number');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = const p_excel.TextCellValue('Address');

    // Remplir les données de l'utilisateur
    List<UserModel> users = await Future.value();
    for (var user in users) {
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
          .value = p_excel.TextCellValue(user.id.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
          .value = p_excel.TextCellValue(user.name!);
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
          .value = p_excel.TextCellValue(user.firstname!);
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1))
          .value = p_excel.TextCellValue(user.email!);
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1))
          .value = p_excel.TextCellValue(user.mobileNumber!);
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1))
          .value = p_excel.TextCellValue(user.address!);
    }
  }

  Future<void> exportEtapeModelToExcel(p_excel.Excel excel) async {
    var sheet = excel["Etapes"];
    List<EtapeModel> etapes = await etapeController.fetchEtapes();

    // Ajouter les titres de colonnes
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = const p_excel.TextCellValue('ID');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = const p_excel.TextCellValue('Shipping ID');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = const p_excel.TextCellValue('Nom');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = const p_excel.TextCellValue('Description');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = const p_excel.TextCellValue('Heure Depart Port');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = const p_excel.TextCellValue('Heure Arrivee Port');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
        .value = const p_excel.TextCellValue('Departure Sea State');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
        .value = const p_excel.TextCellValue('Departure Cloud Cover');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0))
        .value = const p_excel.TextCellValue('Departure Visibility');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0))
        .value = const p_excel.TextCellValue('Departure Wind Force');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0))
        .value = const p_excel.TextCellValue('Departure Wind Direction');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0))
        .value = const p_excel.TextCellValue('Departure Wind Speed');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0))
        .value = const p_excel.TextCellValue('Arrival Sea State');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0))
        .value = const p_excel.TextCellValue('Arrival Cloud Cover');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: 0))
        .value = const p_excel.TextCellValue('Arrival Visibility');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: 0))
        .value = const p_excel.TextCellValue('Arrival Wind Force');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: 0))
        .value = const p_excel.TextCellValue('Arrival Wind Direction');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: 0))
        .value = const p_excel.TextCellValue('Arrival Wind Speed');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: 0))
        .value = const p_excel.TextCellValue('Point de Passage Nom');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: 0))
        .value = const p_excel.TextCellValue('Point de Passage Latitude');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: 0))
        .value = const p_excel.TextCellValue('Point de Passage Longitude');

    for (var etape in etapes) {
      // Remplir les données de l'étape
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.id.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.shippingId.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.nom ?? "");
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.description ?? "");
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.heureDepartPort ?? "");
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.heureArriveePort ?? "");
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1))
          .value = p_excel.TextCellValue(etape
              .departureWeatherReport?.seaState ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1))
          .value = p_excel.TextCellValue(etape
              .departureWeatherReport?.cloudCover ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 1))
          .value = p_excel.TextCellValue(etape
              .departureWeatherReport?.visibility ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 1))
          .value = p_excel.TextCellValue(etape
              .departureWeatherReport?.windForce ??
          '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 10, rowIndex: 1))
              .value =
          p_excel.TextCellValue(
              etape.departureWeatherReport?.windDirection ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 11, rowIndex: 1))
              .value =
          p_excel.TextCellValue(etape.departureWeatherReport?.windSpeed ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 12, rowIndex: 1))
              .value =
          p_excel.TextCellValue(etape.arrivalWeatherReport?.seaState ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 13, rowIndex: 1))
              .value =
          p_excel.TextCellValue(etape.arrivalWeatherReport?.cloudCover ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 14, rowIndex: 1))
              .value =
          p_excel.TextCellValue(etape.arrivalWeatherReport?.visibility ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 15, rowIndex: 1))
              .value =
          p_excel.TextCellValue(etape.arrivalWeatherReport?.windForce ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 16, rowIndex: 1))
              .value =
          p_excel.TextCellValue(
              etape.arrivalWeatherReport?.windDirection ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 17, rowIndex: 1))
              .value =
          p_excel.TextCellValue(etape.arrivalWeatherReport?.windSpeed ?? '');
      sheet
          .cell(
              p_excel.CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: 1))
          .value = p_excel.TextCellValue(etape.pointDePassage?.nom ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 19, rowIndex: 1))
              .value =
          p_excel.TextCellValue(
              etape.pointDePassage?.latitude.toString() ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 20, rowIndex: 1))
              .value =
          p_excel.TextCellValue(
              etape.pointDePassage?.longitude.toString() ?? '');
    }
  }

  Future<void> exportObservationModelToExcel(p_excel.Excel excel) async {
    var sheet = excel["Observation"];
    List<ObservationModel> observations =
        await observationController.fetchObservations();

    // Ajouter les titres de colonnes
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = const p_excel.TextCellValue('ID');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = const p_excel.TextCellValue('Shipping ID');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = const p_excel.TextCellValue('Date');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = const p_excel.TextCellValue('Start Time');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = const p_excel.TextCellValue('End Time');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = const p_excel.TextCellValue('Start Latitude (Degrees)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
        .value = const p_excel.TextCellValue('Start Latitude (Decimal)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
        .value = const p_excel.TextCellValue('Start Longitude (Degrees)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0))
        .value = const p_excel.TextCellValue('Start Longitude (Decimal)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0))
        .value = const p_excel.TextCellValue('End Latitude (Degrees)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0))
        .value = const p_excel.TextCellValue('End Latitude (Decimal)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0))
        .value = const p_excel.TextCellValue('End Longitude (Degrees)');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0))
        .value = const p_excel.TextCellValue('End Longitude (Decimal)');
    // Ajoutez les autres titres de colonnes pour les champs restants de votre modèle ObservationModel
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0))
        .value = const p_excel.TextCellValue('Species Common Name');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: 0))
        .value = const p_excel.TextCellValue('Species Scientific Name');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: 0))
        .value = const p_excel.TextCellValue('Sea State');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: 0))
        .value = const p_excel.TextCellValue('Visibility');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: 0))
        .value = const p_excel.TextCellValue('Cloud Cover');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: 0))
        .value = const p_excel.TextCellValue('Wind Force');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: 0))
        .value = const p_excel.TextCellValue('Wind Direction');
    sheet
        .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: 0))
        .value = const p_excel.TextCellValue('Wind Speed');

    for (var observation in observations) {
      // Remplir les données de l'observation
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.id.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.shippingId.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.date.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.heureDebut.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.heureFin.toString());
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1))
          .value = p_excel.TextCellValue(observation
              .latitudeDebut?.degMinSec ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.latitudeDebut?.degDec
              ?.toString() ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1))
          .value = p_excel.TextCellValue(observation
              .longitudeDebut?.degMinSec ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 1))
          .value = p_excel.TextCellValue(observation.longitudeDebut?.degDec
              ?.toString() ??
          '');
      sheet
          .cell(p_excel.CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 1))
          .value = p_excel.TextCellValue(observation
              .latitudeFin?.degMinSec ??
          '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 10, rowIndex: 1))
              .value =
          p_excel.TextCellValue(
              observation.latitudeFin?.degDec?.toString() ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 11, rowIndex: 1))
              .value =
          p_excel.TextCellValue(observation.longitudeFin?.degMinSec ?? '');
      sheet
              .cell(p_excel.CellIndex.indexByColumnRow(
                  columnIndex: 12, rowIndex: 1))
              .value =
          p_excel.TextCellValue(
              observation.longitudeFin?.degDec?.toString() ?? '');

      // Pour SpecieModel
      if (observation.observationType != null) {
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 13, rowIndex: 1))
                .value =
            p_excel.TextCellValue(
                observation.observationType!.commonName ?? '');
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 14, rowIndex: 1))
                .value =
            p_excel.TextCellValue(
                observation.observationType!.scientificName ?? '');
      }

      // Pour WeatherReportModel
      if (observation.weatherReport != null) {
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 15, rowIndex: 1))
                .value =
            p_excel.TextCellValue(observation.weatherReport!.seaState ?? '');
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 16, rowIndex: 1))
                .value =
            p_excel.TextCellValue(observation.weatherReport!.cloudCover ?? '');

        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 17, rowIndex: 1))
                .value =
            p_excel.TextCellValue(observation.weatherReport!.visibility ?? '');
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 18, rowIndex: 1))
                .value =
            p_excel.TextCellValue(observation.weatherReport!.windForce ?? '');
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 19, rowIndex: 1))
                .value =
            p_excel.TextCellValue(
                observation.weatherReport!.windDirection ?? '');
        sheet
                .cell(p_excel.CellIndex.indexByColumnRow(
                    columnIndex: 20, rowIndex: 1))
                .value =
            p_excel.TextCellValue(observation.weatherReport!.windSpeed ?? '');
      }
    }
  }
}

*/