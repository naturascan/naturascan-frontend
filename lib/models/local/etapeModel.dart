import 'dart:convert';

import 'package:naturascan/models/local/observationModel.dart';

import '../crossingPoint.dart';
import 'weatherReportModel.dart';

class EtapeModel {
  String? id;
  String? shippingId;
  String? nom;
  String? description;
  PointDePassage? pointDePassage;
  num? heureDepartPort;
  num? heureArriveePort;
  WeatherReportModel? departureWeatherReport;
  WeatherReportModel? arrivalWeatherReport;
  String? createdAt;

  EtapeModel(
      {this.id,
      this.shippingId,
      this.nom,
      this.description,
      this.pointDePassage,
      this.arrivalWeatherReport,
      this.departureWeatherReport,
      this.heureArriveePort,
      this.heureDepartPort,
      this.createdAt});

  EtapeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingId = json['shipping_id'];
    nom = json['nom'];
    description = json['description'];
            print("object qqqqqq ${json['heure_arrivee_port']}");
    heureArriveePort = json['heure_arrivee_port'];

    heureDepartPort = json['heure_depart_port'];
    pointDePassage =  json['point_de_passage'] == null ? null : jsonDecode(json['point_de_passage']) != null
        ? PointDePassage.fromJson(jsonDecode(json['point_de_passage']))
        : null;
    departureWeatherReport = json['departure_weather_report'] == null ? null :
        jsonDecode(json['departure_weather_report']) != null
            ? WeatherReportModel.fromJson(
                jsonDecode(json['departure_weather_report']))
            : null;

    arrivalWeatherReport = json['arrival_weather_report'] == null ? null : jsonDecode(json['arrival_weather_report']) != null
        ? WeatherReportModel.fromJson(
            jsonDecode(json['arrival_weather_report']))
        : null;

    createdAt = json['created_at'];
  }

  factory EtapeModel.fromJson2(Map<String, dynamic> json) {
  return EtapeModel(
    id: json['id'],
    shippingId: json['shipping_id'],
    nom: json['nom'],
    description: json['description'],
    heureArriveePort: json['heure_arrivee_port'],
    heureDepartPort: json['heure_depart_port'],
    pointDePassage: json['point_de_passage'] == null
        ? null
        : PointDePassage.fromJson2(json['point_de_passage']),
    departureWeatherReport: json['departure_weather_report'] == null
        ? null
        : WeatherReportModel.fromJson2(json['departure_weather_report']),
    arrivalWeatherReport: json['arrival_weather_report'] == null
        ? null
        : WeatherReportModel.fromJson2(json['arrival_weather_report']),
    createdAt: json['created_at'],
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipping_id'] = shippingId;
    data['nom'] = nom;
    data['description'] = description;
    data['heure_depart_port'] = heureDepartPort;
    data['heure_arrivee_port'] = heureArriveePort;
    if (pointDePassage != null) {
      data['point_de_passage'] = jsonEncode(pointDePassage?.toJson());
    }
    if (departureWeatherReport != null) {
      data['departure_weather_report'] = jsonEncode(departureWeatherReport?.toJson());
    }
    if (arrivalWeatherReport != null) {
      data['arrival_weather_report'] = jsonEncode(arrivalWeatherReport?.toJson());
    }
    data['created_at'] = createdAt;
    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipping_id'] = shippingId;
    data['nom'] = nom;
    data['description'] = description;
    data['heure_depart_port'] = heureDepartPort;
    data['heure_arrivee_port'] = heureArriveePort;
    if (pointDePassage != null) {
      data['point_de_passage'] = pointDePassage?.toJson();
    }
    if (departureWeatherReport != null) {
      data['departure_weather_report'] = departureWeatherReport?.toJson2();
    }
    if (arrivalWeatherReport != null) {
      data['arrival_weather_report'] = arrivalWeatherReport?.toJson2();
    }
    data['created_at'] = createdAt;
    return data;
  }

}
