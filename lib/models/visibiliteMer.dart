class VisibiliteMer {
   int? id; // Identifiant unique du type de visibilité
   String? nom; // Nom du type de visibilité
   String? description; // Description du type de visibilité
   int? distanceMin; // Distance minimale de visibilité (en km)
   int? distanceMax; // Distance maximale de visibilité (en km)

  VisibiliteMer({this.id, this.nom, this.description, this.distanceMin, this.distanceMax});

 factory VisibiliteMer.fromJson2(Map<String, dynamic> json) {
    return VisibiliteMer(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      distanceMin: json['distance_min'],
      distanceMax: json['distance_max'],
    );
  }

   VisibiliteMer.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      nom = json['nom'];
      description = json['description'];
      distanceMin = json['distance_min'];
      distanceMax = json['distance_max'];
  }

  // Fonction toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'distance_min': distanceMin,
      'distance_max': distanceMax,
    };
  }
}


final List<VisibiliteMer> visibilites2 = [
  VisibiliteMer(
    id: 1,
    nom: "Bonne",
    description: "Visibilité inférieure à 2 km",
    distanceMin: 0,
    distanceMax: 2
    ),
  VisibiliteMer(
    id: 2,
    nom: "Médiocre",
    description: "Visibilité entre 2 et 5 km",
    distanceMin: 2,
    distanceMax: 5
    ),
  VisibiliteMer(
    id: 3,
    nom: "Mauvaise",
    description: "Visibilité entre 5 et 10 km",
    distanceMin: 5,
    distanceMax: 10
    ),
  VisibiliteMer(
    id: 4,
    nom: "Brouillard",
    description: "Visibilité supérieure à 10 km",
    distanceMin: 10,
    distanceMax: 100),
];
