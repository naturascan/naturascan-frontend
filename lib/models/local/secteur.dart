import 'dart:convert';

class Secteur {
  int? id;
  String? name;
  String? description;
  List<SousSecteur>? sousSecteurs;

  Secteur({this.id, this.name, this.description, this.sousSecteurs});

  Secteur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
 if(json["sous_secteurs"] == null){
      sousSecteurs = null;
    }else{
          try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["sous_secteurs"]));
      if (resp.isNotEmpty) {
        sousSecteurs = resp.map((x) => SousSecteur.fromJson(x)).toList();
      } else {
        sousSecteurs = <SousSecteur>[];
      }
    } catch (e) {
      sousSecteurs = <SousSecteur>[];
      if (json["sous_secteurs"] != null) {
        json["sous_secteurs"].forEach((v) {
          sousSecteurs!.add(SousSecteur.fromJson(jsonDecode(v)));
        });
      }
    }
    }
  }

  factory Secteur.fromJson2(Map<String, dynamic> json) {
    return Secteur(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sousSecteurs: json["sous_secteurs"] != null
          ?  List<Map<String, dynamic>>.from(json['sous_secteurs']).map((x) => SousSecteur.fromJson2(x)).toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['sous_secteurs'] =  sousSecteurs == null
        ? null
        : jsonEncode(List<dynamic>.from(sousSecteurs!.map((x) => x.toJson())));
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['sous_secteurs'] =  sousSecteurs == null
        ? null
        : List<dynamic>.from(sousSecteurs!.map((x) => x.toJson2()));
    return data;
  }
}
 
  

class SousSecteur {
  int? id;
  String? name;
  String? description;
  List<Plage>? plage;

  SousSecteur({this.id, this.name, this.description, this.plage});

  SousSecteur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  if(json["plage"] == null){
      plage = null;
    }else{
          try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["plage"]));
      if (resp.isNotEmpty) {
        plage = resp.map((x) => Plage.fromJson(x)).toList();
      } else {
        plage = <Plage>[];
      }
    } catch (e) {
      plage = <Plage>[];
      if (json["plage"] != null) {
        json["plage"].forEach((v) {
          plage!.add(Plage.fromJson(jsonDecode(v)));
        });
      }
    }
    }
  }

  factory SousSecteur.fromJson2(Map<String, dynamic> json) {
    return SousSecteur(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      plage: json["plage"] != null
          ?  List<Map<String, dynamic>>.from(json['plage']).map((x) => Plage.fromJson2(x)).toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['plage'] =  plage == null
        ? null
        : jsonEncode(List<dynamic>.from(plage!.map((x) => x.toJson())));
    return data;
  }

    Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['plage'] =  plage == null
        ? null
        : List<dynamic>.from(plage!.map((x) => x.toJson()));
    return data;
  }
}
 
  
class Plage {
  int? id;
  String? name;
  String? description;
  int? idSecteur;
  int? idSousSecteur;

  Plage({this.id, this.name, this.description, this.idSecteur, this.idSousSecteur});

