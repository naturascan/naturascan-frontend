import 'dart:convert';

import 'package:naturascan/models/local/specieModel.dart';

class CategorySpeciesModel {
  int? id;
  String? name;
  String? description;
  List<SpecieModel>? especes;
  String? createdAt;

  CategorySpeciesModel({this.id, this.name, this.description, this.especes, this.createdAt});

  CategorySpeciesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
 if(json["especes"] == null){
      especes = null;
    }else{
          try {
      var resp =
          List<Map<String, dynamic>>.from(jsonDecode(json["especes"]));
      if (resp.isNotEmpty) {
        especes = resp.map((x) => SpecieModel.fromJson(x)).toList();
      } else {
        especes = <SpecieModel>[];
      }
    } catch (e) {
      especes = <SpecieModel>[];
      if (json["especes"] != null) {
        json["especes"].forEach((v) {
          especes!.add(SpecieModel.fromJson(jsonDecode(v)));
        });
      }
    }
    }
    createdAt = json['created_at'];

  }

  factory CategorySpeciesModel.fromJson2(Map<String, dynamic> json) {
    return CategorySpeciesModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      especes: json["especes"] != null
          ? (json["especes"] as List).map((v) => SpecieModel.fromJson(v)).toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['especes'] =  especes == null
        ? null
        : jsonEncode(List<dynamic>.from(especes!.map((x) => x.toJson())));
    data['created_at'] = createdAt;
    return data;
  }
}

