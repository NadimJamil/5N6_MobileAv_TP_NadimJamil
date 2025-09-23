class RequeteInscription {
  String nom;
  String motDePasse;
  String confirmationMotDePasse;

  RequeteInscription({
    required this.nom,
    required this.motDePasse,
    required this.confirmationMotDePasse,
  });

  factory RequeteInscription.fromJson(Map<String, dynamic> json) {
    return RequeteInscription(
      nom: json['nom'] as String,
      motDePasse: json['motDePasse'] as String,
      confirmationMotDePasse: json['confirmationMotDePasse'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'motDePasse': motDePasse,
    'confirmationMotDePasse': confirmationMotDePasse,
  };
}
