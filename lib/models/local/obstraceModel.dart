import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/models/local/observationModel.dart';
import 'package:naturascan/models/local/prospectionModel.dart';
import 'package:naturascan/models/local/secteur.dart';
import 'package:naturascan/models/local/weatherReportModel.dart';

class ObstraceModel {
  ProspectionModel? prospection;
  ObservationTrace? traces;

  ObstraceModel({this.prospection, this.traces});

  ObstraceModel.fromJson(Map<String, dynamic> json) {
    prospection = json['prospection'] == null
        ? null
        : jsonDecode(json['prospection']) != null
            ? ProspectionModel.fromJson(jsonDecode(json['prospection']))
            : null;
    traces = json['traces'] == null
        ? null
        : jsonDecode(json['traces']) != null
            ? ObservationTrace.fromJson(jsonDecode(json['traces']))
            : null;
  }

    factory ObstraceModel.fromJson2(Map<String, dynamic> json) {
    return ObstraceModel(
      prospection: json['prospection'] == null
        ? null
        : ProspectionModel.fromJson2(json['prospection']),
      traces:  json['traces'] == null
        ? null
        : ObservationTrace.fromJson2(json['traces'])
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prospection'] = jsonEncode(prospection?.toJson());
    data['traces'] = jsonEncode(traces?.toJson());
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prospection'] = prospection?.toJson2();
    data['traces'] = traces?.toJson3();
    return data;
  }
}

class PositionS {
  MapPosition? longitude;
  MapPosition? latitude;

  PositionS({this.longitude, this.latitude});

  PositionS.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'] == null
        ? null
        : MapPosition.fromJson(jsonDecode(json['longitude']));
    latitude = json['latitude'] == null
        ? null
        : MapPosition.fromJson(jsonDecode(json['latitude']));
  }

  factory PositionS.fromJson2(Map<String, dynamic> json) {
  return PositionS(
    longitude: json['longitude'] != null ? MapPosition.fromJson2(json['longitude']) : null,
    latitude: json['latitude'] != null ? MapPosition.fromJson2(json['latitude']) : null,
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] =
        longitude == null ? null : jsonEncode(longitude?.toJson());
    data['latitude'] = latitude == null ? null : jsonEncode(latitude?.toJson());
    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude?.toJson();
    data['latitude'] = latitude?.toJson();
    return data;
  }
}

class Emergence {
  bool? emergence;
  num? dateDebut;
  num? dateFin;
  String? remark;

  Emergence({this.emergence, this.dateDebut, this.dateFin, this.remark});

  Emergence.fromJson(Map<String, dynamic> json) {
    emergence = json['emergence'] == 1 ? true : false;
    dateDebut = json['date_debut'];
    dateFin = json['date_fin'];
    remark = json['remark'];
  }

    factory Emergence.fromJson2(Map<String, dynamic> json) {
    return Emergence(
      emergence: json['emergence'] == 1 ? true : false,
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emergence'] = emergence == true ? 1 : 0;
    data['date_debut'] = dateDebut;
    data['date_fin'] = dateFin;
    data['remark'] = remark;
    return data;
  }
}

class Esclavation {
  bool? esclavation;
  num? dateDebut;
  num? dateFin;
  String? remark;

  Esclavation({this.esclavation, this.dateDebut, this.dateFin, this.remark});

  Esclavation.fromJson(Map<String, dynamic> json) {
    esclavation = json['esclavation'] == 1 ? true : false;
    dateDebut = json['date_debut'];
    dateFin = json['date_fin'];
    remark = json['remark'];
  }

  factory Esclavation.fromJson2(Map<String, dynamic> json) {
  return Esclavation(
    esclavation: json['esclavation'] == 1 ? true : false,
    dateDebut: json['date_debut'],
    dateFin: json['date_fin'],
    remark: json['remark'],
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['esclavation'] = esclavation == true ? 1 : 0;
    data['date_debut'] = dateDebut;
    data['date_fin'] = dateFin;
    data['remark'] = remark;
    return data;
  }
}

class PresenceNid {
  bool? presenNid;
  num? date;

  PresenceNid({this.presenNid, this.date});

