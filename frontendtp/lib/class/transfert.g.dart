// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequeteAjoutTache _$RequeteAjoutTacheFromJson(Map<String, dynamic> json) =>
    RequeteAjoutTache(
      json['nom'] as String,
      _fromJson(json['dateLimite'] as String),
    );

Map<String, dynamic> _$RequeteAjoutTacheToJson(RequeteAjoutTache instance) =>
    <String, dynamic>{
      'nom': instance.nom,
      'dateLimite': _toJson(instance.dateLimite),
    };
