import 'package:json_annotation/json_annotation.dart';

class ReponseAccueilItem {
  int id;
  String nom;
  int pourcentageAvancement;
  int pourcentageTemps;
  DateTime dateLimite;

  ReponseAccueilItem({
    required this.id,
    required this.nom,
    required this.pourcentageAvancement,
    required this.pourcentageTemps,
    required this.dateLimite
  });

  factory ReponseAccueilItem.fromJson(Map<String, dynamic> json) {
    return ReponseAccueilItem(
      id: json['id'] as int,
      nom: json['nom'] as String,
      pourcentageAvancement: json['pourcentageAvancement'] as int,
      pourcentageTemps: json['pourcentageTemps'] as int,
      dateLimite: json['dateLimite'] as DateTime,
    );
  }
}