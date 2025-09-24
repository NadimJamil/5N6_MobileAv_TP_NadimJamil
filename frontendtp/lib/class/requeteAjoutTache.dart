class RequeteAjoutTache {
  String nom = "";
  DateTime dateLimite = DateTime.now();

  RequeteAjoutTache(this.nom, this.dateLimite);

  factory RequeteAjoutTache.fromJson(Map<String, dynamic> json) {
    return RequeteAjoutTache(
        json['nom'] as String,
        json['dateLimite'] as DateTime
      );
  }

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'dateLimite': dateLimite,
  };
}