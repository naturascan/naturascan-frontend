class ComportementEnSurface {
  final int id; // Identifiant unique du comportement
  final String nom; // Nom du comportement
  final String description; // Description du comportement

  ComportementEnSurface(this.id, this.nom, this.description);
}

// Liste des comportements possibles
final List<ComportementEnSurface> comportementList = [
  ComportementEnSurface(1, "Repos",
      "L'animal flotte à la surface, immobile ou avec des mouvements lents."),
  ComportementEnSurface(
      2, "Nage", "L'animal se déplace à la surface de l'eau."),
  ComportementEnSurface(3, "Saut", "L'animal saute hors de l'eau."),
  ComportementEnSurface(4, "Plonge", "L'animal plonge sous l'eau."),
  ComportementEnSurface(
      5, "Respiration", "L'animal remonte à la surface pour respirer."),
  ComportementEnSurface(
      6, "Socialisation", "L'animal interagit avec d'autres animaux."),
  ComportementEnSurface(
      7, "Alimentation", "L'animal interagit avec d'autres animaux."),
  ComportementEnSurface(
      8, "Chasse", "L'animal interagit avec d'autres animaux."),
  ComportementEnSurface(9, "Autre", "Un comportement non listé ci-dessus."),
];

final List<ComportementEnSurface> comportementOiseauList = [
  ComportementEnSurface(1, "Vol",
      "L'animal flotte à la surface, immobile ou avec des mouvements lents."),
  ComportementEnSurface(
      2, "Posé sur l'eau", "L'animal se déplace à la surface de l'eau."),
  ComportementEnSurface(3, "Alimentation", "L'animal saute hors de l'eau."),
  ComportementEnSurface(4, "Autre", "Un comportement non listé ci-dessus."),
];