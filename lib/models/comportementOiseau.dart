class ComportementOiseau {
  final int id; // Identifiant unique du comportement
  final String nom; // Nom du comportement en français
  final String description; // Description du comportement

  ComportementOiseau(this.id, this.nom, this.description);
}

// Liste des comportements possibles
final List<ComportementOiseau> comportementsOiseau = [
  ComportementOiseau(
      1, "Perché", "L'oiseau est perché sur une branche ou un autre support."),
  ComportementOiseau(2, "En vol", "L'oiseau vole."),
  ComportementOiseau(
      3, "En recherche de nourriture", "L'oiseau recherche de la nourriture."),
  ComportementOiseau(4, "Chantant", "L'oiseau chante ou émet des sons."),
];
