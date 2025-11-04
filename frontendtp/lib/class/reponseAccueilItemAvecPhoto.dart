// dart
import 'package:frontendtp/class/reponseAccueilItem.dart';

class ReponseAccueilItemAvecPhoto extends ReponseAccueilItem {
  final int? photoId;

  ReponseAccueilItemAvecPhoto({
    required int id,
    required String nom,
    required int pourcentageAvancement,
    required int pourcentageTemps,
    required DateTime dateLimite,
    this.photoId,
  }) : super(
    id: id,
    nom: nom,
    pourcentageAvancement: pourcentageAvancement,
    pourcentageTemps: pourcentageTemps,
    dateLimite: dateLimite,
  );

  factory ReponseAccueilItemAvecPhoto.fromJson(Map<String, dynamic> json) {
    return ReponseAccueilItemAvecPhoto(
      id: json['id'] as int,
      nom: json['nom'] as String? ?? '',
      pourcentageAvancement: (json['pourcentageAvancement'] ?? 0) as int,
      pourcentageTemps: (json['pourcentageTemps'] ?? 0) as int,
      dateLimite: DateTime.parse(json['dateLimite'] as String),
      photoId: json['idPhoto'] != null ? (json['idPhoto'] as int) : null,
    );
  }
}
