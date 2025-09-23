class ReponseConnexion {
  String nomUtilisateur;

  ReponseConnexion({
    required this.nomUtilisateur,
  });

  factory ReponseConnexion.fromJson(Map<String, dynamic> json) {
    return ReponseConnexion(nomUtilisateur: json["nomUtilisateur"]);
  }
}