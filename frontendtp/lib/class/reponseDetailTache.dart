class ReponseDetailTache {
  final int id;
  final String nom;
  final DateTime dateLimite;
  final List<ChangementAvancement> changements;
  final int pourcentageAvancement;
  final double pourcentageTemps;

  ReponseDetailTache({
    required this.id,
    required this.nom,
    required this.dateLimite,
    required this.changements,
    required this.pourcentageAvancement,
    required this.pourcentageTemps,
  });

  factory ReponseDetailTache.fromJson(Map<String, dynamic> json) {
    return ReponseDetailTache(
      id: json['id'] as int,
      nom: json['nom'] as String,
      dateLimite: DateTime.parse(json['dateLimite'] as String),
      changements: (json['changements'] as List)
          .map((e) => ChangementAvancement.fromJson(e))
          .toList(),
      pourcentageAvancement: json['pourcentageAvancement'] as int,
      pourcentageTemps: json['pourcentageTemps'] as double,
    );
  }
}

class ChangementAvancement {
  final int valeur;
  final DateTime dateChangement;

  ChangementAvancement({
    required this.valeur,
    required this.dateChangement,
  });

  factory ChangementAvancement.fromJson(Map<String, dynamic> json) {
    return ChangementAvancement(
      valeur: json['valeur'] as int,
      dateChangement: DateTime.parse(json['dateChangement'] as String),
    );
  }
}
