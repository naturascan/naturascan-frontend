import 'dart:convert';

import 'package:naturascan/models/local/obstraceModel.dart';

import 'specieModel.dart';
import 'weatherReportModel.dart';

class SeaAnimalObservation {
  SpecieModel? espece;
  String? taille;
  num? nbreEstime;
  num? nbreMini;
  num? nbreMaxi;
  bool? nbreJeunes;
  bool? nbreNouveauNe;
  String? structureGroupe;
  bool? sousGroup;
  num? nbreSousGroupes;
  num? nbreIndivSousGroupe;
  String? comportementSurface;
  String? vitesse;
  String? reactionBateau;
  String? distanceEstimee;
  String? gisement;
  String? elementDetection;
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

  

  SeaAnimalObservation(
      {
        this.espece,
        this.taille,
        this.nbreEstime,
        this.nbreMini,
        this.nbreMaxi,
        this.nbreJeunes,
        this.nbreNouveauNe,
        this.structureGroupe,
        this.sousGroup,
        this.nbreSousGroupes,
        this.nbreIndivSousGroupe,
        this.comportementSurface,
        this.vitesse,
        this.reactionBateau,
        this.distanceEstimee,
        this.gisement,
        this.elementDetection,
        this.especesAssociees,
        this.heureDebut,
        this.heureFin,
        this.duree,
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

  SeaAnimalObservation.fromJson(Map<String, dynamic> json) {
    espece = json['espece'] == null ? null : jsonDecode(json['espece'] ?? '') != null
        ? SpecieModel.fromJson(jsonDecode(json['espece']))
        : null;
    taille = json['taille'];
    nbreEstime = json['nbre_estime'];
    nbreMini = json['nbre_mini'];
    nbreMaxi = json['nbre_maxi'];
    nbreJeunes = json['nbre_jeunes']== 1 ? true : false;
    nbreNouveauNe = json['nbre_nouveau_ne'] == 1 ? true : false;
    structureGroupe = json['structure_groupe'];
    sousGroup = json['sous_group'];
    nbreSousGroupes = json['nbre_sous_groupes'];
    nbreIndivSousGroupe = json['nbre_indiv_sous_groupe'];
    comportementSurface = json['comportement_surface'];
    vitesse = json['vitesse'];
    reactionBateau = json['reaction_bateau'];
    distanceEstimee = json['distance_estimee'];
    gisement = json['gisement'];
    elementDetection = json['element_detection'];
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
    if (json['weather_report'] == null) {
      weatherReport = null;
    } else {
      weatherReport = jsonDecode(json['weather_report'] ?? '') != null
        ? WeatherReportModel.fromJson(jsonDecode(json['weather_report']))
        : null;
    }
    activitesHumainesAssociees = json['activites_humaines_associees'] == 1 ? true : false;
    activitesHumainesAssocieesPrecision = json['activites_humaines_associees_precision'];
    effort = json['effort'] == 1 ? true : false;
    commentaires = json['commentaires'];
    photos = json['photos'] == 1 ? true : false;
    images = json['images'];   
  }


  factory SeaAnimalObservation.fromJson2(Map<String, dynamic> json) {
    return SeaAnimalObservation(
      espece: json['espece'] == null ? null : SpecieModel.fromJson2(json['espece']),
      taille: json['taille'],
      nbreEstime: json['nbre_estime'],
      nbreMini: json['nbre_mini'],
      nbreMaxi: json['nbre_maxi'],
      nbreJeunes: json['nbre_jeunes']== 1 ? true : false,
      nbreNouveauNe: json['nbre_nouveau_ne'] == 1 ? true : false,
      structureGroupe: json['structure_groupe'],
      sousGroup: json['sous_group'],
      nbreSousGroupes: json['nbre_sous_groupes'],
      nbreIndivSousGroupe: json['nbre_indiv_sous_groupe'],
      comportementSurface: json['comportement_surface'],
      vitesse: json['vitesse'],
      reactionBateau: json['reaction_bateau'],
      distanceEstimee: json['distance_estimee'],
      gisement: json['gisement'],
      elementDetection: json['element_detection'],
      especesAssociees: json['especes_associees'],
      heureDebut: json['heure_debut'],
      heureFin: json['heure_fin'],
      duree: json['duree'],
      locationD: json['location_d'] != null ? PositionS.fromJson2(json['location_d']) : null,
      locationF: json['location_f'] != null ? PositionS.fromJson2(json['location_f']) : null,
      vitesseNavire: json['vitesse_navire'],
      weatherReport: json['weather_report'] != null ? WeatherReportModel.fromJson2(json['weather_report']) : null,
      activitesHumainesAssociees: json['activites_humaines_associees'] == 1 ? true : false,
      activitesHumainesAssocieesPrecision : json['activites_humaines_associees_precision'],
      effort: json['effort'] == 1 ? true : false,
      commentaires: json['commentaires'],
      photos: json['photos'] == 1 ? true : false,
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['espece'] = espece== null ? null : jsonEncode(espece?.toJson());
    data['taille'] = taille;
    data['nbre_estime'] = nbreEstime;
    data['nbre_mini'] = nbreMini;
    data['nbre_maxi'] = nbreMaxi;
    data['nbre_jeunes'] = nbreJeunes == true ? 1 : 0;
    data['nbre_nouveau_ne'] = nbreNouveauNe == true ? 1 : 0;
    data['structure_groupe'] = structureGroupe;
    data['sous_group'] = sousGroup;
    data['nbre_sous_groupes'] = nbreSousGroupes;
    data['nbre_indiv_sous_groupe'] = nbreIndivSousGroupe;
    data['comportement_surface'] = comportementSurface;
    data['vitesse'] = vitesse;
    data['reaction_bateau'] = reactionBateau;
    data['distance_estimee'] = distanceEstimee;
    data['gisement'] = gisement;
    data['element_detection'] = elementDetection;
    data['especes_associees'] = especesAssociees;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['duree'] = duree;
    data['location_d'] = locationD == null ? null : jsonEncode(locationD?.toJson());
    data['location_f'] = locationF == null ? null :  jsonEncode(locationF?.toJson());
    data['vitesse_navire'] = vitesseNavire;    
    data['weather_report'] =  weatherReport == null ? null : jsonEncode(weatherReport?.toJson());
    data['activites_humaines_associees'] = activitesHumainesAssociees  == true ? 1 : 0;
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
    data['taille'] = taille;
    data['nbre_estime'] = nbreEstime;
    data['nbre_mini'] = nbreMini;
    data['nbre_maxi'] = nbreMaxi;
    data['nbre_jeunes'] = nbreJeunes == true ? 1 : 0;
    data['nbre_nouveau_ne'] = nbreNouveauNe == true ? 1 : 0;
    data['structure_groupe'] = structureGroupe;
    data['sous_group'] = sousGroup;
    data['nbre_sous_groupes'] = nbreSousGroupes;
    data['nbre_indiv_sous_groupe'] = nbreIndivSousGroupe;
    data['comportement_surface'] = comportementSurface;
    data['vitesse'] = vitesse;
    data['reaction_bateau'] = reactionBateau;
    data['distance_estimee'] = distanceEstimee;
    data['gisement'] = gisement;
    data['element_detection'] = elementDetection;
    data['especes_associees'] = especesAssociees;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['duree'] = duree;
    data['location_d'] = locationD?.toJson2();
    data['location_f'] = locationF?.toJson2();
    data['vitesse_navire'] = vitesseNavire;    
    data['weather_report'] = weatherReport?.toJson2();
    data['activites_humaines_associees'] = activitesHumainesAssociees  == true ? 1 : 0;
    data['activites_humaines_associees_precision'] = activitesHumainesAssocieesPrecision;
    data['effort'] = effort == true ? 1 : 0;
    data['commentaires'] = commentaires;
    data['photos'] = photos == true ? 1 : 0;
    data['images'] = images;
     return data;
  }

}
