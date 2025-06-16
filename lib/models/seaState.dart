class SeaState {
   int? id; // Numéro de l'échelle de Douglas (1 à 7)
   String? nom; // Nom de l'état de la mer
   double? houleMin; // Hauteur minimale de la houle (mètres)
   double? houleMax; // Hauteur maximale de la houle (mètres)
   String? description; // Description de l'état de la mer

  SeaState({this.id, this.nom, this.houleMin, this.houleMax, this.description});

    factory SeaState.fromJson2(Map<String, dynamic> json) {
    return SeaState(
      id: json['id'],
      nom: json['nom'],
      houleMin: json['houle_min'],
      houleMax: json['houle_max'],
      description: json['description'],
    );
  }

 SeaState.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      nom = json['nom'];
      houleMin = json['houle_min'];
      houleMax = json['houle_max'];
      description = json['description'];
  }

  // Fonction toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'houle_min': houleMin,
      'houle_max': houleMax,
      'description': description,
    };
  }
}


final List<SeaState> seaStates = [
  SeaState(
   id: 0,
   nom: "Etat",
   houleMin: 0,
   houleMax: 0,
   description: "Hauteur des vagues"
   ),
  SeaState(
   id: 1,
   nom: "Calme",
   houleMin: 0,
   houleMax: 0.1,
   description: "Mer lisse, sans vagues."
   ),
  SeaState(
    id: 2,
    nom: "Ridée",
    houleMin: 0.1,
    houleMax: 0.3,
    description: "Très petites vagues"
    ),
  SeaState(
    id: 3,
    nom: "Belle",
    houleMin: 0.3,
    houleMax: 0.5,
    description: "Vagues petites et courtes."
    ),
  SeaState(
    id: 4,
    nom: "Peu agitée",
    houleMin: 0.5,
    houleMax: 1.25,
    description: "Vagues plus grandes et plus longues."
    ),
  SeaState(
    id: 5,
    nom: "Agitée",
    houleMin: 1.25,
    houleMax: 2.5,
    description: "Vagues avec des crêtes mousseuses."
    ),
  SeaState(
    id: 6,
    nom: "Forte",
    houleMin: 2.5,
    houleMax: 4,
    description: "Vagues déferlantes et bruyantes."
    ),
  SeaState(
    id: 7,
    nom: "Tempête",
    houleMin:  4,
    houleMax: 6,
    description: "Vagues énormes et dangereuses."
    ),
  SeaState(
    id: 8,
    nom: "Ouragan",
    houleMin: 6,
    houleMax: double.infinity,
    description: "Mer déchaînée, danger extrême."),
];
