import 'dart:convert';
import 'dart:developer';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/models/local/gpsTrackModel.dart';
import 'package:naturascan/models/local/obstraceModel.dart';
import 'package:naturascan/models/local/secteur.dart';
import 'package:naturascan/models/local/userModel.dart';
import 'weatherReportModel.dart';

class ProspectionModel {
  String? id;
  Secteur? secteur;
  SousSecteur? sousSecteur;
  Plage? plage;
  String? mode;
  num? heureDebut;
  num? heureFin;
  num? dureeSortie;
  PositionS? end1;
  PositionS? end2;
  num? nbreObservateurs;
  List<UserModel?>? referents;
  List<UserModel?>? patrouilleurs;
  bool? suivi;
  WeatherReportModel? weatherReport;
  List<ObservationTrace?>? traces;
  List<GpsTrackModel>? gps;
  String? remark1;
  String? remark2;

  ProspectionModel(
      {
      this.id,
      this.secteur,
      this.sousSecteur,
      this.mode,
      this.plage,
      this.end1,
      this.end2,
      this.heureDebut,
      this.heureFin,
      this.dureeSortie,
      this.nbreObservateurs,
      this.referents,
      this.patrouilleurs,
      this.suivi,
      this.weatherReport,
      this.traces,
      this.gps,
      this.remark1,
      this.remark2
      });

  ProspectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
     secteur =  json['secteur'] == null ? null : jsonDecode(json['secteur']) != null
        ? Secteur.fromJson(jsonDecode(json['secteur']))
        : null;    
     sousSecteur =  json['sous_secteur'] == null ? null : jsonDecode(json['sous_secteur']) != null
        ? SousSecteur.fromJson(jsonDecode(json['sous_secteur']))
        : null;   
     plage =  json['plage'] == null ? null : jsonDecode(json['plage']) != null
        ? Plage.fromJson(jsonDecode(json['plage']))
        : null;
    mode = json['mode']== null ? null : Utils().getmodeProspection(json['mode']);
    end1 =  json['end1'] == null ? null : jsonDecode(json['end1']) != null
        ? PositionS.fromJson(jsonDecode(json['end1']))
        : null;
    end2 =  json['end2'] == null ? null : jsonDecode(json['end2']) != null
        ? PositionS.fromJson(jsonDecode(json['end2']))
        : null;
    nbreObservateurs = json['nbre_observateurs'];
    try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["gps"]));
      if (resp.isNotEmpty) {
        gps = resp.map((x) => GpsTrackModel.fromJson(x)).toList();
      } else {
        gps = <GpsTrackModel>[];
      }
    } catch (e) {
      gps = <GpsTrackModel>[];
      if (json["gps"] != null) {
        json["gps"].forEach((v) {
          gps!.add(GpsTrackModel.fromJson(jsonDecode(v)));
        });
      }
    }
        try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["referents"]));
      if (resp.isNotEmpty) {
        referents = resp.map((x) => UserModel.fromJson(x)).toList();
      } else {
        referents = <UserModel>[];
      }
    } catch (e) {
      referents = <UserModel>[];
      if (json["referents"] != null) {
        json["referents"].forEach((v) {
          referents!.add(UserModel.fromJson(jsonDecode(v)));
        });
      }
    }
  try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["patrouilleurs"]));
      if (resp.isNotEmpty) {
        patrouilleurs = resp.map((x) => UserModel.fromJson(x)).toList();
      } else {
        patrouilleurs = <UserModel>[];
      }
    } catch (e) {
      patrouilleurs = <UserModel>[];
      if (json["patrouilleurs"] != null) {
        json["patrouilleurs"].forEach((v) {
          patrouilleurs!.add(UserModel.fromJson(jsonDecode(v)));
        });
      }
    }
    suivi = json['suivi'] == 0 ? false : true;
     heureDebut = json['heure_debut'];
     heureFin = json['heure_fin'];
     dureeSortie = json['duree_sortie'];

    weatherReport = json['weather_report'] == null ? null :
        jsonDecode(json['weather_report']) != null
            ? WeatherReportModel.fromJson(
                jsonDecode(json['weather_report']))
            : null;
     try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["traces"]));
      if (resp.isNotEmpty) {
        traces = resp.map((x) => ObservationTrace.fromJson(x)).toList();
      } else {
        traces = <ObservationTrace>[];
      }
    } catch (e) {
      traces = <ObservationTrace>[];
      if (json["traces"] != null) {
        json["traces"].forEach((v) {
          traces!.add(ObservationTrace.fromJson(jsonDecode(v)));
        });
      }
    }
   remark1 = json['remark1'];
   remark2 = json['remark2'];
  }

