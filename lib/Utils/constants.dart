import 'package:flutter/material.dart';

class Constants{
  static const baseUrl = "https://api-naturascan.lesaquanautes.eu/api/";
  static const colorPrimary = Colors.teal;
  static final textColor = Colors.grey.shade800;
  static const colorPrimaryDark = Colors.tealAccent;
  static const accessTokenAuth = "accessTokenAuth";
  static const timeO = "timeO";
  static const me = "me";
  static const appleGivenName = "appleGivenName";
  static const appleFamilyName = "appleFamilyName";
  static const email = "email";
  static const connected = "connected";
  static const enCours = "enCours";
  static const cloudCover = "cloudCover";
  static const douglas = "douglas";
  static const seaState = "seaState";
  static const visibility = "visibility";
  static const windForce = "windForce";
  static const windDirection = "windDirection";
  static const selectedType = "selectedType";
  static const totalExport = "totalExport";
  static const type = ["NaturaScan", "Sortie Pêcheur", "SuiviTrace"];
  static const mode = ["A pied", "A vélo", "A drône"];
  static const role = "role";
  static const List<String> structureList = ["Agrégation", "Dispersion", "Seul", "Autre"];
  static const List<String> etatList = ["Compact", "Dispersé", "Sous-groupe", "Autre"];
  static const List<String> vitesseList = ["Lente", "Rapide", "Stationnaire", "Variale"];
  static const List<String> reactionList = ["Evitement" , "Fuite", "Indifférent", "Attraction"]; 
  static const List<String> detectionList = ["Dos", "Saut", "Dorsale", "Souffle"]; 
  static const List<String> typeList = ["Autre", "Plastique", "Polystyrène", "Mousse expansive", "Nylon"];
  static const List<String> colorList = ["Blanc", "Noir", "Beige", "Gris", "Bleu", "Vert", "Rouge", "Rose", "Marron", "Jaune", "Orange"];
  static const List<String> distanceList = ["O m", "10 m", "< 100 m", "< 500 m", "> 500 m"];

}