import 'package:frontendtp/class/reponseDetailTache.dart';

class ReponseDetailTacheAvecPhoto extends ReponseDetailTache {
  final int? photoId;

  ReponseDetailTacheAvecPhoto({
    required super.id,
    required super.nom,
    required super.dateLimite,
    required super.changements,
    required super.pourcentageAvancement,
    required super.pourcentageTemps,
    this.photoId,
  });

  factory ReponseDetailTacheAvecPhoto.fromJson(Map<String, dynamic> json) {
    return ReponseDetailTacheAvecPhoto(
      id: json['id'] as int,
      nom: json['nom'] as String,
      dateLimite: DateTime.parse(json['dateLimite'] as String),
      changements: (json['changements'] as List)
          .map((e) => ChangementAvancement.fromJson(e))
          .toList(),
      pourcentageAvancement: (json['pourcentageAvancement'] as num).toInt(),
      pourcentageTemps: (json['pourcentageTemps'] as num).toInt(),
      photoId: json['photoId'] != null ? json['photoId'] as int : null,
    );
  }

  String? get photoUrl {
      if (photoId != null )
      return "http://10.0.2.2:8080/fichier/$photoId?largeur=1080";
  }
}