factory ProspectionModel.fromJson2(Map<String, dynamic> json) {
  return ProspectionModel(
    id: json['id'],
    secteur: json['secteur'] != null
        ? Secteur.fromJson2(json['secteur'])
        : null,
    sousSecteur: json['sous_secteur'] != null
        ? SousSecteur.fromJson2(json['sous_secteur'])
        : null,
    plage: json['plage'] != null ? Plage.fromJson2(json['plage']) : null,
    mode: json['mode']== null ? null : Utils().getmodeProspection(json['mode']),
    end1: json['end1'] != null ? PositionS.fromJson2(json['end1']) : null,
    end2: json['end2'] != null ? PositionS.fromJson2(json['end2']) : null,
    nbreObservateurs: json['nbre_observateurs'],
    gps:  json['gps']  != null ?  List<Map<String, dynamic>>.from(json['gps']).map((x) => GpsTrackModel.fromJson2(x)).toList() : null,
    referents: json['referents']  != null ?  List<Map<String, dynamic>>.from(json['referents']).map((x) => UserModel.fromJson2(x)).toList() : null,
    patrouilleurs : json['patrouilleurs']  != null ?  List<Map<String, dynamic>>.from(json['patrouilleurs']).map((x) => UserModel.fromJson2(x)).toList() : null,
    suivi: json['suivi'] == 0 ? false : true,
    heureDebut: json['heure_debut'],
    heureFin: json['heure_fin'],
    dureeSortie: json['duree_sortie'],
    weatherReport: json['weather_report'] != null
        ? WeatherReportModel.fromJson2(json['weather_report'])
        : null,
    traces: json['traces']  != null ?  List<Map<String, dynamic>>.from(json['traces']).map((x) => ObservationTrace.fromJson2(x)).toList() : null,
    remark1: json['remark1'],
    remark2: json['remark2'],
  );
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
  try{
      data['id'] = id;
    data['secteur'] = secteur == null ? null : jsonEncode(secteur?.toJson());
    data['sous_secteur'] = sousSecteur == null ? null : jsonEncode(sousSecteur?.toJson());
    data['plage'] = plage == null ? null : jsonEncode(plage?.toJson());
    data['mode'] = mode ==  null ? null :  Utils().getmodeProspection(mode.toString());
    data['end1'] = end1 == null ? null : jsonEncode(end1?.toJson());
    data['end2'] = end2 == null ? null : jsonEncode(end2?.toJson());
    data['nbre_observateurs'] = nbreObservateurs;
    data['referents'] = referents == null
        ? null
        : jsonEncode(List<dynamic>.from(referents!.map((x) => x?.toJson())));
    data['patrouilleurs'] = patrouilleurs == null
        ? null
        : jsonEncode(List<dynamic>.from(patrouilleurs!.map((x) => x?.toJson())));
    data['suivi'] = suivi== true ? 1 : 0;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['duree_sortie'] = dureeSortie;
    data['weather_report'] = jsonEncode(weatherReport?.toJson());
    data['traces'] = traces == null
        ? null
        : jsonEncode(List<dynamic>.from(traces!.map((x) => x?.toJson())));
    data['remark1'] = remark1;
    data['remark2'] = remark2;
  }catch(e){
    print("le pb json1 ^$e");

  }
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
  try{
        data['id'] = id;
    data['secteur'] = secteur?.toJson2();
    data['sous_secteur'] = sousSecteur?.toJson2();
    data['plage'] = plage?.toJson();
    data['mode'] =  mode ==  null ? null :  Utils().getmodeProspection(mode.toString());
    data['end1'] = end1?.toJson2();
    data['end2'] = end2?.toJson2();
    data['nbre_observateurs'] = nbreObservateurs;
    data['referents'] = referents == null
        ? null
        : List<dynamic>.from(referents!.map((x) => x?.toJson2()));
    data['patrouilleurs'] = patrouilleurs == null
        ? null
        : List<dynamic>.from(patrouilleurs!.map((x) => x?.toJson2()));
    log('prsopsection ${data['patrouilleurs']}');
    data['suivi'] = suivi== true ? 1 : 0;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['duree_sortie'] = dureeSortie;
    data['weather_report'] = weatherReport?.toJson2();
    data['traces'] = traces == null
        ? null
        : List<dynamic>.from(traces!.map((x) => x?.toJson()));
    data['remark1'] = remark1;
    data['remark2'] = remark2;
  }catch(e){
    print("le pb json2 ^$e");
  }
    return data;
  }

}



