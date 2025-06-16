import 'dart:convert';

import 'package:naturascan/models/local/obstraceModel.dart';

import 'specieModel.dart';
import 'weatherReportModel.dart';

class SeaBirdObservation {
  SpecieModel? espece;
  num? nbreEstime;
  bool? presenceJeune;
  String? etatGroupe;
  String? comportement;
  String? reactionBateau;
  String? distanceEstimee;
  String? especesAssociees;
  num? heureDebut;
  num? heureFin;
  String? duree;
  PositionS? locationD;
  PositionS? locationF;
  String? vitesseNavire;
  WeatherReportModel? weatherReport;
  bool? activitesHumainesAssociees;
  String? activitesHumainesAssocieesPrecision;
  bool? effort;
  String? commentaires;
  bool? photos;
  List<String>? images;

  

  SeaBirdObservation(
      {
        this.espece,
        this.nbreEstime,
        this.presenceJeune,
        this.etatGroupe,
        this.comportement,
        this.reactionBateau,
        this.distanceEstimee,
        this.especesAssociees,
        this.heureDebut,
        this.duree,
        this.heureFin,
        this.locationD,
        this.locationF,
        this.vitesseNavire,
        this.weatherReport,
        this.activitesHumainesAssociees,
        this.activitesHumainesAssocieesPrecision,
        this.effort,
        this.commentaires,
        this.photos,
        this.images
      });

  SeaBirdObservation.fromJson(Map<String, dynamic> json) {
    espece = json['espece'] == null ? null : jsonDecode(json['espece'] ?? '') != null
        ? SpecieModel.fromJson(jsonDecode(json['espece']))
        : null;
    nbreEstime = json['nbre_estime'];
    presenceJeune = json['presence_jeune'] == 1 ? true : false;
    etatGroupe = json['etat_groupe'];
    comportement = json['comportement'];
    reactionBateau = json['reaction_bateau'];
    distanceEstimee = json['distance_estimee'];
    especesAssociees = json['especes_associees'];
    heureDebut = json['heure_debut'];
    heureFin = json['heure_fin'];
    duree = json['duree'];
    locationD = json['location_d'] == null ? null : jsonDecode(json['location_d'] ?? '') != null
        ? PositionS.fromJson(jsonDecode(json['location_d']))
        : null;
    locationF = json['location_f'] == null ? null : jsonDecode(json['location_f'] ?? '') != null
        ? PositionS.fromJson(jsonDecode(json['location_f']))
        : null;
    vitesseNavire = json['vitesse_navire'];
    print("object  ssssss ${json['weather_report']}");
    weatherReport = json['weather_report'] == null ? null : jsonDecode(json['weather_report'] ?? '') != null
        ? WeatherReportModel.fromJson(jsonDecode(json['weather_report']))
        : null;
    activitesHumainesAssociees = json['activites_humaines_associees']  == 1 ? true : false;
    activitesHumainesAssocieesPrecision = json['activites_humaines_associees_precision'];
    effort = json['effort'] == 1 ? true : false;
    commentaires = json['commentaires'];
    photos = json['photos'] == 1 ? true : false;
    images = json['images'];   
  }

   factory SeaBirdObservation.fromJson2(Map<String, dynamic> json) {
    return SeaBirdObservation(
      espece: json['espece'] == null ? null : SpecieModel.fromJson2(json['espece']),
      nbreEstime: json['nbre_estime'],
      presenceJeune: json['presence_jeune'] == 1 ? true : false,
      etatGroupe: json['etat_groupe'],
      comportement: json['comportement'],
      reactionBateau: json['reaction_bateau'],
      distanceEstimee: json['distance_estimee'],
      especesAssociees: json['especes_associees'],
      heureDebut: json['heure_debut'],
      heureFin: json['heure_fin'],
      duree: json['duree'],
      locationD: json['location_d'] == null ? null : PositionS.fromJson2(json['location_d']),
      locationF: json['location_f'] == null ? null : PositionS.fromJson2(json['location_f']),
      vitesseNavire: json['vitesse_navire'],
      weatherReport: json['weather_report'] == null ? null : WeatherReportModel.fromJson2(json['weather_report']),
      activitesHumainesAssociees: json['activites_humaines_associees']  == 1 ? true : false,
      activitesHumainesAssocieesPrecision: json['activites_humaines_associees_precision'],
      effort: json['effort'] == 1 ? true : false,
      commentaires: json['commentaires'],
      photos: json['photos'] == 1 ? true : false,
      images: json['images'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['espece'] = espece == null ? null : jsonEncode(espece?.toJson());
    data['nbre_estime'] = nbreEstime;
    data['presence_jeune'] = presenceJeune == true ? 1 : 0;
    data['etat_groupe'] = etatGroupe;
    data['comportement'] = comportement;
    data['reaction_bateau'] = reactionBateau;
    data['distance_estimee'] = distanceEstimee;
    data['especes_associees'] = especesAssociees;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['duree'] = duree;
    data['location_d'] = locationD == null ? null : jsonEncode(locationD?.toJson());
    data['location_f'] = locationF ==  null ? null :  jsonEncode(locationF?.toJson());
    data['vitesse_navire'] = vitesseNavire;    
    data['weather_report'] = weatherReport == null ? null :  jsonEncode(weatherReport?.toJson());
    data['activites_humaines_associees'] = activitesHumainesAssociees == true ? 1 : 0;
    data['activites_humaines_associees_precision'] = activitesHumainesAssocieesPrecision;
    data['effort'] = effort == true ? 1 : 0;
    data['commentaires'] = commentaires;
    data['photos'] = photos == true ? 1 : 0;
    data['images'] = images;
    
     return data;
  }


  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['espece'] = espece?.toJson();
    data['nbre_estime'] = nbreEstime;
    data['presence_jeune'] = presenceJeune == true ? 1 : 0;
    data['etat_groupe'] = etatGroupe;
    data['comportement'] = comportement;
    data['reaction_bateau'] = reactionBateau;
    data['distance_estimee'] = distanceEstimee;
    data['especes_associees'] = especesAssociees;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['duree'] = duree;
    data['location_d'] = locationD?.toJson2();
    data['location_f'] = locationF?.toJson2();
    data['vitesse_navire'] = vitesseNavire;    
    data['weather_report'] = weatherReport?.toJson();
    data['activites_humaines_associees'] = activitesHumainesAssociees == true ? 1 : 0;
    data['activites_humaines_associees_precision'] = activitesHumainesAssocieesPrecision;
    data['effort'] = effort == true ? 1 : 0;
    data['commentaires'] = commentaires;
    data['photos'] = photos == true ? 1 : 0;
    data['images'] = images;
    
     return data;
  }

}

