import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:naturascan/models/local/etapeModel.dart';
import 'package:naturascan/models/local/gpsTrackModel.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'package:naturascan/models/local/zone.dart';

import 'weatherReportModel.dart';

class NaturascanModel {
  String? structure;
  ZoneModel? zone;
  String? portDepart;
  String? portArrivee;
  num? heureDepartPort;
  num? heureArriveePort;
  num? dureeSortie;
  List<UserModel>? responsable;
  List<UserModel>? observateurs;
  List<UserModel>? photographe;
  List<UserModel>? skipper;
  List<UserModel>? otherUser;
  num? nbreObservateurs;
  String? typeBateau;
  String? nomBateau;
  num? hauteurBateau;
  String? heureUtc;
  num? distanceParcourue;
  num? superficieEchantillonnee;
  String? remarqueDepart;
  String? remarqueArrivee;
  WeatherReportModel? departureWeatherReport;
  WeatherReportModel? arrivalWeatherReport;
  String? departureExtraComment;
  String? arrivalExtraComment;
  num? heureDebutObservation;
  num? heureFinObservaton;
  num? dureeObservation;
  bool? marked;
  List<EtapeModel>? etapes;
  List<ObservationModel>? observations;
  List<GpsTrackModel>? gps;

  NaturascanModel(
      {
      this.structure,
      this.zone,
      this.portDepart,
      this.portArrivee,
      this.heureDepartPort,
      this.heureArriveePort,
      this.dureeSortie,
      this.responsable,
      this.skipper,
      this.photographe,
      this.observateurs,
      this.otherUser,
      this.nbreObservateurs,
      this.typeBateau,
      this.nomBateau,
      this.hauteurBateau,
      this.heureUtc,
      this.remarqueDepart,
      this.remarqueArrivee,
      this.arrivalExtraComment,
      this.heureDebutObservation,
      this.heureFinObservaton,
      this.dureeObservation,
      this.marked,
      this.distanceParcourue,
      this.departureExtraComment,
      this.departureWeatherReport,
      this.arrivalWeatherReport,
      this.superficieEchantillonnee,
      this.etapes,
      this.observations,
      this.gps
      });

  NaturascanModel.fromJson(Map<String, dynamic> json) {
    zone = json['zone'] == null
        ? null
        : ZoneModel.fromJson(jsonDecode(json['zone'].toString()));
    portDepart = json['port_depart'];
    portArrivee = json['port_arrivee'];
    heureDepartPort = json['heure_depart_port'];
    heureArriveePort = json['heure_arrivee_port'];
    superficieEchantillonnee = json['superficie_echantillonnee'];
    dureeSortie = json['duree_sortie'];
    if(json["responsable"] == null){
      responsable = null;

    }else{
          try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["responsable"]));
      log(resp.runtimeType.toString());
      if (resp.isNotEmpty) {
        responsable = resp.map((x) => UserModel.fromJson(x)).toList();
      } else {
        responsable = <UserModel>[];
      }
    } catch (e) {
      responsable = <UserModel>[];
      if (json["responsable"] != null) {
        json["responsable"].forEach((v) {
          responsable!.add(UserModel.fromJson(jsonDecode(v)));
        });
      }
    }
    }
        if(json["skipper"] ==  null){
          skipper =  null;
        }else{
        try {
            var p = List<Map<String, dynamic>>.from(jsonDecode(json["skipper"]));

            if (p.isNotEmpty) {
              skipper = p.map((x) => UserModel.fromJson(x)).toList();
            } else {
              skipper = <UserModel>[];
            }
          } catch (e) {
            skipper = <UserModel>[];
            if (json["skipper"] != null) {
              json["skipper"].forEach((v) {
                skipper!.add(UserModel.fromJson(v));
              });
            }
          }
        }
        if(json["photographe"] == null){
          photographe = null;
        } else{
           try {
      var p = List<Map<String, dynamic>>.from(jsonDecode(json["photographe"]));

      if (p.isNotEmpty) {
        photographe = p.map((x) => UserModel.fromJson(x)).toList();
      } else {
        photographe = <UserModel>[];
      }
    } catch (e) {
      photographe = <UserModel>[];
      if (json["photographe"] != null) {
        json["photographe"].forEach((v) {
          photographe!.add(UserModel.fromJson(v));
        });
      }
    }
   }
   if(json["observateurs"] ==  null){
    observateurs =  null ;
   }else{
     try {
      var p = List<Map<String, dynamic>>.from(jsonDecode(json["observateurs"]));

      if (p.isNotEmpty) {
        observateurs = p.map((x) => UserModel.fromJson(x)).toList();
      } else {
        observateurs = <UserModel>[];
      }
    } catch (e) {
      observateurs = <UserModel>[];
      if (json["observateurs"] != null) {
        json["observateurs"].forEach((v) {
          observateurs!.add(UserModel.fromJson(v));
        });
      }
    }
   }
   if(json["other_user"] == null){
    otherUser = null;
   }else{
        try {
      var p = List<Map<String, dynamic>>.from(jsonDecode(json["other_user"]));

      if (p.isNotEmpty) {
        otherUser = p.map((x) => UserModel.fromJson(x)).toList();
      } else {
        otherUser = <UserModel>[];
      }
    } catch (e) {
      otherUser = <UserModel>[];
      if (json["other_user"] != null) {
        json["other_user"].forEach((v) {
          otherUser!.add(UserModel.fromJson(v));
        });
      }
    }
   }
    nbreObservateurs = json['nbre_observateurs'] == null
        ? null
        : int.tryParse("${json['nbre_observateurs']}") ?? 1;
    typeBateau = json['type_bateau'];
    nomBateau = json['nom_bateau'];
    heureUtc = json['heure_utc'];
    distanceParcourue = json['distance_parcourue'];
    superficieEchantillonnee = json['superficie_echantillonnee'];
    remarqueDepart = json['remarque_depart'];
    hauteurBateau = json['hauteur_bateau']; 
    heureDebutObservation = json['heure_debut_observation'];
    heureFinObservaton = json['heure_fin_observaton'];
    dureeObservation = json['duree_observation'];
    remarqueArrivee = json['remarque_arrivee'];
    if (json['departure_weather_report'] != null && json['departure_weather_report'] != '' &&
        jsonDecode(json['departure_weather_report'].toString()) != null) {
      departureWeatherReport = WeatherReportModel.fromJson(
              jsonDecode(json['departure_weather_report'].toString()));
    }
    if (json['arrival_weather_report'] != null &&
      json['arrival_weather_report'] != '' &&
        jsonDecode(json['arrival_weather_report'].toString()) != null) {
      arrivalWeatherReport = WeatherReportModel.fromJson(
              jsonDecode(json['arrival_weather_report']));
    }
    marked = json['marked'] == 0 ? false : true;    
  }