  Plage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    idSecteur = json['id_secteur'];
    idSousSecteur = json['id_sous_secteur'];
      }

  factory Plage.fromJson2(Map<String, dynamic> json) {
    return Plage(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      idSecteur : json['id_secteur'],
      idSousSecteur : json['id_sous_secteur']
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['id_secteur'] = idSecteur;
    data['id_sous_secteur'] = idSousSecteur;
    return data;
  }
}
 
  
final List<Secteur> secteurLists = [
  Secteur(
    id: 1,
    name: "Secteur Frejus",
    description: "Superbe Secteur",
    sousSecteurs: [
      SousSecteur(
            id: 1,
            name: "St-Raphaël",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Anthéor",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
                Plage(
                id: 2,
                name: "Baumette",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
                Plage(
                id: 3,
                name: "Agay",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
              Plage(
                id: 4,
                name: "Pourrousset",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
                Plage(
                id: 5,
                name: "Camp Long",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
                Plage(
                id: 6,
                name: "Aigue Bonne",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
                Plage(
                id: 7,
                name: "Boulouris",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
                Plage(
                id: 8,
                name: "Veillat",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 1
              ),
            ]
      ),
      SousSecteur(
            id: 2,
            name: "Fréjus",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Les Sablettes",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
                Plage(
                id: 2,
                name: "République",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
                Plage(
                id: 3,
                name: "Capitole",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
              Plage(
                id: 4,
                name: "Plage Caouanne",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
                Plage(
                id: 5,
                name: "Base Nature",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
                Plage(
                id: 6,
                name: "Pacha",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
                Plage(
                id: 7,
                name: "Argens",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
                Plage(
                id: 8,
                name: "Esclamandes",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 2
              ),
            ]
      ),
      SousSecteur(
            id: 3,
            name: "Roquebrune/Argens",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Gaillarde",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 3
              ),
                Plage(
                id: 2,
                name: "San Peire",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 3
              ),
                Plage(
                id: 3,
                name: "Peiras",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 3
              ),
              Plage(
                id: 4,
                name: "Garonnette, base nautique",
                description: "Superbe Plage",
                idSecteur: 1,
                idSousSecteur: 3
              ),
            ]
      ),
    ]
  ),
  Secteur(
    id: 2,
    name: "Secteur St Tropez",
    description: "Superbe Secteur",
    sousSecteurs: [
      SousSecteur(
            id: 1,
            name: "Ste Maxime",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Garonnette",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 1
              ),
                Plage(
                id: 2,
                name: "La Nartelle",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 1
              ),
                Plage(
                id: 3,
                name: "Madrague",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 1
              ),
              Plage(
                id: 4,
                name: "Croisette",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 1
              ),
                Plage(
                id: 5,
                name: "Centre-ville",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 1
              ),
            ]
      ),
      SousSecteur(
            id: 2,
            name: "Grimaud",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Guerrevielle",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 2
              ),
                Plage(
                id: 2,
                name: "Les Cigales",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 2
              ),
                Plage(
                id: 3,
                name: "Port Grimaud",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 2
              ),
              Plage(
                id: 4,
                name: "Gros Pin",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 2
              ),
                Plage(
                id: 5,
                name: "Vieux Moulin",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 2
              ),
            ]
      ),
      SousSecteur(
            id: 3,
            name: "Cogolin",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Les Marines",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 3
              ),
            ]
      ),
   
      SousSecteur(
            id: 4,
            name: "Saint Tropez",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "La Bouillabaisse",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 4
              ),
                Plage(
                id: 2,
                name: "Le Pilon",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 4
              ),
                Plage(
                id: 3,
                name: "Gragniers",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 4
              ),
              Plage(
                id: 4,
                name: "Canebiers",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 4
              ),
               Plage(
                id: 5,
                name: "Les Salins",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 4
              ),
              Plage(
                id: 6,
                name: "La Moutte",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 4
              ),
            ]
      ),
     SousSecteur(
            id: 5,
            name: "Ramatuelle",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Pampelonne",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 5
              ),
                Plage(
                id: 2,
                name: "Bonne terrasse",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 5
              ),
                Plage(
                id: 3,
                name: "Escalet",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 5
              ),
              Plage(
                id: 4,
                name: "Isthme Taillat",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 5
              ),
               Plage(
                id: 5,
                name: "Pointe du Canadel",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 5
              ),
            ]
      ),
       SousSecteur(
            id: 6,
            name: "La Croix Valmer",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Briande",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
                Plage(
                id: 2,
                name: "Les Brouis",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
                Plage(
                id: 3,
                name: "Gigaro Conservatoire",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
              Plage(
                id: 4,
                name: "Gigaro",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
               Plage(
                id: 5,
                name: "Plage du croissant",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
              Plage(
                id: 6,
                name: "Héraclé",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
              Plage(
                id: 7,
                name: "Sylvabelle",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
                Plage(
                id: 8,
                name: "Vergeron",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
                Plage(
                id: 9,
                name: "La Bouillabesse",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
              Plage(
                id: 10,
                name: "La Douane",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
               Plage(
                id: 11,
                name: "Pardigeon",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 6
              ),
            ]
      ),
       SousSecteur(
            id: 7,
            name: "Cavalaire",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Le Parc",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 7
              ),
                Plage(
                id: 2,
                name: "Centre-ville",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 7
              ),
                Plage(
                id: 3,
                name: "Bonporteau",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 7
              ),
              Plage(
                id: 4,
                name: "Bonbon",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 7
              ),
            ]
      ),
           SousSecteur(
            id: 8,
            name: "Rayol Canadel",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Plage du Figuier",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 8
              ),
                Plage(
                id: 2,
                name: "Rayol Est",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 8
              ),
                Plage(
                id: 3,
                name: "Canadel",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 8
              ),
              Plage(
                id: 4,
                name: "Pramousquier",
                description: "Superbe Plage",
                idSecteur: 2,
                idSousSecteur: 8
              ),
            ]
      ),    
    ]
  ),
  Secteur(
    id: 3,
    name: "Secteur Hyéres",
    description: "Superbe Secteur",
    sousSecteurs: [
      SousSecteur(
            id: 1,
            name: "Porquerolles",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Pointe Prime",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 2,
                name: "Plage d'Argent",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 3,
                name: "Plage de Bon renaud",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
              Plage(
                id: 4,
                name: "Plage de l'Aigadon E",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 5,
                name: "Plage de l'Aigadon O",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
               Plage(
                id: 6,
                name: "Plage de l'Aigade E",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 7,
                name: "Plage de l'Aigade O",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 8,
                name: "Calanque aux coquillages",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
              Plage(
                id: 9,
                name: "Crique du Cap rousset",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 10,
                name: "Plage du Muso",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
               Plage(
                id: 11,
                name: "Plage blanche E",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 12,
                name: "Plage blanche O",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 13,
                name: "Plage noire O",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
              Plage(
                id: 14,
                name: "Plage noire E",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 15,
                name: "Brégançonnet",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
               Plage(
                id: 16,
                name: "Calanque de l'Oustaou",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 17,
                name: "Plage de la Galere",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 18,
                name: "Plage de la croustillante",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
              Plage(
                id: 19,
                name: "Plage Notre Dame",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 20,
                name: "Alycastre",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 21,
                name: "Crique du Lequin",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 22,
                name: "La Courtade 4",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 23,
                name: "La  Courtade 3",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
              Plage(
                id: 24,
                name: "La Courtade 2",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
              ),
                Plage(
                id: 25,
                name: "La Courtade 1",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 1
                )
            ]
      ),
      SousSecteur(
            id: 2,
            name: "Port-Cros",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Plage du Sud",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
                Plage(
                id: 2,
                name: "Port-Man",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
                Plage(
                id: 3,
                name: "Calanque du Palangrier",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
              Plage(
                id: 4,
                name: "Calanque longue",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
                Plage(
                id: 5,
                name: "Calanque de la Marma",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
               Plage(
                id: 6,
                name: "Plage de La Palud",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
                Plage(
                id: 7,
                name: "Crique de La Palud",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 2
              ),
            ]
      ),
      SousSecteur(
            id: 3,
            name: "La Londe Les Maures",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Miramar",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 3
              ),
               Plage(
                id: 2,
                name: "Plage du Pansard",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 3
              ),
            ]
      ),  
      SousSecteur(
            id: 4,
            name: "Hyères",
            description: "",
            plage: [
              Plage(
                id: 1,
                name: "Vieux Salins",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 2,
                name: "Plage du Pentagone",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 3,
                name: "Plage de la gare",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 4,
                name: "Plage Berriau",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 5,
                name: "Plagette du Gapeau",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 6,
                name: "Plage du Mérou",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
               Plage(
                id: 7,
                name: "Plage de l'Ayguade",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 8,
                name: "Plage du Ceinturon",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 9,
                name: "Plage du Ceinturon",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 10,
                name: "Plage Bona N",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 11,
                name: "Plage Bona S",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 12,
                name: "Plage des Pesquiers",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 13,
                name: "Plage de la Capte",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 14,
                name: "Plage de la Bergerie",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 15,
                name: "Plage de la Badine",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 16,
                name: "L'Almanarre",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 17,
                name: "Plage du por Hélène",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
              Plage(
                id: 18,
                name: "Crique Estanci 2",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 4
              ),
            ]
      ),
            SousSecteur(
            id: 5,
            name: "Giens",
            description: "",
            plage: [
              Plage(
                id: 1,
                name: "Crique Estanci 3",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 2,
                name: "Crique Estanci 1",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 3,
                name: "Plage de l'Estanci",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 4,
                name: "Plage de la Baume",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 5,
                name: "Plage des arbannais",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 6,
                name: "Plage des gabians",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 7,
                name: "Plage de la batterie",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 8,
                name: "Plage des Cyprès",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 9,
                name: "Plage du Bouvet E",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 10,
                name: "Plage de la pointe du Bouvet",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 11,
                name: "Plage de la Tour Fondue E",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 12,
                name: "Plage de la Tour Fondue",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 13,
                name: "Plage du Bouvet",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 14,
                name: "Plage du Pradeau",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 15,
                name: "Plage de la terre rouge",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 16,
                name: "Port Augier",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 17,
                name: "Plage de la Vignette",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
               Plage(
                id: 18,
                name: "Port du Niel",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 19,
                name: "Plage des Darboussière",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 20,
                name: "Plage du Pontillon",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 21,
                name: "La Madrague",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
              Plage(
                id: 22,
                name: "Calanque du four à chaux",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
                Plage(
                id: 23,
                name: "Plage de l'Hermitage",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 5
              ),
            ]
      ),
     SousSecteur(
            id: 6,
            name: "Carqueiranne",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Plage du Peno",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 6
              ),
                Plage(
                id: 2,
                name: "Plage du Pradon",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 6
              ),
                Plage(
                id: 3,
                name: "Plage du Coupereau",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 6
              ),
            ]
      ),
       SousSecteur(
            id: 7,
            name: "Le Pradet",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Plage des Oursinières S",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 7
              ),
                Plage(
                id: 2,
                name: "Plage des Oursinières N",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 7
              ),
                Plage(
                id: 3,
                name: "Plage de la Garonne",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 7
              ),
              Plage(
                id: 4,
                name: "Plage des Bonnettes",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 7
              ),
               Plage(
                id: 5,
                name: "Plage du Monaco",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 7
              ),
              Plage(
                id: 6,
                name: "Plage du Pin de Galle",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 7
              ),
             ]
      ),
       SousSecteur(
            id: 8,
            name: "La Garde",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Anse Magaud",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 8
              ),
            ]
      ),
           SousSecteur(
            id: 9,
            name: "Levant",
            description: "",
            plage: [
               Plage(
                id: 1,
                name: "Plage des grottes",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 9
              ),
                Plage(
                id: 2,
                name: "Plage de Rioufred",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 9
              ),
                Plage(
                id: 3,
                name: "Plage de l'ane",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 9
              ),
              Plage(
                id: 4,
                name: "Plage du Liserot",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 9
              ),
              Plage(
                id: 5,
                name: "Plage de la Paille",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 9
              ),
              Plage(
                id: 6,
                name: "Plage du Petit AVis",
                description: "Superbe Plage",
                idSecteur: 3,
                idSousSecteur: 9
              ),
            ]
      ),
    ]
  ),
  Secteur(
    id: 4,
    name: "Secteur la Seyne sur Mer",
    description: "",
    sousSecteurs: [
      SousSecteur(
        id: 1,
        name: "La Seyne sur Mer",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage du Mourilon",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 2,
                name: "Plage de la Mitre",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 3,
                name: "Plage de St Asile",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 4,
                name: "Plage de Fabregas",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 5,
                name: "Plage du Saint Selon",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 6,
                name: "Plage Pierredon",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 7,
                name: "Plage du Mont Salva",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 8,
                name: "Plage du Brusc",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),
              Plage(
                id: 9,
                name: "Plage de la Coudoulière",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),  
              Plage(
                id: 10,
                name: "Plage de Bonnegrâce",
                description: "Superbe Plage",
                idSecteur: 4,
                idSousSecteur: 1
              ),         
        ]
      )
    ]
  ),
  Secteur(
    id: 5,
    name: "Secteur ST Cyr sur Mer",
    description: "",
    sousSecteurs: [
      SousSecteur(
        id: 1,
        name: "Saint Cyr sur Mer",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Calanque de Port d'Alon - plage principale",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 1
              ),
              Plage(
                id: 2,
                name: "Calanque de Port d'Alon - crique Jauffrey",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 1
              ),
              Plage(
                id: 3,
                name: "Baie des nations",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 1
              ),
              Plage(
                id: 4,
                name: "Plage de Madrague",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 1
              ),
              Plage(
                id: 5,
                name: "Plage des Lecques",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 1
              ),
        ]
      ),
      SousSecteur(
        id: 2,
        name: "La Ciotat",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage des lumières",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 2
              ),
              Plage(
                id: 2,
                name: "Plage des Cyrnos",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 2
              ),
              Plage(
                id: 3,
                name: "Plage des Capucins",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 2
              ),
        ]
      ),
        SousSecteur(
        id: 3,
        name: "Parc National des Calanques",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage de la grande mer",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 3
              ),
              Plage(
                id: 2,
                name: "Port Pin",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 3
              ),
              Plage(
                id: 3,
                name: "Sormiou",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 3
              ),
              Plage(
                id: 4,
                name: "Riou",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 3
              ),
              Plage(
                id: 5,
                name: "En Vau",
                description: "Superbe Plage",
                idSecteur: 5,
                idSousSecteur: 3
              ),
        ]
      ),
     
   
    ]
  ),
  
  Secteur(
    id: 6,
    name: "Secteur Est Hérault Petite",
    description: "",
    sousSecteurs: [
      SousSecteur(
        id: 1,
        name: "Camargue Gardoise ",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "L'Espiguette",
                description: "Superbe Plage",
                idSecteur: 6,
                idSousSecteur: 1
              ),
        ]
      ),
      SousSecteur(
        id: 2,
        name: "Palavasiens ",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage anthropique - Zone 0 (ANT_00)",
                description: "Superbe Plage",
                idSecteur: 6,
                idSousSecteur: 2
              ),
          Plage(
                id: 2,
                name: "Plage anthropique - Zone 1 (ANT_01)",
                description: "Superbe Plage",
                idSecteur: 6,
                idSousSecteur: 2
              ),
          Plage(
                id: 3,
                name: "Plage naturelle - Zone 2 (NAT_02)",
                description: "Superbe Plage",
                idSecteur: 6,
                idSousSecteur: 2
              ),
          Plage(
                id: 3,
                name: "Plage naturelle - Zone 3 (NAT_03)",
                description: "Superbe Plage",
                idSecteur: 6,
                idSousSecteur: 2
              ),
          Plage(
                id: 4,
                name: "Plage naturelle - Zone 4 (NAT_04)",
                description: "Superbe Plage",
                idSecteur: 6,
                idSousSecteur: 2
              ),
        ]
      ),

    ]
    ),
  Secteur(
		id: 7,
		name: "Secteur Ouest Hérault",
		description: "",
		sousSecteurs: [
      SousSecteur(
        id: 1,
        name: "Thau",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage Baleine",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),
          Plage(
                id: 2,
                name: "Plage 3 Digues",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),
          Plage(
                id: 3,
                name: "Plage Jalabert",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),
          Plage(
                id: 4,
                name: "Plage Castellas",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),
          Plage(
                id: 5,
                name: "Plage Vassal",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),
          Plage(
                id: 6,
                name: "Plage Robinson",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),
          Plage(
                id: 7,
                name: "Marseillan Plage",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 1
              ),

        ]
      ),
      SousSecteur(
        id: 2,
        name: "Sérignan ",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Les Orpellières",
                description: "Superbe Plage",
                idSecteur: 7,
                idSousSecteur: 2
              ),
          
        ]
      )
    ]
  ),
  Secteur(
		id: 8,
		name: "Secteur Littoral Audois",
		description: "",
		sousSecteurs: [
      SousSecteur(
        id: 1,
        name: "Fleury d'Aude ",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage naturelle des cabannes à La grande cosse",
                description: "Superbe Plage",
                idSecteur: 8,
                idSousSecteur: 1
              ),
          Plage(
                id: 2,
                name: "Plage naturelle de la grande cosse à Pissevaches",
                description: "Superbe Plage",
                idSecteur: 8,
                idSousSecteur: 1
              ),
        ]
      ),
      SousSecteur(
        id: 2,
        name: "Gruissan",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage la  Vieille-Nouvelle Sud Rouet",
                description: "Superbe Plage",
                idSecteur: 8,
                idSousSecteur: 2
              ),
        ]
      ),
      SousSecteur(
        id: 3,
        name: "Port-la-Nouvelle",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage de la Vieille Nouvelle",
                description: "Superbe Plage",
                idSecteur: 8,
                idSousSecteur: 2
              ),
        ]
      )
    ]
    ),
  Secteur(
		id: 9,
		name: "Secteur Parc Naturel Marin ",
		description: "",
		sousSecteurs: [
      SousSecteur(
        id: 1,
        name: "Torreilles ",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage naturiste Nord",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 1
              ),
          Plage(
                id: 2,
                name: "Plage naturiste",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 1
              ),
          Plage(
                id: 3,
                name: "Plage naturiste rive droite",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 1
              ),
        ]
      ),
     SousSecteur(
        id: 2,
        name: "Sainte-Marie la mer ",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage centre",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 2
              ),
          Plage(
                id: 2,
                name: "Plage des épis",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 2
              ),
        ]
      ),
    SousSecteur(
        id: 3,
        name: "Canet-en-Roussillon",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Rive gauche Canet",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 3
              ),
          Plage(
                id: 2,
                name: "Plage du Lido ",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 3
              ),
          Plage(
                id: 3,
                name: "Plage Lido Sud",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 3
              ),
          Plage(
                id: 4,
                name: "Page Sud",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 3
              ),
        ]
      ),
      SousSecteur(
        id: 4,
        name: "Saint-Cyprien / Elne",
        description: "",
        plage: [
          Plage(
                id: 1,
                name: "Plage d'Elne (Bocal du Tech)",
                description: "Superbe Plage",
                idSecteur: 9,
                idSousSecteur: 4
              ),
        ]
      )
    ]
  ),
];