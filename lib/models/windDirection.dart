class WindDirection {
   int? id; // Numéro de la direction (1 à 8)
   String? nomDepart; // Nom du point cardinal de départ
   String? nomArrivee; // Nom du point cardinal d'arrivée
   String? abreviation; // Abréviation de la direction du vent
   double? angleMin; // Angle minimum (degrés)
   double? angleMax; // Angle maximum (degrés)

  WindDirection({this.id, this.nomDepart, this.nomArrivee, this.abreviation,
      this.angleMin, this.angleMax});

  // Propriété pour obtenir le nom complet de la direction du vent
  String get nomComplet => id == 10 ? "Inconnu" : id == 1 ? nomDepart??"" : "$nomDepart vers $nomArrivee";

   factory WindDirection.fromJson2(Map<String, dynamic> json) {
    return WindDirection(
      id: json['id'],
      nomDepart: json['nom_depart'],
      nomArrivee: json['nom_arrivee'],
      abreviation: json['abreviation'],
      angleMin: json['angleMin'],
      angleMax: json['angleMax'],
    );
  }

      WindDirection.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      nomDepart = json['nom_depart'];
      nomArrivee = json['nom_arrivee'];
      abreviation = json['abreviation'];
      angleMin = json['angle_min'];
      angleMax = json['angle_max'];
  }

  // Fonction toJson pour convertir un objet WindDirection en chaîne JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom_depart': nomDepart,
      'nom_arrivee': nomArrivee,
      'abreviation': abreviation,
      'angle_min': angleMin,
      'angle_max': angleMax,
    };
}
}

final List<WindDirection> windDirections = [
  WindDirection(
    id: 0,
    nomDepart: "",
    nomArrivee: "",
    abreviation: "",
    angleMin: 337.5,
    angleMax: 22.5),
  WindDirection(
    id: 1,
    nomDepart: "Pas de vent",
    nomArrivee: "",
    abreviation: "",
    angleMin: 337.5,
    angleMax: 22.5),
  WindDirection(
    id: 2,
    nomDepart: "Nord",
    nomArrivee: "Ouest",
    abreviation: "N-O",
    angleMin: 337.5,
    angleMax: 22.5),
  WindDirection(
    id: 3,
    nomDepart: "Nord-Est",
    nomArrivee: "Ouest",
    abreviation: "NE-O",
    angleMin: 22.5,
    angleMax: 67.5
    ),
  WindDirection(
    id: 4,
    nomDepart: "Est",
    nomArrivee: "Ouest",
    abreviation: "E-O",
    angleMin: 67.5,
    angleMax: 112.5
    ),
  WindDirection(
    id: 5,
    nomDepart: "Sud-Est",
    nomArrivee: "Ouest",
    abreviation: "SE-O",
    angleMin: 112.5,
    angleMax: 157.5
    ),
  WindDirection(
    id: 6,
    nomDepart: "Sud",
    nomArrivee: "Ouest",
    abreviation: "S-O",
    angleMin: 157.5,
    angleMax: 202.5
    ),
  WindDirection(
    id: 7,
    nomDepart: "Sud-Ouest",
    nomArrivee: "Nord-Est",
    abreviation: "SO-NE",
    angleMin: 202.5,
    angleMax: 247.5
    ),
  WindDirection(
    id: 8,
    nomDepart: "Ouest",
    nomArrivee: "Nord-Est",
    abreviation: "O-NE",
    angleMin: 247.5,
    angleMax: 292.5
    ),
  WindDirection(
    id: 9,
    nomDepart: "Nord-Ouest",
    nomArrivee: "Sud-Est",
    abreviation: "NO-SE",
    angleMin: 292.5,
    angleMax: 337.5
    ),
  WindDirection(
    id: 10,
    nomDepart: "Inconnu",
    nomArrivee: "Inconnu-Est",
    abreviation: "NO-SE",
    angleMin: 292.5,
    angleMax: 337.5
    ),
];
