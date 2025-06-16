class DouglasWindForce {
  final int id; // Numéro de l'échelle de Douglas (1 à 9)
  final String nom; // Nom de la force du vent
  final double vitesseMin; // Vitesse minimale du vent (km/h)
  final double vitesseMax; // Vitesse maximale du vent (km/h)
  final String description; // Description de la force du vent

  DouglasWindForce(
      this.id, this.nom, this.vitesseMin, this.vitesseMax, this.description);
}

final List<DouglasWindForce> douglasWindForces = [
  DouglasWindForce(1, "Calme", 0, 1, "Vent insensible."),
  DouglasWindForce(2, "Légère brise", 1, 3, "Vent faiblement perceptible."),
  DouglasWindForce(3, "Petite brise", 3, 6,
      "Vent qui soulève la poussière et agite les feuilles."),
  DouglasWindForce(
      4, "Vent frais", 6, 11, "Vent qui agite les branches des arbres."),
  DouglasWindForce(
      5, "Vent modéré", 11, 16, "Vent qui fait siffler les fils électriques."),
  DouglasWindForce(6, "Assez fort vent", 16, 22,
      "Vent qui soulève les branches des arbres et les petits objets."),
  DouglasWindForce(
      7, "Fort vent", 22, 28, "Vent qui brise les branches des arbres."),
  DouglasWindForce(8, "Très fort vent", 28, 34,
      "Vent qui arrache les branches des arbres et peut endommager les toits."),
  DouglasWindForce(9, "Ouragan", 34, double.infinity,
      "Vent qui cause de graves dommages aux constructions."),
];