final List<CategorySpeciesModel> categories = [
  CategorySpeciesModel(
    id: 11,
    name: "Cétacés",
    especes: [
      SpecieModel(
        commonName: "Autre",
        scientificName: "Autre",
        categoryId: 11
      ),
        SpecieModel(
        commonName: "Cachalot",
        scientificName: "Cachalot",
        categoryId: 11
      ),
        SpecieModel(
        commonName: "Dauphin Commun",
        scientificName: "Dauphin Commun",
        categoryId: 11
      ),
        SpecieModel(
        commonName: "Dauphin bleu-et-blanc",
        scientificName: "Dauphin bleu-et-blanc",
        categoryId: 11
      ),
        SpecieModel(
        commonName: "Dauphin de Risso",
        scientificName: "Dauphin de Risso",
        categoryId: 11
      ),
        SpecieModel(
        commonName: "Dauphin gris (Tursiops)",
        scientificName: "Dauphin gris (Tursiops)",
        categoryId: 11
      ),
       SpecieModel(
        commonName: "Globicéphale noir",
        scientificName: "Globicéphale noir",
        categoryId: 11
      ),
       SpecieModel(
        commonName: "Orque",
        scientificName: "Orque",
        categoryId: 11
      ),
       SpecieModel(
        commonName: "Rorqual commun",
        scientificName: "Rorqual commun",
        categoryId: 11
      ),
      SpecieModel(
        commonName: "Zipius",
        scientificName: "Zipius",
        categoryId: 11
      ),

    ]
  ),
 CategorySpeciesModel(
    id: 4,
    name: "Poissons",
    especes: [
        SpecieModel(
        commonName: "Autre",
        scientificName: "Autre",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Baliste",
        scientificName: "Baliste",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Centrolophe noir",
        scientificName: "Centrolophe noir",
        categoryId: 4
      ),
         SpecieModel(
        commonName: "Cernier",
        scientificName: "Cernier",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Coryphène",
        scientificName: "Coryphène",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Coryphène-dauphin",
        scientificName: "Coryphène-dauphin",
        categoryId: 4
      ),
         SpecieModel(
        commonName: "Espadon",
        scientificName: "Espadon",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Marlin",
        scientificName: "Marlin",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Poisson-lune",
        scientificName: "Poisson-lune",
        categoryId: 4
      ),
         SpecieModel(
        commonName: "Poisson-pilote",
        scientificName: "Poisson-pilote",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Raie-pastenague violette",
        scientificName: "Raie-pastenague violette",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Diable de mer",
        scientificName: "Diable de mer",
        categoryId: 4
      ),
         SpecieModel(
        commonName: "Requin peau-bleue",
        scientificName: "Requin peau-bleue",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Requin pèlerin",
        scientificName: "Requin pèlerin",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Rouffe impérial",
        scientificName: "Rouffe impérial",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Rouffe des épaves",
        scientificName: "Rouffe des épaves",
        categoryId: 4
      ),
         SpecieModel(
        commonName: "Sardine (banc)",
        scientificName: "Sardine (banc)",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Sériole",
        scientificName: "Sériole",
        categoryId: 4
      ),
        SpecieModel(
        commonName: "Thonidés (chasse)",
        scientificName: "Thonidés (chasse)",
        categoryId: 4
      ),
    ]
  ),
 
 CategorySpeciesModel(
    id: 2,
    name: "Oiseaux",
    especes: [
        SpecieModel(
        commonName: "Autre",
        scientificName: "Autre",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Aigrette (grande)",
        scientificName: "Aigrette (grande)",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Aigrette garzette",
        scientificName: "Aigrette garzette",
        categoryId: 2
      ),
         SpecieModel(
        commonName: "Cormoran (grand)",
        scientificName: "Cormoran (grand)",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Cormoran huppé",
        scientificName: "Cormoran huppé",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Flamant rose",
        scientificName: "Flamant rose",
        categoryId: 2
      ),
         SpecieModel(
        commonName: "Fou de Bassan",
        scientificName: "Fou de Bassan",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Héron cendré",
        scientificName: "Héron cendré",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Héron garde-boeufs",
        scientificName: "Héron garde-boeufs",
        categoryId: 2
      ),
         SpecieModel(
        commonName: "Mouette rieuse",
        scientificName: "Mouette rieuse",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Mouette tridactyle",
        scientificName: "Mouette tridactyle",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Mouette mélanocéphale",
        scientificName: "Mouette mélanocéphale",
        categoryId: 2
      ),
         SpecieModel(
        commonName: "Goéland leucophée",
        scientificName: "Goéland leucophée",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Goéland d'Audouin",
        scientificName: "Goéland d'Audouin",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Guifette noire",
        scientificName: "Guifette noire",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Macareux moine",
        scientificName: "Macareux moine",
        categoryId: 2
      ),
         SpecieModel(
        commonName: "Océanite tempête",
        scientificName: "Océanite tempête",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Pingouin torda",
        scientificName: "Pingouin torda",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Puffin de Scopoli",
        scientificName: "Puffin de Scopoli",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Puffin yelkouan",
        scientificName: "Puffin yelkouan",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Sterne Caugek",
        scientificName: "Sterne Caugek",
        categoryId: 2
      ),
        SpecieModel(
        commonName: "Sterne pierregarin",
        scientificName: "Sterne pierregarin",
        categoryId: 2
      ),
    ]
  ),
   
   CategorySpeciesModel(
    id: 12,
    name: "Tortues",
    especes: [
        SpecieModel(
        commonName: "Autre",
        scientificName: "Autre",
        categoryId: 12
      ),
        SpecieModel(
        commonName: "Tortue caouanne",
        scientificName: "Tortue caouanne",
        categoryId: 12
      ),
        SpecieModel(
        commonName: "Tortue luth",
        scientificName: "Tortue luth",
        categoryId: 12
      ),
      SpecieModel(
        commonName: "Tortue verte",
        scientificName: "Tortue verte",
        categoryId: 12
      ),
    ]
  ),

  CategorySpeciesModel(
    id: 13,
    name: "Invertébrés",
    especes: [
        SpecieModel(
        commonName: "Autre",
        scientificName: "Autre",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Anatife",
        scientificName: "Anatife",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Crabe de Christophe Colomb",
        scientificName: "Crabe de Christophe Colomb",
        categoryId: 13
      ),
         SpecieModel(
        commonName: "Nudibranche Fiona",
        scientificName: "Nudibranche Fiona",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Idotée métallique",
        scientificName: "Idotée métallique",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Janthine",
        scientificName: "Janthine",
        categoryId: 13
      ),
         SpecieModel(
        commonName: "Méduse pélagie",
        scientificName: "Méduse pélagie",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Méduse aurélie",
        scientificName: "Méduse aurélie",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Méduse équorée",
        scientificName: "Méduse équorée",
        categoryId: 13
      ),
         SpecieModel(
        commonName: "Méduse oeuf-au-plat",
        scientificName: "Méduse oeuf-au-plat",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Méduse rhizostome",
        scientificName: "Méduse rhizostome",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Vélelle",
        scientificName: "Vélelle",
        categoryId: 13
      ),
         SpecieModel(
        commonName: "Porpite",
        scientificName: "Porpite",
        categoryId: 13
      ),
        SpecieModel(
        commonName: "Salpe spp.",
        scientificName: "Salpe spp.",
        categoryId: 13
      ),
    ]
  ),

   CategorySpeciesModel(
    id: 14,
    name: "Déchets",
    especes: [
        SpecieModel(
        commonName: "Autre",
        scientificName: "Autre",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Caisse polystyrène",
        scientificName: "Caisse polystyrène",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Cordage, ficelle",
        scientificName: "Cordage, ficelle",
        categoryId: 14
      ),
         SpecieModel(
        commonName: "Emballage plastique",
        scientificName: "Emballage plastique",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Engin de pêche",
        scientificName: "Engin de pêche",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Bâche plastique",
        scientificName: "Bâche plastique",
        categoryId: 14
      ),
         SpecieModel(
        commonName: "Ballon baudruche",
        scientificName: "Ballon baudruche",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Ballon hélium",
        scientificName: "Ballon hélium",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Ballon de plage",
        scientificName: "Ballon de plage",
        categoryId: 14
      ),
         SpecieModel(
        commonName: "Sac plastique",
        scientificName: "Sac plastique",
        categoryId: 14
      ),
        SpecieModel(
        commonName: "Sceau plastique",
        scientificName: "Sceau plastique",
        categoryId: 14
      ),
    ]
  ),
 
  ];
  

