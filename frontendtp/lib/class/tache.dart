import 'package:cloud_firestore/cloud_firestore.dart';

class Tache {
  final String docId;
  final String nomTache;
  final DateTime dateLimite;
  final DateTime dateCreation;
  final int pourcentageAvancement;
  final double pourcentageTemps;
  final String? imageUrl;
  final bool deleted;

  Tache({
    required this.docId,
    required this.nomTache,
    required this.dateLimite,
    required this.dateCreation,
    required this.pourcentageAvancement,
    required this.pourcentageTemps,
    this.imageUrl,
    this.deleted = false,
  });

  factory Tache.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Tache(
      docId: doc.id,
      nomTache: data['nomTache'] ?? '',
      dateLimite: (data['dateLimite'] as Timestamp).toDate(),
      dateCreation: (data['dateCreation'] as Timestamp).toDate(),
      pourcentageAvancement: data['pourcentageAvancement'] ?? 0,
      pourcentageTemps: data['pourcentageTemps']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'], // ← ONLY THIS FIELD
      deleted: data['deleted'] == true,
    );
  }
}