  PresenceNid.fromJson(Map<String, dynamic> json) {
    presenNid = json['presence_nid'] == 1 ? true : false;
    date = json['date'];
  }

  factory PresenceNid.fromJson2(Map<String, dynamic> json) {
  return PresenceNid(
    presenNid: json['presence_nid'] == 1 ? true : false,
    date: json['date'],
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['presence_nid'] = presenNid == true ? 1 : 0;
    data['date'] = date;
    return data;
  }
  
}

class ObservationTrace {
  String? id;
  Secteur? secteur;
  SousSecteur? sousSecteur;
  Plage? plage;
  num? heure;
  bool? suivi;
  WeatherReportModel? weatherReport;
  String? remark;
  PositionS? location;
  String? photos;
  PresenceNid? presenceNid;
  Emergence? emergence;
  Esclavation? esclavation;
  String? prospectionId;
  String? shippingId;
  String? createdAt;

  ObservationTrace(
      {this.id,
      this.secteur,
      this.presenceNid,
      this.emergence,
      this.esclavation,
      this.sousSecteur,
      this.plage,
      this.heure,
      this.suivi,
      this.weatherReport,
      this.remark,
      this.location,
      this.photos,
      this.prospectionId,
      this.shippingId,
      this.createdAt});

  ObservationTrace.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secteur = json['secteur'] == null
        ? null
        : jsonDecode(json['secteur']) != null
            ? Secteur.fromJson(jsonDecode(json['secteur']))
            : null;
    sousSecteur = json['sous_secteur'] == null
        ? null
        : jsonDecode(json['sous_secteur']) != null
            ? SousSecteur.fromJson(jsonDecode(json['sous_secteur']))
            : null;
    plage = json['plage'] == null
        ? null
        : jsonDecode(json['plage']) != null
            ? Plage.fromJson(jsonDecode(json['plage']))
            : null;
    heure = json['heure'];
    suivi = json['suivi'] == 0 ? false : true;
    remark = json['remark'];
    weatherReport = json['weather_report'] == null
        ? null
        : jsonDecode(json['weather_report']) != null
            ? WeatherReportModel.fromJson(jsonDecode(json['weather_report']))
            : null;
    location = json['location'] == null
        ? null
        : jsonDecode(json['location']) != null
            ? PositionS.fromJson(jsonDecode(json['location']))
            : null;
    photos = json['photos']; 
    presenceNid = json['presence_nid'] == null
        ? null
        : jsonDecode(json['presence_nid']) != null
            ? PresenceNid.fromJson(jsonDecode(json['presence_nid']))
            : null;
    emergence = json['emergence'] == null
        ? null
        : jsonDecode(json['emergence']) != null
            ? Emergence.fromJson(jsonDecode(json['emergence']))
            : null;
    esclavation = json['esclavation'] == null
        ? null
        : jsonDecode(json['esclavation']) != null
            ? Esclavation.fromJson(jsonDecode(json['esclavation']))
            : null;
    prospectionId = json['prospection_id'];
    shippingId = json['shipping_id'];
    createdAt = json['created_at'];
  }

 factory ObservationTrace.fromJson2(Map<String, dynamic> json) {
    return ObservationTrace(
      id: json['id'],
      secteur: json['secteur'] == null
          ? null
          : Secteur.fromJson2(json['secteur']),
      sousSecteur: json['sous_secteur'] == null
          ? null
          : SousSecteur.fromJson2(json['sous_secteur']),
      plage: json['plage'] == null ? null : Plage.fromJson2(json['plage']),
      heure: json['heure'],
      suivi: json['suivi'] == 0 ? false : true,
      remark: json['remark'],
      weatherReport: json['weather_report'] == null
          ? null
          : WeatherReportModel.fromJson2(json['weather_report']),
      location: json['location'] == null
          ? null
          : PositionS.fromJson2(json['location']),
      photos: json['photos'],
      presenceNid: json['presence_nid'] == null
          ? null
          : PresenceNid.fromJson2(json['presence_nid']),
      emergence: json['emergence'] == null
          ? null
          : Emergence.fromJson2(json['emergence']),
      esclavation: json['esclavation'] == null
          ? null
          : Esclavation.fromJson2(json['esclavation']),
      prospectionId: json['prospection_id'],
      shippingId: json['shipping_id'],
      createdAt: json['created_at'],
    );
  }

