class RequeteConnexion {
  String nom;
  String motDePasse;

  RequeteConnexion({
    this.nom = "",
    this.motDePasse = "",
  });

  factory RequeteConnexion.fromJson(Map<String, dynamic> json) {
    return RequeteConnexion(
      nom: json['nom'] as String,
      motDePasse: json['motDePasse'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'motDePasse': motDePasse,
  };
}