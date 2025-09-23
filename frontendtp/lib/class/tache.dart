import 'dart:ffi';

import 'package:uuid/uuid.dart';

class Tache {
  String idTache;
  String nom;
  double avancement;
  double tempsEcoule;
  DateTime dateLimite;

  Tache({
    required this.nom,
    required this.avancement,
    required this.tempsEcoule,
    required this.dateLimite,
  }) : idTache = const Uuid().v4();
}