factory NaturascanModel.fromJson2(Map<String, dynamic> json) {
  return NaturascanModel(
    zone: json['zone'] == null
        ? null
        : ZoneModel.fromJson2(json['zone']),
    portDepart: json['port_depart'],
    portArrivee: json['port_arrivee'],
    heureDepartPort: json['heure_depart_port'],
    heureArriveePort: json['heure_arrivee_port'],
    superficieEchantillonnee: json['superficie_echantillonnee'],
    dureeSortie: json['duree_sortie'],
    responsable: _parseUsers(json['responsable']),
    skipper: _parseUsers(json['skipper']),
    photographe: _parseUsers(json['photographe']),
    observateurs: _parseUsers(json['observateurs']),
    otherUser: _parseUsers(json['other_user']),
    nbreObservateurs: json['nbre_observateurs'] == null
        ? null
        : int.tryParse("${json['nbre_observateurs']}") ?? 1,
    typeBateau: json['type_bateau'],
    nomBateau: json['nom_bateau'],
    heureUtc: json['heure_utc'],
    distanceParcourue: json['distance_parcourue'],
    remarqueDepart: json['remarque_depart'],
    hauteurBateau: json['hauteur_bateau'],
    heureDebutObservation: json['heure_debut_observation'],
    heureFinObservaton: json['heure_fin_observaton'],
    dureeObservation: json['duree_observation'],
    remarqueArrivee: json['remarque_arrivee'],
    departureWeatherReport: json['departure_weather_report'] != null &&
            json['departure_weather_report'] != ''
        ? WeatherReportModel.fromJson2(
            json['departure_weather_report'])
        : null,
    arrivalWeatherReport: json['arrival_weather_report'] != null &&
            json['arrival_weather_report'] != '' 
        ? WeatherReportModel.fromJson2(
            json['arrival_weather_report'])
        : null,
    etapes: json["etapes"] != null
          ? (json["etapes"] as List).map((v) => EtapeModel.fromJson2(v)).toList()
          : null,
    observations: json["observations"] != null
          ? (json["observations"] as List).map((v) => ObservationModel.fromJson2(v)).toList()
          : null,
    gps:  json["gps"] != null
          ? (json["gps"] as List).map((v) => GpsTrackModel.fromJson2(v)).toList()
          : null,
    marked: json['marked'] == 0 ? false : true,
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone'] =  zone == null ? null : jsonEncode(zone?.toJson());
    data['structure'] = structure;
    data['port_depart'] = portDepart;
    data['port_arrivee'] = portArrivee;
    data['heure_depart_port'] = heureDepartPort;
    data['heure_arrivee_port'] = heureArriveePort;
    data['hauteur_bateau'] = hauteurBateau;
    data['heure_debut_observation'] = heureDebutObservation;
    data['heure_fin_observaton'] = heureFinObservaton;
    data['duree_observation'] = dureeObservation;
    data['duree_sortie'] = dureeSortie;
    data['responsable'] = responsable == null
        ? null
        : jsonEncode(List<dynamic>.from(responsable!.map((x) => x.toJson())));
    data['skipper'] = skipper == null
        ? null
        : jsonEncode(List<dynamic>.from(skipper!.map((x) => x.toJson())));
    data['photographe'] = photographe == null
        ? null
        : jsonEncode(List<dynamic>.from(photographe!.map((x) => x.toJson())));
    data['observateurs'] = observateurs == null
        ? null
        : jsonEncode(List<dynamic>.from(observateurs!.map((x) => x.toJson())));
    data['other_user'] = otherUser == null
        ? null
        : jsonEncode(List<dynamic>.from(otherUser!.map((x) => x.toJson())));
    data['nbre_observateurs'] = nbreObservateurs;
    data['type_bateau'] = typeBateau;
    data['nom_bateau'] = nomBateau;
    data['heure_utc'] = heureUtc;
    data['distance_parcourue'] = distanceParcourue;
    data['remarque_depart'] = remarqueDepart;
    data['remarque_arrivee'] = remarqueArrivee;
    data['superficie_echantillonnee'] = superficieEchantillonnee;
    data['departure_weather_report'] =
        jsonEncode(departureWeatherReport?.toJson());
    data['arrival_weather_report'] = jsonEncode(arrivalWeatherReport?.toJson());
    data['marked'] = marked == false ? 0 : 1;
    return data;
  }

Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone'] = zone?.toJson2();
    data['structure'] = structure;
    data['port_depart'] = portDepart;
    data['port_arrivee'] = portArrivee;
    data['heure_depart_port'] = heureDepartPort;
    data['heure_arrivee_port'] = heureArriveePort;
    data['hauteur_bateau'] = hauteurBateau;
    data['heure_debut_observation'] = heureDebutObservation;
    data['heure_fin_observaton'] = heureFinObservaton;
    data['duree_observation'] = dureeObservation;
    data['duree_sortie'] = dureeSortie;
    data['responsable'] = responsable == null
        ? null
        : List<dynamic>.from(responsable!.map((x) => x.toJson2()));
    data['skipper'] = skipper == null
        ? null
        : List<dynamic>.from(skipper!.map((x) => x.toJson2()));
    data['photographe'] = photographe == null
        ? null
        : List<dynamic>.from(photographe!.map((x) => x.toJson2()));
    data['observateurs'] = observateurs == null
        ? null
        : List<dynamic>.from(observateurs!.map((x) => x.toJson2()));
    data['other_user'] = otherUser == null
        ? null
        : List<dynamic>.from(otherUser!.map((x) => x.toJson2()));
    data['nbre_observateurs'] = nbreObservateurs;
    data['type_bateau'] = typeBateau;
    data['nom_bateau'] = nomBateau;
    data['heure_utc'] = heureUtc;
    data['distance_parcourue'] = distanceParcourue;
    data['remarque_depart'] = remarqueDepart;
    data['remarque_arrivee'] = remarqueArrivee;
    data['superficie_echantillonnee'] = superficieEchantillonnee;
    data['departure_weather_report'] =
        departureWeatherReport?.toJson2();
    data['arrival_weather_report'] = arrivalWeatherReport?.toJson2();
    data['marked'] = marked == false ? 0 : 1;
    return data;
  }

}

List<UserModel>? _parseUsers(dynamic data) {
  if (data == null) return null;
  try {
    var users = List<Map<String, dynamic>>.from(data);
    return users.isNotEmpty ? users.map((x) => UserModel.fromJson2(x)).toList() : <UserModel>[];
  } catch (e) {
    if (data is List) {
      return data.map((v) => UserModel.fromJson2(v)).toList();
    }
    return <UserModel>[];
  }
}