  Future<Map<String, dynamic>> toJson2() async{
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secteur'] = secteur == null ? null : jsonEncode(secteur?.toJson());
    data['sous_secteur'] =
        sousSecteur == null ? null : jsonEncode(sousSecteur?.toJson());
    data['plage'] = plage == null ? null : jsonEncode(plage?.toJson());
    data['suivi'] = suivi == true ? 1 : 0;
    data['heure'] = heure;
    data['weather_report'] =
        weatherReport == null ? null : jsonEncode(weatherReport?.toJson());
    data['remark'] = remark;
    data['location'] = location == null ? null : jsonEncode(location?.toJson());
    data['presence_nid'] =
        presenceNid == null ? null : jsonEncode(presenceNid?.toJson());
    data['emergence'] =
        emergence == null ? null : jsonEncode(emergence?.toJson());
    data['esclavation'] = esclavation == null
        ? null
        : jsonEncode(esclavation?.toJson()); 
          String? path;
        if(photos != null){
 try {
     String normalPh = Utils().deCompressJson(photos!);
    Uint8List ph = base64Decode(normalPh);
     path =  await Utils().storeImage(ph);
    data['photos'] = path;
    } catch (e) {
      print('messssaee $photos');
        final imageFile = File(photos!).readAsBytesSync();
      data['photos'] = Utils().compressString(base64Encode(imageFile));
            print('messssaee ${data['photos']}');
    }
        }
    // data['photos'] = photos == null ? null :  Utils().compressString(base64Encode(photos!));
    data['prospection_id'] = prospectionId;
    data['shipping_id'] = shippingId;
    data['created_at'] = createdAt;

    return data;
  }

 Map<String, dynamic> toJson() {
      print('messaephoto ');
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secteur'] = secteur == null ? null : jsonEncode(secteur?.toJson());
    data['sous_secteur'] =
        sousSecteur == null ? null : jsonEncode(sousSecteur?.toJson());
    data['plage'] = plage == null ? null : jsonEncode(plage?.toJson());
    data['suivi'] = suivi == true ? 1 : 0;
    data['heure'] = heure;
    data['weather_report'] =
        weatherReport == null ? null : jsonEncode(weatherReport?.toJson());
    data['remark'] = remark;
    data['location'] = location == null ? null : jsonEncode(location?.toJson());
    data['presence_nid'] =
        presenceNid == null ? null : jsonEncode(presenceNid?.toJson());
    data['emergence'] =
        emergence == null ? null : jsonEncode(emergence?.toJson());
    data['esclavation'] = esclavation == null
        ? null
        : jsonEncode(esclavation?.toJson()); // Handle null location gracefully    
    data['photos'] = photos;
    data['prospection_id'] = prospectionId;
    data['shipping_id'] = shippingId;
    data['created_at'] = createdAt;
    return data;
  }

 Map<String, dynamic> toJson3() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secteur'] = secteur?.toJson2();
    data['sous_secteur'] = sousSecteur?.toJson2();
    data['plage'] = plage?.toJson();
    data['suivi'] = suivi == true ? 1 : 0;
    data['heure'] = heure;
    data['weather_report'] = weatherReport?.toJson2();
    data['remark'] = remark;
    data['location'] = location?.toJson2();
    data['presence_nid'] = presenceNid?.toJson();
    data['emergence'] = emergence?.toJson();
    data['esclavation'] = esclavation?.toJson(); 
    log('presencenid   ${presenceNid?.toJson()}');
        if(photos != null){
 try {
        final imageFile = File(photos!).readAsBytesSync();
      data['photos'] = Utils().compressString(base64Encode(imageFile));
    } catch (e) {
      data['photos'] = photos;
    }
        }
    // data['photos'] = photos == null ? null : base64Encode(photos!);
    data['prospection_id'] = prospectionId;
    data['shipping_id'] = shippingId;
    data['created_at'] = createdAt;
    return data;
  }

}
