class CloudCover {
   int? id; // Numéro de l'échelle (1 à 10)
   String? nom; // Nom de la couverture nuageuse
   double? pourcentageMin; // Pourcentage minimum de couverture
   double? pourcentageMax; // Pourcentage maximum de couverture
   String? description; // Description de la couverture nuageuse

  CloudCover({this.id, this.nom, this.pourcentageMin, this.pourcentageMax,
      this.description});

factory CloudCover.fromJson2(Map<String, dynamic> json) {
    return CloudCover(
      id: json['id'],
      nom: json['nom'],
      pourcentageMin: json['pourcentage_min'],
      pourcentageMax: json['pourcentage_max'],
      description: json['description'],
    );
  }
  

 CloudCover.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      nom = json['nom'];
      pourcentageMin = json['pourcentage_min'];
      pourcentageMax = json['pourcentage_max'];
      description = json['description'];
    
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'pourcentage_min': pourcentageMin,
      'pourcentage_max': pourcentageMax,
      'description': description,
    };
  }
}

final List<CloudCover> cloudCovers = [
  CloudCover(
    id: 0,
    nom:  "Description",
    pourcentageMin: 0, 
    pourcentageMax: 1, 
    description: "Valeur/ 10"
    ),
  CloudCover(
    id: 1,
    nom: "Ciel dégagé",
    pourcentageMin: 0,
    pourcentageMax: 1,
    description: "Pas de nuages visibles."
    ),
  CloudCover(
    id: 2,
    nom: "Eclaircies",
    pourcentageMin: 1,
    pourcentageMax: 3,
    description: "Quelques nuages dispersés."
    ),
  CloudCover(
    id: 3,
    nom: "Partiellement nuageux",
    pourcentageMin: 3,
    pourcentageMax: 5,
    description:  "Nuages et éclaircies en proportions égales."
    ),
  CloudCover(
    id: 4,
    nom: "Nuageux",
    pourcentageMin: 5,
    pourcentageMax: 7,
    description: "Plus de nuages que d'éclaircies."
    ),
  CloudCover(
    id: 5,
    nom: "Très nuageux",
    pourcentageMin: 7,
    pourcentageMax: 9,
    description: "Presque tout le ciel est couvert."
    ),
  CloudCover(
     id: 6,
     nom: "Ciel couvert",
     pourcentageMin: 9,
     pourcentageMax: 10,
     description: "Le ciel est entièrement couvert de nuages."
     ),
  CloudCover(
     id: 7,
     nom: "Brouillard",
     pourcentageMin: 10,
     pourcentageMax: 10,
     description: "Visibilité réduite par le brouillard."
     ),
  CloudCover(
     id: 8,
     nom: "Pluie légère",
     pourcentageMin: 10,
     pourcentageMax: 10,
     description: "Pluie fine et intermittente."
     ),
  CloudCover(
    id: 9,
    nom: "Pluie modérée",
    pourcentageMin: 10,
    pourcentageMax: 10,
    description: "Pluie continue et plus forte."
    ),
  CloudCover(
    id: 10,
    nom: "Pluie forte",
    pourcentageMin: 10,
    pourcentageMax: 10,
    description: "Pluie intense et précipitante."
    ),
];

