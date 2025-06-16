import 'dart:convert';

import 'package:naturascan/models/local/obstraceModel.dart';

import 'specieModel.dart';
import 'weatherReportModel.dart';

class SeaWasteObservation {
  String? matiere;
  String? estimatedSize;
  SpecieModel? natureDeche;
  String? color;
  bool? dechePeche;
  bool? picked;
  num? heureDebut;
  PositionS? location;
  String? vitesseNavire;
  WeatherReportModel? weatherReport;
  bool? effort;
  String? commentaires;
  bool? photos;
  List<String>? images;
  

  SeaWasteObservation(
      {this.natureDeche,
      this.estimatedSize,
      this.matiere,
      this.color,
      this.dechePeche,
      this.picked,
      this.heureDebut,
      this.location,
      this.vitesseNavire,
      this.weatherReport,
      this.effort,
      this.commentaires,
      this.photos,
      this.images
});

  SeaWasteObservation.fromJson(Map<String, dynamic> json) {
    matiere = json['matiere'];
    estimatedSize = json['estimated_size'];
    natureDeche =  json['nature_deche'] == null ? null : jsonDecode(json['nature_deche'] ?? '') != null
        ? SpecieModel.fromJson(jsonDecode(json['nature_deche']))
        : null;
    color = json['color'];
    dechePeche = json['deche_peche'] == 1 ? true : false;
    picked = json['picked']  == 1 ? true : false;
    heureDebut = json['heure_debut'];
    location = json['location'] == null ? null : jsonDecode(json['location']) != null
        ? PositionS.fromJson(jsonDecode(json['location']))
        : null;
    vitesseNavire = json['vitesse_navire'];
    weatherReport = json['weather_report'] == null ? null :
        WeatherReportModel.fromJson(jsonDecode(json['weather_report']));
    effort = json['effort'] == 1 ? true : false;
    commentaires = json['commentaires'];
    photos = json['photos'] == 1 ? true : false;
  }

 factory SeaWasteObservation.fromJson2(Map<String, dynamic> json) {
    return SeaWasteObservation(
      matiere: json['matiere'],
      estimatedSize: json['estimated_size'],
      natureDeche: json['nature_deche'] != null ? SpecieModel.fromJson2(json['nature_deche']) : null,
      color: json['color'],
      dechePeche: json['deche_peche'] == 1 ? true : false,
      picked: json['picked'] == 1 ? true : false,
      heureDebut: json['heure_debut'],
      location: json['location'] != null ? PositionS.fromJson2(json['location']) : null,
      vitesseNavire: json['vitesse_navire'],
      weatherReport: json['weather_report'] != null ? WeatherReportModel.fromJson2(json['weather_report']) : null,
      effort: json['effort'] == 1 ? true : false,
      commentaires: json['commentaires'],
      photos: json['photos'] == 1 ? true : false,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matiere'] = matiere;
    data['estimated_size'] = estimatedSize;
    data['nature_deche'] = natureDeche == null ? null : jsonEncode(natureDeche?.toJson());;
    data['color'] = color;
    data['deche_peche'] = dechePeche == true ? 1 : 0;
    data['picked'] = picked == true ? 1 : 0;
    data['heure_debut'] = heureDebut; 
    data['location'] = location == null ? null :  jsonEncode(location?.toJson());
    data['vitesse_navire'] = vitesseNavire;
    data['images'] = images;
    data['weather_report'] = weatherReport == null ? null :  jsonEncode(weatherReport?.toJson());
    data['effort'] = effort == true ? 1 : 0;
    data['commentaires'] = commentaires;
    data['photos'] = photos == true ? 1 : 0 ;
    data['images'] = images;

    return data;
  }

  
  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matiere'] = matiere;
    data['estimated_size'] = estimatedSize;
    data['nature_deche'] = natureDeche?.toJson();
    data['color'] = color;
    data['deche_peche'] = dechePeche == true ? 1 : 0;
    data['picked'] = picked == true ? 1 : 0;
    data['heure_debut'] = heureDebut; 
    data['location'] = location?.toJson2();
    data['vitesse_navire'] = vitesseNavire;
    data['images'] = images;
    data['weather_report'] = weatherReport?.toJson();
    data['effort'] = effort == true ? 1 : 0;
    data['commentaires'] = commentaires;
    data['photos'] = photos == true ? 1 : 0;
    data['images'] = images;

    return data;
  }
}
